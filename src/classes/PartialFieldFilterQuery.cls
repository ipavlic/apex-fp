public class PartialFieldFilterQuery {
	private FieldFilterQuery query;
	private String fieldRelation;

	/**
	 * Constructor. Takes a valid query and a field name to append to the query
	 * @param query Field filtering query
	 * @param field Field to be appended to the query along with an operation
	 */
	public PartialFieldFilterQuery(FieldFilterQuery query, Schema.SObjectField field) {
		this.query = query;
		this.fieldRelation = field.getDescribe().getName();
	}

	/**
	 * Constructor. Takes a valid query and a field name to append to the query
	 * @param query Field filtering query
	 * @param field Field to be appended to the query along with an operation
	 */
	public PartialFieldFilterQuery(FieldFilterQuery query, String fieldRelation) {
		this.query = query;
		this.fieldRelation = fieldRelation;
	}


	/**
	 * Helper method. Adds a filtering criterium to the query that consists of
	 * a field with which the element was constructed, a comparison criterium and
	 * a value to compare with
	 * @param criterium Comparison criterium
	 * @param value Value to compare field with
	 */
	private FieldFilterQuery filterWith(Comparison criterium, Object value) {
		return query.addCriterium(fieldRelation, criterium, value);
	}

	/**
	 * Equality comparison
	 */
	public FieldFilterQuery equals(Object value) {
		return filterWith(Comparison.EQUALS, value);
	}

	/**
	 * equals alias method
	 */
	public FieldFilterQuery eq(Object value) {
		return equals(value);
	}

	/**
	 * Inequality comparison
	 */
	public FieldFilterQuery notEquals(Object value) {
		return filterWith(Comparison.NOT_EQUALS, value);
	}

	/**
	 * notEquals alias method
	 */
	public FieldFilterQuery neq(Object value) {
		return notEquals(value);
	}

	public FieldFilterQuery lessThan(Object value) {
		return filterWith(Comparison.LESS_THAN, value);
	}

	public FieldFilterQuery lt(Object value) {
		return lessThan(value);
	}

	public FieldFilterQuery lessThanOrEquals(Object value) {
		return filterWith(Comparison.LESS_THAN_OR_EQUALS, value);
	}

	public FieldFilterQuery leq(Object value) {
		return lessThanOrEquals(value);
	}

	public FieldFilterQuery greaterThan(Object value) {
		return filterWith(Comparison.GREATER_THAN, value);
	}

	public FieldFilterQuery gt(Object value) {
		return greaterThan(value);
	}

	public FieldFilterQuery greaterThanOrEquals(Object value) {
		return filterWith(Comparison.GREATER_THAN_OR_EQUALS, value);
	}

	public FieldFilterQuery geq(Object value) {
		return greaterThanOrEquals(value);
	}

	public FieldFilterQuery hasValue() {
		return notEquals(null);
	}

	public FieldFilterQuery isIn(Object value) {
		return filterWith(Comparison.IS_IN, value);
	}

	public FieldFilterQuery notIn(Object value) {
		return filterWith(Comparison.NOT_IN, value);
	}

	public FieldFilterQuery isNotIn(Object value) {
		return notIn(value);
	}
}