public with sharing class SObjectStreamMapSome extends SObjectStream {
	
	private SObjectPredicate predicate;
	private SObjectToSObjectFunction fn;
	
	public SObjectStreamMapSome(Iterator<SObject> recordsIterator, SObjectPredicate predicate, SObjectToSObjectFunction fn) {
		super(recordsIterator);
		this.predicate = predicate;
		this.fn = fn;
	}

	public virtual override Boolean hasNext() {
		return recordsIterator.hasNext();
	}

	public virtual override SObject next() {
		SObject next = recordsIterator.next();
		return predicate.apply(next) ? fn.apply(next) : next;
	}
}
