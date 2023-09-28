public with sharing class ObjectCollection {
    private List<Object> objects;

    public static ObjectCollection of(Iterable<Object> objects) {
        return new ObjectCOllection(objects);
    }

    private ObjectCollection(Iterable<Object> objects) {
        this.objects = new List<Object>();
        Iterator<Object> iter = objects.iterator();
        while (iter.hasNext()) {
            this.objects.add(iter.next());
        }
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
