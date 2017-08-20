/**
 * Starting class for filtering queries on the list
 */
public class Filter {
	/**
	 * Initiates a matching filtering query
	 * @param obj Object to compare to in a query
	 */
	public static MatchingFilterQuery match(sObject prototype) {
		return new MatchingFilterQuery(prototype);
	}

	/**
	 * Initiates a field token filtering query
	 * @param token Field token to query
	 */
	public static FieldFilterQueryElement field(Schema.SObjectField field) {
		return new FieldFilterQueryElement(new FieldFilterQuery(), field);
	}
}
