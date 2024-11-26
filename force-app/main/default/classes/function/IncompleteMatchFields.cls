public class IncompleteMatchFields {
	private final MatchFields baseMatch;
	private final String fieldPath;

	public IncompleteMatchFields(MatchFields baseMatch, Schema.SObjectField field) {
		this.baseMatch = baseMatch;
		this.fieldPath = field.getDescribe().getName();
	}

	public IncompleteMatchFields(MatchFields baseMatch, String fieldPath) {
		this.baseMatch = baseMatch;
		this.fieldPath = fieldPath;
	}

	// helper for all other methods
	private MatchFields filterWith(BinaryRelation relation, Object value) {
		this.baseMatch.addCondition(new MatchFieldCondition(this.fieldPath, relation, value));
		return this.baseMatch;
	}

	public MatchFields equals(Object value) {
		return filterWith(BinaryRelation.EQUALS, value);
	}

	public MatchFields eq(Object value) {
		return equals(value);
	}

	public MatchFields notEquals(Object value) {
		return filterWith(BinaryRelation.NOT_EQUALS, value);
	}

	public MatchFields neq(Object value) {
		return notEquals(value);
	}

	public MatchFields lessThan(Object value) {
		return filterWith(BinaryRelation.LESS_THAN, value);
	}

	public MatchFields lt(Object value) {
		return lessThan(value);
	}

	public MatchFields lessThanOrEquals(Object value) {
		return filterWith(BinaryRelation.LESS_THAN_OR_EQUALS, value);
	}

	public MatchFields leq(Object value) {
		return lessThanOrEquals(value);
	}

	public MatchFields greaterThan(Object value) {
		return filterWith(BinaryRelation.GREATER_THAN, value);
	}

	public MatchFields gt(Object value) {
		return greaterThan(value);
	}

	public MatchFields greaterThanOrEquals(Object value) {
		return filterWith(BinaryRelation.GREATER_THAN_OR_EQUALS, value);
	}

	public MatchFields geq(Object value) {
		return greaterThanOrEquals(value);
	}

	public MatchFields hasValue() {
		return notEquals(null);
	}

	public MatchFields isIn(Object value) {
		return filterWith(BinaryRelation.IS_IN, value);
	}

	public MatchFields notIn(Object value) {
		return filterWith(BinaryRelation.NOT_IN, value);
	}

	public MatchFields isNotIn(Object value) {
		return notIn(value);
	}
}
