public class DoubleCollection {
	private List<Double> doubles;
	private List<Double> nonNulls;

	public DoubleCollection(List<Double> doubles) {
		this.doubles = doubles;
		nonNulls = new List<Double>();
		for (Double d : doubles) {
			if (ObjectPredicates.NotNull.apply(d)) {
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

	public Double sum() {
		if (nonNulls.isEmpty()) {
			return null;
		}
		Double sum = 0;
		for (Double d : nonNulls) {
			sum += d;
		}
		return sum;
	}

	public Double average() {
		Double s = sum();
		return s != null ? s / nonNulls.size() : null;
	}

	public Double average(Integer scale, System.RoundingMode roundingMode) {
		Double s = sum();
		return s != null ? s / nonNulls.size() : null;
	}

	public DoubleCollection filter(ObjectPredicate predicate) {
		List<Double> filtered = new List<Decimal>();
		for (Double d : doubles) {
			if (predicate.apply(d)) {
				filtered.add(d);
			}
		}
		return new DoubleCollection(filtered);
	}
}
