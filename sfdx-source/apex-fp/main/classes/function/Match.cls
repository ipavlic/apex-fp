public class Match {
	public static RecordFieldsMatch recordFields(SObject prototype) {
		return new RecordFieldsMatch(prototype);
	}

	public static IncompleteFieldsMatch field(Schema.SObjectField field) {
		return new IncompleteFieldsMatch(new FieldsMatch(), field);
	}

	public static IncompleteFieldsMatch field(String fieldPath) {
		return new IncompleteFieldsMatch(new FieldsMatch(), fieldPath);
	}
}
