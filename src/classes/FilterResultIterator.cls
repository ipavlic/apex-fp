public class FilterResultIterator implements Iterator<SObject> {

	private FilterQuery query;
	private Iterator<sObject> objectsIterator;
	private sObject next;

	public FilterResultIterator(FilterQuery query, Iterator<sObject> objectsIterator) {
		this.query = query;
		this.objectsIterator = objectsIterator;
		findNext();
	}

	public Boolean hasNext() {
		return next != null;
	}

	private void findNext() {
		while (objectsIterator.hasNext()) {
			sObject obj = objectsIterator.next();
			if (query.isValid(obj)) {
				next = obj;
				return;
			}
		}
		next = null;
	}

	public SObject next() {
		if (next == null) {
			throw new NoSuchElementException();
		}
		SObject current = next;
		findNext();
		return current;
	}
}