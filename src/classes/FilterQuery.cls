public abstract class FilterQuery {
	
	public abstract Boolean isValid(sObject obj);
	
	/**
	 * Applies the filter to the list and returns the elements satisfying the filter. 
	 * The original list is not changed.
	 */ 
	public List<sObject> apply(Iterable<sObject> objects) {
		
		List<sObject> filtered = new List<sObject>();
		
		Iterator<sObject> iter = objects.iterator();
		while (iter.hasNext()) {
			sObject obj = iter.next();
			if (isValid(obj)) {
				filtered.add(obj);
			}
		}
		return filtered;
	}
	
	/**
	 * Applies the filter to the list and returns the elements satisfying the filter. 
	 * The filtered elements are removed from the original list.
	 */ 
	public List<sObject> extract(List<sObject> objects) {

		List<sObject> filtered = new List<sObject>();
		List<sObject> nonFiltered = new List<sObject>();

		Iterator<sObject> iter = objects.iterator();
		while (iter.hasNext()) {
			sObject obj = iter.next();
			if (isValid(obj)) {
				filtered.add(obj);
			} else {
				nonFiltered.add(obj);
			}
		}
		
		objects.clear();
		objects.addAll(nonFiltered);
		return filtered;
	}
}