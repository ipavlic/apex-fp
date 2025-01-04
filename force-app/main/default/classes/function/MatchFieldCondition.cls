public class MatchFieldCondition {

	private static final PrimitiveComparer primitiveComparer = new PrimitiveComparer();
	private static final SObjectFieldReader fieldReader = new SObjectFieldReader();

	public String fieldPath;
	public BinaryOperation relation;
	public Object value;

	public MatchFieldCondition(String fieldPath, BinaryOperation relation, Object value) {
		this.fieldPath = fieldPath;
		this.relation = relation;
		this.value = value;
	}

	public Boolean isSatisfied(SObject record) {
		Object fieldValue = fieldReader.read(record, fieldPath);
		switch on relation {
			when IS_IN {
				return contains(value, fieldValue);
			}
			when NOT_IN {
				return !contains(value, fieldValue);
			}
			when EQUALS {
				return value == null ? fieldValue == null : primitiveComparer.compare(fieldValue, value) == 0;
			}
			when NOT_EQUALS {
				return value == null ? fieldValue != null : primitiveComparer.compare(fieldValue, value) != 0;
			}
			when LESS_THAN {
				return value == null ? false : primitiveComparer.compare(fieldValue, value) < 0;
			}
			when LESS_THAN_OR_EQUALS {
				return value == null ? false : primitiveComparer.compare(fieldValue, value) <= 0;
			}
			when GREATER_THAN {
				return value == null ? false : primitiveComparer.compare(fieldValue, value) > 0;
			}
			when GREATER_THAN_OR_EQUALS {
				return value == null ? false : primitiveComparer.compare(fieldValue, value) >= 0;
			}
			when else {
				throw new IllegalArgumentException('Relation not recognized: ' + relation);
			}
		}
	}

	private Boolean contains(Object setValue, Object value) {
		if (setValue instanceof Set<Boolean>) {
			Set<Boolean> validValues = (Set<Boolean>) setValue;
			return validValues.contains((Boolean) value);
		} else if (setValue instanceof Set<Date>) {
			Set<Date> validValues = (Set<Date>) setValue;
			return validValues.contains((Date) value);
		} else if (setValue instanceof Set<Datetime>) {
			Set<Datetime> validValues = (Set<Datetime>) setValue;
			return validValues.contains((Datetime) value);
		} else if (setValue instanceof Set<Decimal>) {
			Set<Decimal> validValues = (Set<Decimal>) setValue;
			return validValues.contains((Decimal) value);
		} else if (setValue instanceof Set<Double>) {
			Set<Double> validValues = (Set<Double>) setValue;
			return validValues.contains((Double) value);
		} else if (setValue instanceof Set<Id>) {
			Set<Id> validValues = (Set<Id>) setValue;
			return validValues.contains((Id) value);
		} else if (setValue instanceof Set<Integer>) {
			Set<Integer> validValues = (Set<Integer>) setValue;
			return validValues.contains((Integer) value);
		} else if (setValue instanceof Set<Long>) {
			Set<Long> validValues = (Set<Long>) setValue;
			return validValues.contains((Long) value);
		} else if (setValue instanceof Set<String>) {
			Set<String> validValues = (Set<String>) setValue;
			return validValues.contains((String) value);
		}
		throw new IllegalArgumentException('Provided set type is not supported');
	}
}
