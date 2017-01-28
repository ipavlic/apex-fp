public class Pluck {
	public static List<Boolean> booleans(List<SObject> records, Schema.SObjectField field) {
		List<Boolean> results = new List<Boolean>();
		for (SObject rec : records) {
			results.add((Boolean)rec.get(field));
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
	public Static List<Id> ids(List<SObject> records, Schema.SObjectField field) {
		List<Id> results = new List<Id>();
		for (SObject rec : records) {
			results.add((Id)rec.get(field));
		}
		return results;
	}
	public Static List<Id> ids(List<SObject> records) {
		List<Id> results = new List<Id>();
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
}