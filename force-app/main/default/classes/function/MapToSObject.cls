public with sharing class MapToSObject implements SObjectToSObjectFunction {
	private final Schema.SObjectType type;
	private final Map<String, Object> fieldValues = new Map<String, Object>();
	private final Map<String, String> fieldMappings = new Map<String, String>();
	private final SObjectFieldReader fieldReader = new SObjectFieldReader();

	public MapToSObject(Schema.SObjectType type) {
		this.type = type;
	}

	public MapToSObject mapField(String targetFieldName, String sourceFieldRelation) {
		this.fieldMappings.put(targetFieldName, sourceFieldRelation);
		return this;
	}

	public MapToSObject mapField(Schema.SObjectField targetField, String sourceFieldRelation) {
		this.fieldMappings.put(targetField.getDescribe().getName(), sourceFieldRelation);
		return this;
	}

	public MapToSObject mapField(Schema.SObjectField targetField, Schema.SObjectField sourceField) {
		this.fieldMappings.put(targetField.getDescribe().getName(), sourceField.getDescribe().getName());
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
		this.fieldValues.put(fieldName, value);
		return this;
	}

	public MapToSObject setField(Schema.SObjectField field, Object value) {
		this.fieldValues.put(field.getDescribe().getName(), value);
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
		SObject mapped = this.type.newSObject();
		for (String fieldName : this.fieldValues.keySet()) {
			mapped.put(fieldName, this.fieldValues.get(fieldName));
		}
		for (String targetFieldName : this.fieldMappings.keySet()) {
			String sourceFieldRelation = this.fieldMappings.get(targetFieldName);
			mapped.put(targetFieldName, this.fieldReader.read(record, sourceFieldRelation));
		}
		return mapped;
	}
}
