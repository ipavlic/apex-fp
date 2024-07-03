public class DecimalCollection {
	private static final Decimal MAX_DECIMAL_VALUE {
		get {
			MAX_DECIMAL_VALUE = MAX_DECIMAL_VALUE ?? Math.pow(2, 63) - 1;
			return MAX_DECIMAL_VALUE;
		}
		set;
	}

  private static final Decimal MIN_DECIMAL_VALUE {
		get {
			MIN_DECIMAL_VALUE = MIN_DECIMAL_VALUE ?? MAX_DECIMAL_VALUE * -1;
			return MIN_DECIMAL_VALUE;
		}
		set;
	}

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
			if ((d ?? MIN_DECIMAL_VALUE) > (max ?? MIN_DECIMAL_VALUE)) {
				max = d;
			}
		}
		return OptionalDecimal.of(max);
	}

	public OptionalDecimal min() {
		Decimal min ;
		for (Decimal d : this.decimals) {
			if ((d ?? MAX_DECIMAL_VALUE) < (min ?? MAX_DECIMAL_VALUE)) {
				min = d;
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
