public with sharing class Fn {

	public static AssignToSObject AssignTo {
		get {
			return new AssignToSObject();
		}
	}

	public static SObjectPredicate NotNull = new NotNull();

	public static MapToSObject MapToSObject(Schema.SObjectType type) {
		return new MapToSObject(type);
	}

	public static Match Match = new Match();

	public class Match {
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

	public class NotNull implements SObjectPredicate {
		public Boolean call(SObject record) {
			return record != null;
		}
	}
}