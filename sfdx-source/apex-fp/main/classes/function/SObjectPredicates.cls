public with sharing class SObjectPredicates {
    
	public static SObjectPredicate NotNull = new NotNull();

    private class NotNull implements SObjectPredicate {
		public Boolean call(SObject record) {
			return record != null;
		}
	}
}
