public class DoubleCollection {
	private static final Double MAX_DOUBLE_VALUE {
		get {
			MAX_DOUBLE_VALUE = MAX_DOUBLE_VALUE ?? Math.pow(2, 63) - 1;
			return MAX_DOUBLE_VALUE;
		}
		set;
	}

  private static final Double MIN_DOUBLE_VALUE {
		get {
			MIN_DOUBLE_VALUE = MIN_DOUBLE_VALUE ?? MAX_DOUBLE_VALUE * -1;
			return MIN_DOUBLE_VALUE;
		}
		set;
	}

	private final List<Double> doubles;

	public static DoubleCollection of(Iterable<Double> doubles) {
		return new DoubleCollection(doubles);
	}

	private DoubleCollection(Iterable<Double> doubles) {
		this.doubles = new List<Double>();
		for (Double d : doubles) {
			this.doubles.add(d);
		}
	}

	public List<Double> asList() {
		return new List<Double>(this.doubles);
	}

	public Set<Double> asSet() {
		return new Set<Double>(this.doubles);
	}

	public OptionalDouble sum() {
		Double sum;
		for (Double d : this.doubles) {
			if (d != null) {
				sum = (sum ?? 0) + (d ?? 0);
			}
		}
		return OptionalDouble.of(sum);
	}

	public OptionalDouble max() {
		Double max;
		for (Double d : this.doubles) {
			if ((d ?? MIN_DOUBLE_VALUE) > (max ?? MIN_DOUBLE_VALUE)) {
				max = d;
			}
		}
		return OptionalDouble.of(max);
	}

	public OptionalDouble min() {
		Double min ;
		for (Double d : this.doubles) {
			if ((d ?? MAX_DOUBLE_VALUE) < (min ?? MAX_DOUBLE_VALUE)) {
				min = d;
			}
		}
		return OptionalDouble.of(min);
	}

	public OptionalDouble average() {
		OptionalDouble s = this.sum();
		return s.isPresent() ? OptionalDouble.of(s.get() / this.doubles.size()) : s;
	}

	public DoubleCollection filter(DoublePredicate predicate) {
		List<Double> filtered = new List<Double>();
		for (Double d : this.doubles) {
			if (predicate.call(d)) {
				filtered.add(d);
			}
		}
		return new DoubleCollection(filtered);
	}
}
