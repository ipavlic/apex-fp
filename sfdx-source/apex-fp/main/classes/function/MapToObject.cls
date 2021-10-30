public with sharing class MapToObject implements SObjectToObjectFunction {
	Type type;
	Map<String, String> fieldMappings;
	SObjectFieldReader fieldReader;
	Map<String, Object> fieldValues = new Map<String, Object>(); 
	
	public MapToObject(Type type) {
		this.type = type;
		this.fieldValues = new Map<String, Object>();
		this.fieldMappings = new Map<String, String>();
		this.fieldReader = new SObjectFieldReader();
	}

	private Object setField(Map<String, Object> objectData, String path, Object value) {
		Integer dotPos = path.indexOf('.');
		if (dotPos == -1) {
			return objectData.put(path, value);
		} else {
			String childObject = path.substring(0, dotPos);
			String remainingPath = path.substring(dotPos + 1, path.length());
	
			if (!objectData.containsKey(childObject)) {
				objectData.put(childObject, new Map<String, Object>());
			}
			Map<String, Object> childObjectData = (Map<String, Object>) objectData.get(childObject);
			return setField(childObjectData, remainingPath, value);
		}
	}

	public MapToObject setField(String targetFieldPath, Object value) {
		setField(fieldValues, targetFieldPath, value);
		return this;
	}

	public MapToObject setFields(Map<String, Object> fieldValues) {
		for (String targetFieldPath : fieldValues.keySet()) {
			setField(targetFieldPath, fieldValues.get(targetFieldPath));
		}
		return this;
	}

	public MapToObject mapField(String targetFieldPath, String sourceFieldRelation) {
		fieldMappings.put(targetFieldPath, sourceFieldRelation);
		return this;
	}

	public MapToObject mapField(String targetFieldPath, Schema.SObjectField sourceField) {
		fieldMappings.put(targetFieldPath, sourceField.getDescribe().getName());
		return this;
	}

	public MapToObject mapFields(Map<String, Schema.SObjectField> fieldMappings) {
		for (String targetFieldPath : fieldMappings.keySet()) {
			Schema.SObjectField sourceField = fieldMappings.get(targetFieldPath);
			mapField(targetFieldPath, sourceField);
		}
		return this;
	}

	public MapToObject mapFields(Map<String, String> fieldMappings) {
		for (String targetFieldPath : fieldMappings.keySet()) {
			String sourceFieldRelation = fieldMappings.get(targetFieldPath);
			mapField(targetFieldPath, sourceFieldRelation);
		}
		return this;
	}

	public Object call(SObject record) {
		for (String targetFieldPath : fieldMappings.keySet()) {
			String sourceFieldRelation = fieldMappings.get(targetFieldPath);
			setField(targetFieldPath, fieldReader.read(record, sourceFieldRelation));
		}
		return JSON.deserialize(JSON.serialize(fieldValues), type);		
	}
}
