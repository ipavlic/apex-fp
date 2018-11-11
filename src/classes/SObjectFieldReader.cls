public class SObjectFieldReader {
	public Object read(SObject record, String fieldPath) {
		if (String.isBlank(fieldPath)) {
			throw new LambdaException('Provided field path is blank');
		}
		String[] pathParts = fieldPath.split('\\.');
		SObject currentRecord = record;
		for (Integer i = 0; i < pathParts.size() - 1; i++) {
			String relationPart = pathParts[i];
			try {
				SObject nextRecord = currentRecord.getSObject(relationPart);
				if (nextRecord == null) {
					throw new LambdaException(String.format('Cannot resolve "{0}" ({1}) on {2} object', new String[]{
							relationPart, fieldPath, currentRecord.getSObjectType().getDescribe().getName()
					}));
				}
				currentRecord = currentRecord.getSObject(relationPart);
			} catch (SObjectException e) {
				throw new LambdaException(String.format('Cannot resolve "{0}" ({1}) on {2} object', new String[]{
						relationPart, fieldPath, currentRecord.getSObjectType().getDescribe().getName()
				}));
			}
		}
		String lastPart = pathParts[pathParts.size() - 1];
		Object fieldValue;
		try {
			fieldValue = currentRecord.get(lastPart);
		} catch (SObjectException e) {
			throw new LambdaException(String.format('Cannot resolve "{0}" ({1}) on {2} object', new String[]{
					lastPart, fieldPath, currentRecord.getSObjectType().getDescribe().getName()
			}));
		}
		return fieldValue;
	}
}
