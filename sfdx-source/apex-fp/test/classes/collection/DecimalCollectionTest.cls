@IsTest(isParallel=true)
private class DecimalCollectionTest {
	@IsTest
	private static void testDecimalCollectionSum() {
		DecimalCollection c = new DecimalCollection(new List<Decimal>{100, 150});
		System.assertEquals(250, c.sum().get());
	}

	@IsTest
	private static void testDecimalCollectionAverage() {
		DecimalCollection c = new DecimalCollection(new List<Decimal>{100, 150});
		System.assertEquals(125, c.average(0).get());
	}

	@IsTest
	private static void testDecimalCollectionAverageWithRoundingMode() {
		DecimalCollection c = new DecimalCollection(new List<Decimal>{1, 2});
		System.assertEquals(1, c.average(0, System.RoundingMode.DOWN).get());
	}

	private class IsTen implements DecimalPredicate {
		public Boolean call(Decimal d) {
			return d != null && d == 10;
		}
	}

	@IsTest
	private static void testFilterWithDecimalPredicate() {
		DecimalCollection c = new DecimalCollection(new List<Decimal>{null, 10, null, 20, null, 10});
		List<Decimal> filtered = c.filter(new IsTen()).asList();
		System.assertEquals(2, filtered.size());
		System.assertEquals(10, filtered[0]);
		System.assertEquals(10, filtered[1]);
	}
}
