public class Pluck {
	public static List<Boolean> booleans(Schema.SObjectField field, List<SObject> records) {
		List<Boolean> results = new List<Boolean>();
		for (SObject rec : records) {
			results.add((Boolean)rec.get(field));
		}
		return results;
	}
	public static List<Date> dates(Schema.SObjectField field, List<SObject> records) {
		List<Date> results = new List<Date>();
		for (SObject rec : records) {
			results.add((Date)rec.get(field));
		}
		return results;
	}
	public static List<Decimal> decimals(Schema.SObjectField field, List<SObject> records) {
		List<Decimal> results = new List<Decimal>();
		for (SObject rec : records) {
			results.add((Decimal)rec.get(field));
		}
		return results;
	}
	public Static Set<Id> ids(Schema.SObjectField field, List<SObject> records) {
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
	public static List<String> strings(Schema.SObjectField field, List<SObject> records) {
		List<String> results = new List<String>();
		for (SObject rec : records) {
			results.add((String)rec.get(field));
		}
		return results;
	}
	public static List<Boolean> booleans(String relation, List<SObject> records) {
		List<Boolean> results = new List<Boolean>();
		RelationFieldReader reader = new RelationFieldReader();
		for (SObject rec : records) {
			results.add((Boolean)reader.read(rec, relation));
		}
		return results;
	}
	public static List<Date> dates(String relation, List<SObject> records) {
		List<Date> results = new List<Date>();
		RelationFieldReader reader = new RelationFieldReader();
		for (SObject rec : records) {
			results.add((Date)reader.read(rec, relation));
		}
		return results;
	}
	public static List<Decimal> decimals(String relation, List<SObject> records) {
		List<Decimal> results = new List<Decimal>();
		RelationFieldReader reader = new RelationFieldReader();
		for (SObject rec : records) {
			results.add((Decimal)reader.read(rec, relation));
		}
		return results;
	}
	public static List<Id> ids(String relation, List<SObject> records) {
		List<Id> results = new List<Id>();
		RelationFieldReader reader = new RelationFieldReader();
		for (SObject rec : records) {
			results.add((Id)reader.read(rec, relation));
		}
		return results;
	}
	public static List<String> strings(String relation, List<SObject> records) {
		List<String> results = new List<String>();
		RelationFieldReader reader = new RelationFieldReader();
		for (SObject rec : records) {
			results.add((String) reader.read(rec, relation));
		}
		return results;
	}
}
