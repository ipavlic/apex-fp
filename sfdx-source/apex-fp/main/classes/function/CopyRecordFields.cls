public with sharing class CopyRecordFields implements SObjectToSObjectFunction {
	private SObject prototype;
	private Map<String, Object> populatedFieldsMap;

	public CopyRecordFields(SObject prototype) {
		this.prototype = prototype;
		this.populatedFieldsMap = prototype.getPopulatedFieldsAsMap();
	}

	public SObject apply(SObject record) {
		for (String field : populatedFieldsMap.keySet()) {
			record.put(field, prototype.get(field));
		}
		return record;
	}
}