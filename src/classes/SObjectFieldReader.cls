public class SObjectFieldReader {
	static Map<String, String[]> relationPartsCache = new Map<String, String[]>();

	private String[] relationParts(String relation) {
		String[] parts = relationPartsCache.get(relation);
		if (parts == null) {
			parts = relation.split('\\.');
			relationPartsCache.put(relation, parts);
		}
		return parts;
	}

	public Object read(SObject record, String relation) {
		if (String.isBlank(relation)) {
			throw new LambdaException('Provided relation is blank');
		}
		String[] pathParts = relationParts(relation);
		SObject currentRecord = record;
		for (Integer i = 0; i < pathParts.size() - 1; i++) {
			String relationPart = pathParts[i];
			try {
				SObject nextRecord = currentRecord.getSObject(relationPart);
				if (nextRecord == null) {
					throw new LambdaException(String.format('Cannot resolve "{0}" ({1}) on {2} object', new String[]{
							relationPart, relation, currentRecord.getSObjectType().getDescribe().getName()
					}));
				}
				currentRecord = currentRecord.getSObject(relationPart);
			} catch (SObjectException e) {
				throw new LambdaException(String.format('Cannot resolve "{0}" ({1}) on {2} object', new String[]{
						relationPart, relation, currentRecord.getSObjectType().getDescribe().getName()
				}));
			}
		}
		String lastPart = pathParts[pathParts.size() - 1];
		Object fieldValue;
		try {
			fieldValue = currentRecord.get(lastPart);
		} catch (SObjectException e) {
			throw new LambdaException(String.format('Cannot resolve "{0}" ({1}) on {2} object', new String[]{
					lastPart, relation, currentRecord.getSObjectType().getDescribe().getName()
			}));
		}
		return fieldValue;
	}
}
