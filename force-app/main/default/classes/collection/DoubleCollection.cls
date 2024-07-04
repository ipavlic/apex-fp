public class DoubleCollection {
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
				sum = (sum ?? 0) + d;
			}
		}
		return OptionalDouble.of(sum);
	}

	public OptionalDouble max() {
		Double max;
		for (Double d : this.doubles) {
			if (d != null) {
				if (max == null) {
					max = d;
				} else {
					max = d > max ? d : max;
				}
			}
		}
		return OptionalDouble.of(max);
	}

	public OptionalDouble min() {
		Double min;
		for (Double d : this.doubles) {
			if (d != null) {
				if (min == null) {
					min = d;
				} else {
					min = d < min ? d : min;
				}
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
