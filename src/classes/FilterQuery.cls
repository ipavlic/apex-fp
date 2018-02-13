public abstract class FilterQuery {

	public abstract Boolean isValid(sObject obj);

	public Iterable<sObject> applyLazy(Iterable<sObject> records) {
		return new FilterResult(this, records);
	}

	/**
	 * Applies the filter to the list and returns the elements satisfying the filter.
	 * The original list is not changed.
	 */
	public List<sObject> apply(Iterable<sObject> records) {
		return apply(records, List<sObject>.class);
	}

	public List<sObject> apply(Iterable<sObject> records, Type listType) {
		List<sObject> filtered = (List<sObject>) listType.newInstance();

		Iterator<sObject> iter = records.iterator();
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
	public List<sObject> extract(List<sObject> records, Type listType) {

		List<sObject> filtered = (List<sObject>) listType.newInstance();
		List<sObject> nonFiltered = (List<sObject>) listType.newInstance();

		Iterator<sObject> iter = records.iterator();
		while (iter.hasNext()) {
			sObject obj = iter.next();
			if (isValid(obj)) {
				filtered.add(obj);
			} else {
				nonFiltered.add(obj);
			}
		}

		records.clear();
		records.addAll(nonFiltered);
		return filtered;
	}

	/**
	 * Applies the filter to the list and returns the elements satisfying the filter.
	 * The filtered elements are removed from the original list.
	 */
	public List<sObject> extract(List<sObject> records) {
		return extract(records, List<sObject>.class);
	}
}