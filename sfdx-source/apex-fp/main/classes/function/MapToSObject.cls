public with sharing class MapToSObject implements SObjectToSObjectFunction {
	Schema.SObjectType type;
	Map<String, Object> fieldValues;
	Map<String, String> fieldMappings;
	SObjectFieldReader fieldReader;
	
	public MapToSObject(Schema.SObjectType type) {
		this.type = type;
		this.fieldValues = new Map<String, Object>();
		this.fieldMappings = new Map<String, String>();
		this.fieldReader = new SObjectFieldReader();
	}

	public MapToSObject mapField(String targetFieldName, String sourceFieldRelation) {
		fieldMappings.put(targetFieldName, sourceFieldRelation);
		return this;
	}

	public MapToSObject mapField(Schema.SObjectField targetField, String sourceFieldRelation) {
		fieldMappings.put(targetField.getDescribe().getName(), sourceFieldRelation);
		return this;
	}

	public MapToSObject mapField(Schema.SObjectField targetField, Schema.SObjectField sourceField) {
		fieldMappings.put(targetField.getDescribe().getName(), sourceField.getDescribe().getName());
		return this;
	}

	public MapToSObject mapFields(Map<Schema.SObjectField, Schema.SObjectField> fieldMappings) {
		for (Schema.SObjectField targetField : fieldMappings.keySet()) {
			Schema.SObjectField sourceField = fieldMappings.get(targetField);
			mapField(targetField, sourceField);
		}
		return this;
	}

	public MapToSObject mapFields(Map<Schema.SObjectField, String> fieldMappings) {
		for (Schema.SObjectField targetField : fieldMappings.keySet()) {
			String sourceFieldRelation = fieldMappings.get(targetField);
			mapField(targetField, sourceFieldRelation);
		}
		return this;
	}

	public MapToSObject setField(String fieldName, Object value) {
		fieldValues.put(fieldName, value);
		return this;
	}

	public MapToSObject setField(Schema.SObjectField field, Object value) {
		fieldValues.put(field.getDescribe().getName(), value);
		return this;
	}

	public MapToSObject setFields(Map<Schema.SObjectField, Object> fieldValues) {
		for (Schema.SObjectField field : fieldValues.keySet()) {
			this.fieldValues.put(field.getDescribe().getName(), fieldValues.get(field));
		}
		return this;
	}

	public MapToSObject setFields(SObject prototype) {
		this.fieldValues.putAll(prototype.getPopulatedFieldsAsMap());
		return this;
	}

	public SObject call(SObject record) {
		SObject mapped = type.newSObject();
		for (String fieldName : fieldValues.keySet()) {
			mapped.put(fieldName, fieldValues.get(fieldName));
		}
		for (String targetFieldName : fieldMappings.keySet()) {
			String sourceFieldRelation = fieldMappings.get(targetFieldName);
			mapped.put(targetFieldName, fieldReader.read(record, sourceFieldRelation));
		}
		return mapped;
	}
}
