@IsTest(isParallel=true)
private class DoubleCollectionTest {
	@IsTest
	private static void sumShouldReturnSumIfItExists() {
		DoubleCollection c = DoubleCollection.of(new List<Double>{100, 150});
		System.Assert.areEqual(250, c.sum().get());
	}

	@IsTest
	private static void maxShouldReturnAMaxIfItExists() {
		DoubleCollection c = DoubleCollection.of(new List<Double>{100, 150, 120});
		System.Assert.areEqual(150, c.max().get());
	}

	@IsTest
	private static void maxShouldReturnEmptyIfItDoesNotExist() {
		DoubleCollection c = DoubleCollection.of(new List<Double>{null, null, null});
		System.Assert.areEqual(OptionalDouble.empty(), c.max());
	}

	@IsTest
	private static void maxSupportsNumbersOutsideDocumentedRange() {
		// https://salesforce.stackexchange.com/questions/9320/what-is-max-and-min-range-for-double-valueof
		Double outsideDocumentedRange = Double.valueOf('-9.9E102');
		DoubleCollection c = DoubleCollection.of(new List<Double>{outsideDocumentedRange});
		System.Assert.areEqual(outsideDocumentedRange, c.max().get());
	}

	@IsTest
	private static void minShouldReturnAMinIfItExists() {
		DoubleCollection c = DoubleCollection.of(new List<Double>{70, 80, 150, 120});
		System.Assert.areEqual(70, c.min().get());
	}

	@IsTest
	private static void minShouldReturnEmptyIfItDoesNotExist() {
		DoubleCollection c = DoubleCollection.of(new List<Double>{null, null, null});
		System.Assert.areEqual(OptionalDouble.empty(), c.min());
	}

	@IsTest
	private static void minSupportsNumbersOutsideDocumentedRange() {
		// https://salesforce.stackexchange.com/questions/9320/what-is-max-and-min-range-for-double-valueof
		Double outsideDocumentedRange = Double.valueOf('9.9E102');
		DoubleCollection c = DoubleCollection.of(new List<Double>{outsideDocumentedRange});
		System.Assert.areEqual(outsideDocumentedRange, c.min().get());
	}

	@IsTest
	private static void averageShouldReturnAverageIfItExists() {
		DoubleCollection c = DoubleCollection.of(new List<Double>{100, 150});
		System.Assert.areEqual(125, c.average().get());
	}

	private class IsGreaterThanTen implements DoublePredicate {
		public Boolean call(Double d) {
			return d != null && d > 10;
		}
	}

	@IsTest
	private static void doublePredicateShouldFilterNumbers() {
		DoubleCollection c = DoubleCollection.of(new List<Double>{null, 20, 5, 23});
		List<Double> filtered = c.filter(new IsGreaterThanTen()).asList();
		System.Assert.areEqual(2, filtered.size());
		System.Assert.areEqual(20, filtered[0]);
		System.Assert.areEqual(23, filtered[1]);
	}

	@IsTest
	private static void nullsShouldBeSummedToEmpty() {
		DoubleCollection c = DoubleCollection.of(new List<Double>{null, null});
		OptionalDouble d = c.sum();
		System.Assert.isFalse(d.isPresent(), 'Result should be empty');
	}

	@IsTest
	private static void asSetShouldReturnASet() {
		DoubleCollection c = DoubleCollection.of(new List<Double>{null, 1, 1, null, 2});
		Set<Double> s = c.asSet();
		System.Assert.areEqual(3, s.size(), 'Set has more than 3 elements');
		System.Assert.isTrue(s.contains(1));
		System.Assert.isTrue(s.contains(2));
	}
}
