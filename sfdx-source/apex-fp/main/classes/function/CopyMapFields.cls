public with sharing class CopyMapFields implements SObjectToSObjectFunction {
	private Map<Schema.SObjectField, Object> fieldMap;

	public CopyMapFields(Map<Schema.SObjectField, Object> fieldMap) {
		this.fieldMap = fieldMap;
	}

	public SObject apply(SObject record) {
		for (Schema.SObjectField field : fieldMap.keySet()) {
			record.put(field, fieldMap.get(field));
		}
		return record;
	}
}	