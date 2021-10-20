public class DoubleCollection {
	private List<Double> doubles;
	private List<Double> nonNulls;

	public DoubleCollection(List<Double> doubles) {
		this.doubles = doubles;
		nonNulls = new List<Double>();
		for (Double d : doubles) {
			if (d != null) {
				nonNulls.add(d);
			}
		}
	}

	public List<Double> asList() {
		return new List<Double>(doubles);
	}

	public Set<Double> asSet() {
		return new Set<Double>(doubles);
	}

	public OptionalDouble sum() {
		if (nonNulls.isEmpty()) {
			return OptionalDouble.empty();
		}
		Double sum = 0;
		for (Double d : nonNulls) {
			sum += d;
		}
		return OptionalDouble.of(sum);
	}

	public OptionalDouble average() {
		OptionalDouble s = sum();
		return s.isPresent() ? OptionalDouble.of(s.get() / nonNulls.size()) : OptionalDouble.empty();
	}

	public OptionalDouble average(Integer scale, System.RoundingMode roundingMode) {
		OptionalDouble s = sum();
		return s.isPresent() ? OptionalDouble.of(s.get() / nonNulls.size()) : OptionalDouble.empty();
	}

	public DoubleCollection filter(DoublePredicate predicate) {
		List<Double> filtered = new List<Double>();
		for (Double d : doubles) {
			if (predicate.call(d)) {
				filtered.add(d);
			}
		}
		return new DoubleCollection(filtered);
	}
}
