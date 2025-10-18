public class DecimalCollection {
	private final List<Decimal> decimals;

	public static DecimalCollection of(Iterable<Decimal> decimals) {
		return new DecimalCollection(decimals);
	}

	private DecimalCollection(Iterable<Decimal> decimals) {
		this.decimals = new List<Decimal>();
		for (Decimal d : decimals) {
			this.decimals.add(d);
		}
	}

	public List<Decimal> asList() {
		return new List<Decimal>(this.decimals);
	}

	public Set<Decimal> asSet() {
		return new Set<Decimal>(this.decimals);
	}

	public OptionalDecimal sum() {
		Decimal sum;
		for (Decimal d : this.decimals) {
			if (d != null) {
				sum = (sum ?? 0) + (d ?? 0);
			}
		}
		return OptionalDecimal.of(sum);
	}

	public OptionalDecimal max() {
		Decimal max;
		for (Decimal d : this.decimals) {
			if (d != null) {
				if (max == null) {
					max = d;
				} else {
					max = d > max ? d : max;
				}
			}
		}
		return OptionalDecimal.of(max);
	}

	public OptionalDecimal min() {
		Decimal min;
		for (Decimal d : this.decimals) {
			if (d != null) {
				if (min == null) {
					min = d;
				} else {
					min = d < min ? d : min;
				}
			}
		}
		return OptionalDecimal.of(min);
	}

	public OptionalDecimal average(Integer scale) {
		return this.average(scale, System.RoundingMode.HALF_EVEN);
	}

	public OptionalDecimal average(Integer scale, System.RoundingMode roundingMode) {
		OptionalDecimal s = this.sum();
		return s.isPresent() ? OptionalDecimal.of(s.get().divide(this.decimals.size(), scale, roundingMode)) : s;
	}

	public DecimalCollection filter(DecimalPredicate predicate) {
		List<Decimal> filtered = new List<Decimal>();
		for (Decimal d : this.decimals) {
			if (predicate.call(d)) {
				filtered.add(d);
			}
		}
		return new DecimalCollection(filtered);
	}
}
