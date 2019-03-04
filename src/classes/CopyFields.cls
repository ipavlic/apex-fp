public class CopyFields implements SObjectToSObjectFunction {

	private SObject prototype;
	private Map<String, Object> populatedFieldsMap;

	public static CopyFields fromRecord(SObject record) {
		return new CopyFields(record);
	}

	public SObject apply(SObject record) {
		for (String field : populatedFieldsMap.keySet()) {
			record.put(field, prototype.get(field));
		}
		return record;
	}

	private CopyFields(sObject prototype) {
		this.prototype = prototype;
		this.populatedFieldsMap = prototype.getPopulatedFieldsAsMap();
	}
}
