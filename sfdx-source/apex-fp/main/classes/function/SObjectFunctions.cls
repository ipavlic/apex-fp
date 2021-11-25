public with sharing class SObjectFunctions {
	public static ModifySObject Modify {
		get {
			return new ModifySObject();
		}
	}

	public static SObjectPredicate NotNull = new NotNull();
	public static SObjectFunction Debug = new Debug();

	public static MapToSObject MapTo(Schema.SObjectType type) {
		return new MapToSObject(type);
	}

	public static MapToObject MapTo(Type type) {
		return new MapToObject(type);
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

	public class Debug implements SObjectFunction {
		private LoggingLevel logLevel = LoggingLevel.DEBUG;

		public Debug logLevel(LoggingLevel logLevel) {
			this.logLevel = logLevel;
			return this;
		}

		public void call(SObject record) {
			System.debug(logLevel, record);
		}
	}
}
