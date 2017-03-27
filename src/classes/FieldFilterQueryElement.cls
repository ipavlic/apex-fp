/**
 * A field token filtering query element. Represents an intermediate state in query
 * construction that has to be completed with a field token operation
 */
public class FieldFilterQueryElement {

	private FieldFilterQuery query;
	private Schema.SObjectField field;

	/**
	 * Constructor. Takes a valid query and a field name to append to the query
	 * @param query Field filtering query
	 * @param field Field to be appended to the query along with an operation
	 */
	public FieldFilterQueryElement(FieldFilterQuery query, Schema.SObjectField field) {
		this.query = query;
		this.field = field;
	}

	/**
	 * Helper method. Adds a filtering criterium to the query that consists of
	 * a field with which the element was constructed, a comparison criterium and
	 * a value to compare with
	 * @param criterium Comparison criterium
	 * @param value Value to compare field with
	 */
	private FieldFilterQuery filterWith(Comparison criterium, Object value) {
		return query.addCriterium(field, criterium, value);
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

	public FieldFilterQuery notNull() {
		return notEquals(null);
	}

	public FieldFilterQuery hasValue() {
		return notNull();
	}

	public FieldFilterQuery isIn(Object setValue) {
		return filterWith(Comparison.IS_IN, setValue);
	}

	public FieldFilterQuery notIn(Object setValue) {
		return filterWith(Comparison.NOT_IN, setValue);
	}

	public FieldFilterQuery isNotIn(Object setValue) {
		return notIn(setValue);
	}
}
