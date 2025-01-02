public with sharing class SObjectStreamMap extends SObjectStream {
	private SObjectToSObjectFunction fn;
	
	public SObjectStreamMap(Iterator<SObject> recordsIterator, SObjectToSObjectFunction fn) {
		super(recordsIterator);
		this.fn = fn;
	}

	public virtual override Boolean hasNext() {
		return recordsIterator.hasNext();
	}

	public virtual override SObject next() {
		SObject next = recordsIterator.next();
		return fn.call(next);
	}
}
