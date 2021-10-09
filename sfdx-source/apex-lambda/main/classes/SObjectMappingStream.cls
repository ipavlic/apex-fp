public with sharing class SObjectMappingStream extends SObjectStream {
	private SObjectToSObjectFunction fn;
	
	public SObjectMappingStream(Iterator<SObject> recordsIterator, SObjectToSObjectFunction fn) {
		super(recordsIterator);
		this.fn = fn;
	}

	public virtual override Boolean hasNext() {
		return recordsIterator.hasNext();
	}

	public virtual override SObject next() {
		SObject next = recordsIterator.next();
		return fn.apply(next);
	}
}
