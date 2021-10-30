public with sharing class ObjectCollection {
	private List<Object> objects;

	public ObjectCollection(List<Object> objects) {
		this.objects = objects;
	}

	public List<Object> asList() {
		return new List<Object>(objects);
	}

	public Set<Object> asSet() {
		return new Set<Object>(objects);
	}
}
