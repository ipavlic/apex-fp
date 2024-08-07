@IsTest(isParallel=true)
private class DecimalCollectionTest {
	@IsTest
	private static void sumShouldReturnSumIfItExists() {
		DecimalCollection c = DecimalCollection.of(new List<Decimal>{100, 150});
		System.Assert.areEqual(250, c.sum().get());
	}

	@IsTest
	private static void maxShouldReturnAMaxIfItExists() {
		DecimalCollection c = DecimalCollection.of(new List<Decimal>{100, 150, 120});
		System.Assert.areEqual(150, c.max().get());
	}

	@IsTest
	private static void maxShouldReturnEmptyIfItDoesNotExist() {
		DecimalCollection c = DecimalCollection.of(new List<Decimal>{null, null, null});
		System.Assert.areEqual(OptionalDecimal.empty(), c.max());
	}

	@IsTest
	private static void maxSupportsNumbersOutsideDocumentedRange() {
		// https://salesforce.stackexchange.com/questions/9320/what-is-max-and-min-range-for-double-valueof
		Decimal outsideDocumentedRange = Double.valueOf('-9.9E102');
		DecimalCollection c = DecimalCollection.of(new List<Decimal>{outsideDocumentedRange});
		System.Assert.areEqual(outsideDocumentedRange, c.max().get());
	}

	@IsTest
	private static void minShouldReturnAMinIfItExists() {
		DecimalCollection c = DecimalCollection.of(new List<Decimal>{70, 80, 150, 120});
		System.Assert.areEqual(70, c.min().get());
	}

	@IsTest
	private static void minShouldReturnEmptyIfItDoesNotExist() {
		DecimalCollection c = DecimalCollection.of(new List<Decimal>{null, null, null});
		System.Assert.areEqual(OptionalDecimal.empty(), c.min());
	}

	@IsTest
	private static void minSupportsNumbersOutsideDocumentedRange() {
		// https://salesforce.stackexchange.com/questions/9320/what-is-max-and-min-range-for-double-valueof
		Decimal outsideDocumentedRange = Double.valueOf('9.9E102');
		DecimalCollection c = DecimalCollection.of(new List<Decimal>{outsideDocumentedRange});
		System.Assert.areEqual(outsideDocumentedRange, c.min().get());
	}

	@IsTest
	private static void averageShouldReturnAverageIfExists() {
		DecimalCollection c = DecimalCollection.of(new List<Decimal>{100, 150});
		System.Assert.areEqual(125, c.average(0).get());
	}

	@IsTest
	private static void averageShouldReturnAverageIfExistsWithRoundingMode() {
		DecimalCollection c = DecimalCollection.of(new List<Decimal>{1, 2});
		System.Assert.areEqual(1, c.average(0, System.RoundingMode.DOWN).get());
	}

	private class IsTen implements DecimalPredicate {
		public Boolean call(Decimal d) {
			return d == 10;
		}
	}

	@IsTest
	private static void decimalPredicateShouldFilterNumbers() {
		DecimalCollection c = DecimalCollection.of(new List<Decimal>{null, 10, null, 20, null, 10});
		List<Decimal> filtered = c.filter(new IsTen()).asList();
		System.Assert.areEqual(2, filtered.size());
		System.Assert.areEqual(10, filtered[0]);
		System.Assert.areEqual(10, filtered[1]);
	}

	@IsTest
	private static void nullsShouldBeSummedToEmpty() {
		DecimalCollection c = DecimalCollection.of(new List<Decimal>{null, null});
		OptionalDecimal d = c.sum();
		System.Assert.isFalse(d.isPresent(), 'Result should be empty');
	}

	@IsTest
	private static void asSetShouldReturnASet() {
		DecimalCollection c = DecimalCollection.of(new List<Decimal>{null, 1, 1, null, 2});
		Set<Decimal> s = c.asSet();
		System.Assert.areEqual(3, s.size(), 'Set has more than 3 elements');
		System.Assert.isTrue(s.contains(1));
		System.Assert.isTrue(s.contains(2));
	}
}
