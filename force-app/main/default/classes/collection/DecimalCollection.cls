public class DecimalCollection {
	private List<Decimal> decimals;
	private List<Decimal> nonNulls;

	public static DecimalCollection of(Iterable<Decimal> decimals) {
		return new DecimalCollection(decimals);
	}

	private DecimalCollection(Iterable<Decimal> decimals) {
		this.decimals = new List<Decimal>();
		nonNulls = new List<Decimal>();
		Iterator<Decimal> iter = decimals.iterator();
		while (iter.hasNext()) {
			Decimal d = iter.next();
			this.decimals.add(d);
			if (d != null) {
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

	public OptionalDecimal sum() {
		if (nonNulls.isEmpty()) {
			return OptionalDecimal.empty();
		}
		Decimal sum = 0;
		for (Decimal d : nonNulls) {
			sum += d;
		}
		return OptionalDecimal.of(sum);
	}

	public OptionalDecimal max() {
		if (nonNulls.isEmpty()) {
			return OptionalDecimal.empty();
		}
		Decimal max = nonNulls.get(0);
		for (Integer i = 1; i < nonNulls.size(); i++) {
			Decimal d = nonNulls[i];
			if (d > max) {
				max = d;
			}
		}
		return OptionalDecimal.of(max);
	}

	public OptionalDecimal min() {
		if (nonNulls.isEmpty()) {
			return OptionalDecimal.empty();
		}
		Decimal min = nonNulls.get(0);
		for (Integer i = 1; i < nonNulls.size(); i++) {
			Decimal d = nonNulls[i];
			if (d < min) {
				min = d;
			}
		}
		return OptionalDecimal.of(min);
	}

	public OptionalDecimal average(Integer scale) {
		OptionalDecimal s = sum();
		return s.isPresent() ? OptionalDecimal.of(s.get().divide(nonNulls.size(), scale)) : OptionalDecimal.empty();
	}

	public OptionalDecimal average(Integer scale, System.RoundingMode roundingMode) {
		OptionalDecimal s = sum();
		return s.isPresent() ? OptionalDecimal.of(s.get().divide(nonNulls.size(), scale, roundingMode)) : OptionalDecimal.empty();
	}

	public DecimalCollection filter(DecimalPredicate predicate) {
		List<Decimal> filtered = new List<Decimal>();
		for (Decimal d : decimals) {
			if (predicate.call(d)) {
				filtered.add(d);
			}
		}
		return new DecimalCollection(filtered);
	}
}
