public class Match {
	public static RecordMatch record(SObject record) {
		return new RecordMatch(record);
	}

	public static IncompleteFieldsMatch field(Schema.SObjectField field) {
		return new IncompleteFieldsMatch(new FieldsMatch(), field);
	}

	public static IncompleteFieldsMatch field(String fieldPath) {
		return new IncompleteFieldsMatch(new FieldsMatch(), fieldPath);
	}
}
