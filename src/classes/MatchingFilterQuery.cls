public class MatchingFilterQuery extends FilterQuery {

	private sObject obj;
	private Map<String, Object> availableFields = new Map<String, Object>();

	/**
	 * Constructor. Takes a comparison sObject to compare list elements with.
	 * The comparison checks for equality with the comparison object and only
	 * non-null fields are considered.
	 * @param obj Comparison sObject
	 */
	public MatchingFilterQuery(sObject obj) {
		this.obj = obj;
		for (String field : obj.getSObjectType().getDescribe().fields.getMap().keyset()) {
			if (obj.get(field) != null) {
				availableFields.put(field, obj.get(field));
			}
		}
	}

	public override Boolean isValid(sObject o) {
		Boolean isValid = true;
		for (String field : availableFields.keySet()) {
			if (obj.get(field) != o.get(field)) {
				isValid = false;
				break;
			}
		}
		return isValid;
	}
}