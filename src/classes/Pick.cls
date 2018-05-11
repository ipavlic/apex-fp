public class Pick {

	public static List<SObject> fields(List<Schema.SObjectField> fields, Iterable<SObject> records) {
		return Pick.fields(new Set<Schema.SObjectField>(fields), records);
	}

	public static List<SObject> fields(Set<Schema.SObjectField> fields, Iterable<SObject> records) {
		Set<String> fieldNames = new Set<String>();
		for (Schema.SObjectField field : fields) {
			Schema.DescribeFieldResult describe = field.getDescribe();
			fieldNames.add(describe.getName());
		}
		return Pick.fields(fieldNames, records);
	}

	public static List<SObject> fields(List<String> apiFieldNames, Iterable<SObject> records) {
		return Pick.fields(new Set<String>(apiFieldNames), records);
	}

	public static List<SObject> fields(Set<String> apiFieldNames, Iterable<SObject> records) {
		List<SObject> results = new List<SObject>();
		Iterator<SObject> iter = records.iterator();
		while (iter.hasNext()) {
			SObject obj = iter.next();
			SObject picked = obj.getSObjectType().newSObject();
			Map<String, Object> fieldMap = obj.getPopulatedFieldsAsMap();
			for (String fieldName : apiFieldNames) {
				if (fieldMap.containsKey(fieldName)) {
					picked.put(fieldName, obj.get(fieldName));
				}
			}
			results.add(picked);
		}
		return results;
	}
}
