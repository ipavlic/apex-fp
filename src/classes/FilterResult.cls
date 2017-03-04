public class FilterResult implements Iterable<sObject> {
	private FilterQuery query;
	private Iterable<sObject> objects;

	public FilterResult(FilterQuery query, Iterable<sObject> objects) {
		this.query = query;
		this.objects = objects;
	}

	public Iterator<SObject> iterator() {
		return new FilterResultIterator(query, objects.iterator());
	}
}