public class DatetimeCollection {
	private List<Datetime> datetimes;
	private List<Datetime> nonNulls;

	public DatetimeCollection(List<Datetime> datetimes) {
		this.datetimes = datetimes;
		nonNulls = new List<Datetime>();
		for (Datetime dt : datetimes) {
			if (ObjectPredicates.NotNull.apply(dt)) {
				nonNulls.add(dt);
			}
		}
	}

	public List<Datetime> asList() {
		return new List<Datetime>(datetimes);
	}

	public Set<Datetime> asSet() {
		return new Set<Datetime>(datetimes);
	}

	public DatetimeCollection filter(ObjectPredicate predicate) {
		List<Datetime> filtered = new List<Datetime>();
		for (Datetime dt : datetimes) {
			if (predicate.apply(dt)) {
				filtered.add(dt);
			}
		}
		return new DatetimeCollection(filtered);
	}
}
