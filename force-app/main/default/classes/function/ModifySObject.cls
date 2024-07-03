public with sharing class ModifySObject implements SObjectFunction {
	private final Map<String, Object> fieldValues = new Map<String, Object>();

	public ModifySObject setField(String targetFieldName, Object value) {
		this.fieldValues.put(targetFieldName, value);
		return this;
	}

	public ModifySObject setField(Schema.SObjectField field, Object value) {
		this.fieldValues.put(field.getDescribe().getName(), value);
		return this;
	}

	public ModifySObject setFields(Map<Schema.SObjectField, Object> newFieldValues) {
		for (Schema.SObjectField field : newFieldValues.keySet()) {
			this.fieldValues.put(field.getDescribe().getName(), newFieldValues.get(field));
		}
		return this;
	}

	public ModifySObject setFields(SObject prototype) {
		this.fieldValues.putAll(prototype.getPopulatedFieldsAsMap());
		return this;
	}

	public void call(SObject record) {
		if (record == null) {
			throw new LambdaException('Record is null');
		}
		for (String fieldName : this.fieldValues.keySet()) {
			record.put(fieldName, this.fieldValues.get(fieldName));
		}
	}
}
