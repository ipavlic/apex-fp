public with sharing class MapTo {
	public static MapToSObject SObject(Schema.SObjectType type) {
		return new MapToSObject(type);
	}
}
