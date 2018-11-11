public class IncompleteFieldsMatch {
	private FieldsMatch baseMatch;
	private String fieldPath;

	public IncompleteFieldsMatch(FieldsMatch baseMatch, Schema.SObjectField field) {
		this.baseMatch = baseMatch;
		this.fieldPath = field.getDescribe().getName();
	}

	public IncompleteFieldsMatch(FieldsMatch baseMatch, String fieldPath) {
		this.baseMatch = baseMatch;
		this.fieldPath = fieldPath;
	}

	// helper for all other methods
	private FieldsMatch filterWith(Relation relation, Object value) {
		baseMatch.addCondition(new FieldMatchCondition(fieldPath, relation, value));
		return baseMatch;
	}

	public FieldsMatch equals(Object value) {
		return filterWith(Relation.EQUALS, value);
	}

	public FieldsMatch eq(Object value) {
		return equals(value);
	}

	public FieldsMatch notEquals(Object value) {
		return filterWith(Relation.NOT_EQUALS, value);
	}

	public FieldsMatch neq(Object value) {
		return notEquals(value);
	}

	public FieldsMatch lessThan(Object value) {
		return filterWith(Relation.LESS_THAN, value);
	}

	public FieldsMatch lt(Object value) {
		return lessThan(value);
	}

	public FieldsMatch lessThanOrEquals(Object value) {
		return filterWith(Relation.LESS_THAN_OR_EQUALS, value);
	}

	public FieldsMatch leq(Object value) {
		return lessThanOrEquals(value);
	}

	public FieldsMatch greaterThan(Object value) {
		return filterWith(Relation.GREATER_THAN, value);
	}

	public FieldsMatch gt(Object value) {
		return greaterThan(value);
	}

	public FieldsMatch greaterThanOrEquals(Object value) {
		return filterWith(Relation.GREATER_THAN_OR_EQUALS, value);
	}

	public FieldsMatch geq(Object value) {
		return greaterThanOrEquals(value);
	}

	public FieldsMatch hasValue() {
		return notEquals(null);
	}

	public FieldsMatch isIn(Object value) {
		return filterWith(Relation.IS_IN, value);
	}

	public FieldsMatch notIn(Object value) {
		return filterWith(Relation.NOT_IN, value);
	}

	public FieldsMatch isNotIn(Object value) {
		return notIn(value);
	}
}
