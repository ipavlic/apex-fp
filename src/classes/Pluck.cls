public class Pluck {
	public static List<Boolean> booleans(List<SObject> records, Schema.SObjectField field) {
		List<Boolean> results = new List<Boolean>();
		for (SObject rec : records) {
			results.add((Boolean)rec.get(field));
		}
		return results;
	}
	public static List<Date> dates(List<SObject> records, Schema.SObjectField field) {
		List<Date> results = new List<Date>();
		for (SObject rec : records) {
			results.add((Date)rec.get(field));
		}
		return results;
	}
	public static List<Decimal> decimals(List<SObject> records, Schema.SObjectField field) {
		List<Decimal> results = new List<Decimal>();
		for (SObject rec : records) {
			results.add((Decimal)rec.get(field));
		}
		return results;
	}
	public Static Set<Id> ids(List<SObject> records, Schema.SObjectField field) {
		Set<Id> results = new Set<Id>();
		for (SObject rec : records) {
			results.add((Id)rec.get(field));
		}
		return results;
	}
	public Static Set<Id> ids(List<SObject> records) {
		Set<Id> results = new Set<Id>();
		for (SObject rec : records) {
			results.add(rec.Id);
		}
		return results;
	}
	public static List<String> strings(List<SObject> records, Schema.SObjectField field) {
		List<String> results = new List<String>();
		for (SObject rec : records) {
			results.add((String)rec.get(field));
		}
		return results;
	}
	public static List<Boolean> booleans(List<SObject> records, String relation) {
		List<Boolean> results = new List<Boolean>();
		RelationFieldReader reader = new RelationFieldReader();
		for (SObject rec : records) {
			results.add((Boolean)reader.read(rec, relation));
		}
		return results;
	}
	public static List<Date> dates(List<SObject> records, String relation) {
		List<Date> results = new List<Date>();
		RelationFieldReader reader = new RelationFieldReader();
		for (SObject rec : records) {
			results.add((Date)reader.read(rec, relation));
		}
		return results;
	}
	public static List<Decimal> decimals(List<SObject> records, String relation) {
		List<Decimal> results = new List<Decimal>();
		RelationFieldReader reader = new RelationFieldReader();
		for (SObject rec : records) {
			results.add((Decimal)reader.read(rec, relation));
		}
		return results;
	}
	public static List<Id> ids(List<SObject> records, String relation) {
		List<Id> results = new List<Id>();
		RelationFieldReader reader = new RelationFieldReader();
		for (SObject rec : records) {
			results.add((Id)reader.read(rec, relation));
		}
		return results;
	}
	public static List<String> strings(List<SObject> records, String relation) {
		List<String> results = new List<String>();
		RelationFieldReader reader = new RelationFieldReader();
		for (SObject rec : records) {
			results.add((String)reader.read(rec, relation));
		}
		return results;
	}
}