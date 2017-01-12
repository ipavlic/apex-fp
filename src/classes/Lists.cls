public class Lists {
	/**
	 * Plucks numerical field values into a new list
	 */
	public static List<Decimal> pluckNumerical(List<sObject> objects, Schema.SObjectField sObjectField) {
		List<Decimal> results = new List<Decimal>();
		for (SObject o : objects) {
			results.add((Decimal)o.get(sObjectField));
		}
		return results;
	}

	/**
	 * Plucks stringy field values into a new list (picklists, text fields, long text fields, ...)
	 */
	public static List<String> pluckStringy(List<sObject> objects, Schema.SObjectField sObjectField) {
		List<String> results = new List<String>();
		for (SObject o : objects) {
			results.add((String)o.get(sObjectField));
		}
		return results;
	}

	/**
	 * Plucks truthy field values into a new list (checkboxes, ...)
	 */
	public static List<Boolean> pluckTruthy(List<sObject> objects, Schema.SObjectField sObjectField) {
		List<Boolean> results = new List<Boolean>();
		for (SObject o : objects) {
			results.add((Boolean)o.get(sObjectField));
		}
		return results;
	}
}