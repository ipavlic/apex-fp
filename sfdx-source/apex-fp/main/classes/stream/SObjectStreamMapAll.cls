public with sharing class SObjectStreamMapAll extends SObjectStream {
	private SObjectToSObjectFunction fn;
	
	public SObjectStreamMapAll(Iterator<SObject> recordsIterator, SObjectToSObjectFunction fn) {
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
