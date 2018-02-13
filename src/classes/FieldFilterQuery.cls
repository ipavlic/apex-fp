public class FieldFilterQuery extends FilterQuery {
	private List<FieldFilterQueryCriterium> queryCriteria = new List<FieldFilterQueryCriterium>();
	private PrimitiveComparer comparer = new PrimitiveComparer();

	public FieldFilterQuery addCriterium(String fieldRelation, Comparison criterium, Object value) {
		this.queryCriteria.add(new FieldFilterQueryCriterium(fieldRelation, criterium, value));
		return this;
	}

	public PartialFieldFilterQuery field(Schema.SObjectField field) {
		return new PartialFieldFilterQuery(this, field);
	}

	public PartialFieldFilterQuery field(String fieldRelation) {
		return new PartialFieldFilterQuery(this, fieldRelation);
	}

	public PartialFieldFilterQuery also(Schema.SObjectField field) {
		return this.field(field);
	}

	public PartialFieldFilterQuery also(String fieldRelation) {
		return this.field(fieldRelation);
	}

	private Boolean contains(Object valueSet, Object value) {
		if (valueSet instanceof Set<Boolean>) {
			Set<Boolean> validValues = (Set<Boolean>) valueSet;
			return validValues.contains((Boolean) value);
		} else if (valueSet instanceof Set<Date>) {
			Set<Date> validValues = (Set<Date>) valueSet;
			return validValues.contains((Date) value);
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
		} else if (valueSet instanceof Set<String>) {
			Set<String> validValues = (Set<String>) valueSet;
			return validValues.contains((String) value);
		}
		throw new LambdaException('Provided set type is not supported by the filter');
	}

	public override Boolean isValid(sObject record) {
		Boolean isValid = true;
		PrimitiveComparer comparer = new PrimitiveComparer();
		RelationFieldReader reader = new RelationFieldReader();
		for (FieldFilterQueryCriterium c : queryCriteria) {
			Object fieldValue = reader.read(record, c.fieldRelation);
			if (c.criterium == Comparison.EQUALS && comparer.compare(fieldValue, c.value) != Comparison.EQUALS) {
	 			isValid = false;
				break;
			}
			if (c.criterium == Comparison.NOT_EQUALS && comparer.compare(fieldValue, c.value) == Comparison.EQUALS) {
				isValid = false;
				break;
			}
			if (c.criterium == Comparison.LESS_THAN && comparer.compare(fieldValue, c.value) != Comparison.LESS_THAN) {
				isValid = false;
				break;
			}
			if (c.criterium == Comparison.LESS_THAN_OR_EQUALS && (comparer.compare(fieldValue, c.value) == Comparison.GREATER_THAN || comparer.compare(fieldValue, c.value) == Comparison.NOT_EQUALS)) {
				isValid = false;
				break;
			}
			if (c.criterium == Comparison.GREATER_THAN && comparer.compare(fieldValue, c.value) != Comparison.GREATER_THAN) {
				isValid = false;
				break;
			}
			if (c.criterium == Comparison.GREATER_THAN_OR_EQUALS && (comparer.compare(fieldValue, c.value) == Comparison.LESS_THAN || comparer.compare(fieldValue, c.value) == Comparison.NOT_EQUALS)) {
				isValid = false;
				break;
			}
			if (c.criterium == Comparison.IS_IN && (contains(c.value, fieldValue) == false)) {
				isValid = false;
				break;
			}
			if (c.criterium == Comparison.NOT_IN && (contains(c.value, fieldValue) == true)) {
				isValid = false;
				break;
			}
		}
		return isValid;
	}
}