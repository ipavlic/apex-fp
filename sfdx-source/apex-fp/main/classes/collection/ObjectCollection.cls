public with sharing class ObjectCollection {
	private List<Object> objects;

	public ObjectCollection(List<Object> objects) {
		this.objects = objects;
	}

	public List<Object> asList(Type listType) {
		List<Object> typedObjects = (List<Object>) listType.newInstance();
		typedObjects.addAll(objects);
		return typedObjects;
	}

	public Set<Object> asSet(Type setType) {
		Set<Object> typedObjects = (Set<Object>) setType.newInstance();
		typedObjects.addAll(objects);
		return typedObjects;
	}
}
