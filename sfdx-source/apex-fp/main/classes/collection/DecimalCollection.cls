public class DecimalCollection {
	private List<Decimal> decimals;
	private List<Decimal> nonNulls;

	public DecimalCollection(List<Decimal> decimals) {
		this.decimals = decimals;
		nonNulls = new List<Decimal>();
		for (Decimal d : decimals) {
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
