public with sharing class Fn {

	public static SObjectNotNull NotNull = new SObjectNotNull();
	public static MatchSObject Match = new MatchSObject();

	public static ModifySObject Modify {
		get {
			return new ModifySObject();
		}
	}

	public static DebugSObject Debug {
		get {
			return new DebugSObject();
		}
	}

	public static MapToSObject MapTo(Schema.SObjectType type) {
		return new MapToSObject(type);
	}

	public static MapToObject MapTo(Type type) {
		return new MapToObject(type);
	}
}