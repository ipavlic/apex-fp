public class FilterResult implements Iterable<sObject> {
	private FilterQuery query;
	private Iterable<sObject> records;

	public FilterResult(FilterQuery query, Iterable<sObject> records) {
		this.query = query;
		this.records = records;
	}

	public Iterator<SObject> iterator() {
		return new FilterResultIterator(query, records.iterator());
	}
}