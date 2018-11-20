public class RecordTransform implements SObjectToSObjectFunction {
	private SObject prototype;
	private Map<String, Object> populatedFieldsMap;

	public SObject apply(SObject record) {

		for (String field : populatedFieldsMap.keySet()) {
			record.put(field, prototype.get(field));
		}
		return record;
	}

	public RecordTransform(sObject prototype) {
		this.prototype = prototype;
		this.populatedFieldsMap = prototype.getPopulatedFieldsAsMap();
	}
}
