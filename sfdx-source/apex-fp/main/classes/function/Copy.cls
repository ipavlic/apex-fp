public with sharing class Copy {

	public static CopyRecordFields recordFields(SObject record) {
		return new CopyRecordFields(record);
	}
}
