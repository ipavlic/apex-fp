public class MatchRecordFields implements SObjectPredicate {
	private final SObject prototype;

	public MatchRecordFields(sObject prototype) {
		this.prototype = prototype;
	}

	public Boolean call(SObject record) {
		for (String field : this.prototype.getPopulatedFieldsAsMap().keySet()) {
			if (record.get(field) != prototype.get(field)) {
				return false;
			}
		}
		return true;
	}
}
