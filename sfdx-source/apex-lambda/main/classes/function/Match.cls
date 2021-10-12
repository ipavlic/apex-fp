public class Match {
	public static RecordMatch record(SObject prototype) {
		return new RecordMatch(prototype);
	}

	public static IncompleteFieldsMatch field(Schema.SObjectField field) {
		return new IncompleteFieldsMatch(new FieldsMatch(), field);
	}

	public static IncompleteFieldsMatch field(String fieldPath) {
		return new IncompleteFieldsMatch(new FieldsMatch(), fieldPath);
	}
}
