public class RecordFieldsMatch implements SObjectPredicate {
	private SObject prototype;
	private Map<String, Object> populatedFieldsMap;

	public Boolean call(SObject record) {
		for (String field : populatedFieldsMap.keySet()) {
			if (record.get(field) != prototype.get(field)) {
				return false;
			}
		}
		return true;
	}

	public RecordFieldsMatch(sObject prototype) {
		this.prototype = prototype;
		this.populatedFieldsMap = prototype.getPopulatedFieldsAsMap();
	}
}
