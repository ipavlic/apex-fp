public with sharing class SObjectStreamFilter extends SObjectStream {
	
	private SObjectPredicate predicate;
	private SObject next;
	private Boolean hasNext;
	
	public SObjectStreamFilter(Iterator<SObject> recordsIterator, SObjectPredicate predicate) {
		super(recordsIterator);
		this.predicate = predicate;
	}

	private Boolean tryAdvance() {
		while (recordsIterator.hasNext()) {
			SObject nextRecord = recordsIterator.next();
			if (predicate.call(nextRecord)) {
				next = nextRecord;
				hasNext = true;
				return true;
			}
		}
		return false;
	}

	public virtual override Boolean hasNext() {
		if (hasNext == null) {
			hasNext = tryAdvance();
		}
		return hasNext;
	}

	public virtual override SObject next() {
		if (hasNext == null) {
			tryAdvance();
		}
		if (hasNext) {
			SObject nextRecord = next;
			next = null;
			hasNext = null;
			return nextRecord;
		} else {
			throw new NoSuchElementException();
		}
	}
}
