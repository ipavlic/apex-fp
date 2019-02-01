public class FieldsMatch implements SObjectPredicate {

	private PrimitiveComparer primitiveComparer = new PrimitiveComparer();
	private SObjectFieldReader fieldReader = new SObjectFieldReader();

	private static Set<BinaryRelation> setComparisons = new Set<BinaryRelation>{
		BinaryRelation.IS_IN,
		BinaryRelation.NOT_IN
	};

	private List<FieldMatchCondition> matchConditions;

	public FieldsMatch() {
		this.matchConditions = new List<FieldMatchCondition>();
	}

	public FieldsMatch addCondition(FieldMatchCondition condition) {
		matchConditions.add(condition);
		return this;
	}

	public IncompleteFieldsMatch also(Schema.SObjectField field) {
		return field(field);
	}

	public IncompleteFieldsMatch also(String fieldPath) {
		return field(fieldPath);
	}

	public IncompleteFieldsMatch field(Schema.SObjectField field) {
		return new IncompleteFieldsMatch(this, field);
	}

	public IncompleteFieldsMatch field(String fieldPath) {
		return new IncompleteFieldsMatch(this, fieldPath);
	}

	public Boolean apply(SObject record) {
		for (FieldMatchCondition condition : matchConditions) {
			if (!conditionSatisfied(condition, record)) {
				return false;
			}
		}
		return true;
	}

	private Boolean conditionSatisfied(FieldMatchCondition condition, SObject record) {
		Object fieldValue = fieldReader.read(record, condition.fieldPath);
		if (setComparisons.contains(condition.relation)) {
			return setConditionSatisfied(condition, fieldValue);
		} else {
			return comparisonConditionSatisfied(condition, fieldValue);
		}
	}

	private Boolean setConditionSatisfied(FieldMatchCondition condition, Object fieldValue) {
		Boolean isValueContained = contains(condition.value, fieldValue);
		switch on condition.relation {
			when IS_IN {
				return isValueContained == true;
			}
			when NOT_IN {
				return isValueContained == false;
			}
			when else {
				return false;
			}
		}
	}

	private Boolean comparisonConditionSatisfied(FieldMatchCondition condition, Object fieldValue) {
		ComparisonResult result = primitiveComparer.compare(fieldValue, condition.value);
		switch on condition.relation {
			when EQUALS {
				return result == ComparisonResult.EQUALS;
			}
			when NOT_EQUALS {
				return result == ComparisonResult.NOT_EQUALS;
			}
			when LESS_THAN {
				return result == ComparisonResult.LESS_THAN;
			}
			when LESS_THAN_OR_EQUALS {
				return result == ComparisonResult.LESS_THAN || result == ComparisonResult.EQUALS;
			}
			when GREATER_THAN {
				return result == ComparisonResult.GREATER_THAN;
			}
			when GREATER_THAN_OR_EQUALS {
				return result == ComparisonResult.GREATER_THAN || result == ComparisonResult.EQUALS;
			}
			when else {
				return false;
			}
		}
	}

	private Boolean contains(Object valueSet, Object value) {
		if (valueSet instanceof Set<Boolean>) {
			Set<Boolean> validValues = (Set<Boolean>) valueSet;
			return validValues.contains((Boolean) value);
		} else if (valueSet instanceof Set<Date>) {
			Set<Date> validValues = (Set<Date>) valueSet;
			return validValues.contains((Date) value);
		} else if (valueSet instanceof Set<Datetime>) {
			Set<Datetime> validValues = (Set<Datetime>) valueSet;
			return validValues.contains((Datetime) value);
		} else if (valueSet instanceof Set<Decimal>) {
			Set<Decimal> validValues = (Set<Decimal>) valueSet;
			return validValues.contains((Decimal) value);
		} else if (valueSet instanceof Set<Double>) {
			Set<Double> validValues = (Set<Double>) valueSet;
			return validValues.contains((Double) value);
		} else if (valueSet instanceof Set<Id>) {
			Set<Id> validValues = (Set<Id>) valueSet;
			return validValues.contains((Id) value);
		} else if (valueSet instanceof Set<Integer>) {
			Set<Integer> validValues = (Set<Integer>) valueSet;
			return validValues.contains((Integer) value);
		} else if (valueSet instanceof Set<Long>) {
			Set<Long> validValues = (Set<Long>) valueSet;
			return validValues.contains((Long) value);
		} else if (valueSet instanceof Set<String>) {
			Set<String> validValues = (Set<String>) valueSet;
			return validValues.contains((String) value);
		}
		throw new LambdaException('Provided set type is not supported by the filter.');
	}
}
