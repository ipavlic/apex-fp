public class GroupBy {
	public static Map<Boolean, List<sObject>> booleans(Schema.SObjectField field, List<SObject> records, Type listType) {
		Map<Boolean, List<SObject>> grouped = new Map<Boolean, List<SObject>>();
		for (sObject rec : records) {
			Boolean key = (Boolean)rec.get(field);
			if (!grouped.containsKey(key)) {
				grouped.put(key, (List<SObject>)listType.newInstance());
			}
			grouped.get(key).add(rec);
		}
		return grouped;
	}

	public static Map<Boolean, List<sObject>> booleans(Schema.SObjectField field, List<SObject> records) {
		return booleans(field, records, List<SObject>.class);
	}

	public static Map<Date, List<sObject>> dates(Schema.SObjectField field, List<SObject> records, Type listType) {
		Map<Date, List<SObject>> grouped = new Map<Date, List<SObject>>();
		for (sObject rec : records) {
			Date key = (Date)rec.get(field);
			if (!grouped.containsKey(key)) {
				grouped.put(key, (List<SObject>)listType.newInstance());
			}
			grouped.get(key).add(rec);
		}
		return grouped;
	}

	public static Map<Date, List<sObject>> dates(Schema.SObjectField field, List<SObject> records) {
		return dates(field, records, List<SObject>.class);
	}

	public static Map<Decimal, List<sObject>> decimals(Schema.SObjectField field, List<SObject> records, Type listType) {
		Map<Decimal, List<SObject>> grouped = new Map<Decimal, List<SObject>>();
		for (sObject rec : records) {
			Decimal key = (Decimal)rec.get(field);
			if (!grouped.containsKey(key)) {
				grouped.put(key, (List<SObject>)listType.newInstance());
			}
			grouped.get(key).add(rec);
		}
		return grouped;
	}

	public static Map<Decimal, List<sObject>> decimals(Schema.SObjectField field, List<SObject> records) {
		return decimals(field, records, List<SObject>.class);
	}

	public static Map<Id, List<sObject>> ids(Schema.SObjectField field, List<SObject> records, Type listType) {
		Map<Id, List<SObject>> grouped = new Map<Id, List<SObject>>();
		for (sObject rec : records) {
			Id key = (Id)rec.get(field);
			if (!grouped.containsKey(key)) {
				grouped.put(key, (List<SObject>)listType.newInstance());
			}
			grouped.get(key).add(rec);
		}
		return grouped;
	}

	public static Map<Id, List<sObject>> ids(Schema.SObjectField field, List<SObject> records) {
		return ids(field, records, List<SObject>.class);
	}

	public static Map<String, List<sObject>> strings(Schema.SObjectField field, List<SObject> records, Type listType) {
		Map<String, List<SObject>> grouped = new Map<String, List<SObject>>();
		for (sObject rec : records) {
			String key = (String)rec.get(field);
			if (!grouped.containsKey(key)) {
				grouped.put(key, (List<SObject>)listType.newInstance());
			}
			grouped.get(key).add(rec);
		}
		return grouped;
	}

	public static Map<String, List<sObject>> strings(Schema.SObjectField field, List<SObject> records) {
		return strings(field, records, List<SObject>.class);
	}
}
