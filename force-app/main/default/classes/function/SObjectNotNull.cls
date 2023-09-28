public with sharing class SObjectNotNull implements SObjectPredicate  {
	public Boolean call(SObject record) {
		return record != null;
	}
}
