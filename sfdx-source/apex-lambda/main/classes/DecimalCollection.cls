public class DecimalCollection {
	private List<Decimal> decimals;
	private List<Decimal> nonNulls;

	public DecimalCollection(List<Decimal> decimals) {
		this.decimals = decimals;
		nonNulls = new List<Decimal>();
		for (Decimal d : decimals) {
			if (ObjectPredicates.NotNull.apply(d)) {
				nonNulls.add(d);
			}
		}
	}

	public List<Decimal> asList() {
		return new List<Decimal>(decimals);
	}

	public Set<Decimal> asSet() {
		return new Set<Decimal>(decimals);
	}

	public Decimal sum() {
		if (nonNulls.isEmpty()) {
			return null;
		}
		Decimal sum = 0;
		for (Decimal d : nonNulls) {
			sum += d;
		}
		return sum;
	}

	public Decimal average(Integer scale) {
		Decimal s = sum();
		return s != null ? s.divide(nonNulls.size(), scale) : null;
	}

	public Decimal average(Integer scale, System.RoundingMode roundingMode) {
		Decimal s = sum();
		return s != null ? s.divide(nonNulls.size(), scale, roundingMode) : null;
	}

	public DecimalCollection filter(ObjectPredicate predicate) {
		List<Decimal> filtered = new List<Decimal>();
		for (Decimal d : decimals) {
			if (predicate.apply(d)) {
				filtered.add(d);
			}
		}
		return new DecimalCollection(filtered);
	}
}
