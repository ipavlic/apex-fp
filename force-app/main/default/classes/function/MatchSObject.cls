public with sharing class MatchSObject {
	public RecordFieldsMatch recordFields(SObject prototype) {
		return new RecordFieldsMatch(prototype);
	}

	public IncompleteFieldsMatch field(Schema.SObjectField field) {
		return new IncompleteFieldsMatch(new FieldsMatch(), field);
	}

	public IncompleteFieldsMatch field(String fieldPath) {
		return new IncompleteFieldsMatch(new FieldsMatch(), fieldPath);
	}
}
