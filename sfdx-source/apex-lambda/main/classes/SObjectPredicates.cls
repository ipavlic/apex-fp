public with sharing class SObjectPredicates {
    
	public static SObjectPredicate AlwaysTrue = new AlwaysTrue();
	public static SObjectPredicate NotNull = new NotNull();

	private class AlwaysTrue implements SObjectPredicate {
		public Boolean apply(Object obj) {
			return true;
		}
	}

    private class NotNull implements SObjectPredicate {
		public Boolean apply(SObject record) {
			return record != null;
		}
	}
}
