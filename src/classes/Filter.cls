/**
 * Starting class for filtering queries on the list
 */
public class Filter {
	/**
	 * Initiates a matching filtering query
	 * @param obj Object to compare to in a query
	 */
	public static RecordMatchingFilterQuery match(sObject prototype) {
		return new RecordMatchingFilterQuery(prototype);
	}

	/**
	 * Initiates a filtering query with field token
	 * @param token Field token to query
	 */
	public static PartialFieldFilterQuery field(Schema.SObjectField field) {
		return new PartialFieldFilterQuery(new FieldFilterQuery(), field);
	}

	/**
	 * Initiates a filtering query with field relation
	 * @param token Field token to query
	 */
	public static PartialFieldFilterQuery field(String fieldRelation) {
		return new PartialFieldFilterQuery(new FieldFilterQuery(), fieldRelation);
	}
}