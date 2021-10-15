public with sharing class Copy {

	public static CopyRecordFields recordFields(SObject record) {
		return new CopyRecordFields(record);
	}

	public static CopyMapFields mapFields(Map<Schema.SObjectField, Object> fieldMap) {
		return new CopyMapFields(fieldMap);
	}
}
