public with sharing class AssignToSObject implements SObjectFunction {

	Map<String, Object> fieldValues;

	public AssignToSObject() {
		this.fieldValues = new Map<String, Object>();
	}

	public AssignToSObject setField(String targetFieldName, Object value) {
		fieldValues.put(targetFieldName, value);
		return this;
	}

	public AssignToSObject setField(Schema.SObjectField field, Object value) {
		fieldValues.put(field.getDescribe().getName(), value);
		return this;
	}

	public AssignToSObject setFields(Map<Schema.SObjectField, Object> fieldValues) {
		for (Schema.SObjectField field : fieldValues.keySet()) {
			this.fieldValues.put(field.getDescribe().getName(), fieldValues.get(field));
		}
		return this;
	}

	public AssignToSObject setFields(SObject prototype) {
		this.fieldValues.putAll(prototype.getPopulatedFieldsAsMap());
		return this;
	}

	public void call(SObject record) {
		if (record == null) {
			throw new LambdaException('Record is null');
		}
		for (String fieldName : fieldValues.keySet()) {
			record.put(fieldName, fieldValues.get(fieldName));
		}
	}
}
