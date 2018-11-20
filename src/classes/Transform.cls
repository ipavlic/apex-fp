public with sharing class Transform {
	public static RecordTransform record(SObject record) {
		return new RecordTransform(record);
	}
}
