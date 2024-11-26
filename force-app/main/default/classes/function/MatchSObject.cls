public with sharing class MatchSObject {
	public MatchRecordFields recordFields(SObject prototype) {
		return new MatchRecordFields(prototype);
	}

	public IncompleteMatchFields field(Schema.SObjectField field) {
		return new IncompleteMatchFields(new MatchFields(), field);
	}

	public IncompleteMatchFields field(String fieldPath) {
		return new IncompleteMatchFields(new MatchFields(), fieldPath);
	}
}
