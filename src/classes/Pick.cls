public class Pick {

	public static List<SObject> fields(Iterable<SObject> records, List<Schema.SObjectField> fields) {
		return Pick.fields(records, new Set<Schema.SObjectField>(fields));
	}

	public static List<SObject> fields(Iterable<SObject> records, Set<Schema.SObjectField> fields) {
		Set<String> fieldNames = new Set<String>();
		for (Schema.SObjectField field : fields) {
			Schema.DescribeFieldResult describe = field.getDescribe();
			fieldNames.add(describe.getName());
		}
		return Pick.fields(records, fieldNames);
	}

	public static List<SObject> fields(Iterable<SObject> records, List<String> apiFieldNames) {
		return Pick.fields(records, new Set<String>(apiFieldNames));
	}

	public static List<SObject> fields(Iterable<SObject> records, Set<String> apiFieldNames) {
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