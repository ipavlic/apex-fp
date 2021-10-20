@IsTest(isParallel=true)
private class DoubleCollectionTest {
	@IsTest
	private static void testSum() {
		DoubleCollection c = new DoubleCollection(new List<Double>{100, 150});
		System.assertEquals(250, c.sum().get());
	}

	@IsTest
	private static void testAverage() {
		DoubleCollection c = new DoubleCollection(new List<Double>{100, 150});
		System.assertEquals(125, c.average().get());
	}

	private class IsGreaterThanTen implements DoublePredicate {
		public Boolean call(Double d) {
			return d != null && d > 10;
		}
	} 

	@IsTest
	private static void testFilterWithDoublePredicate() {
		DoubleCollection c = new DoubleCollection(new List<Double>{null, 20, 5, 23});
		List<Double> filtered = c.filter(new IsGreaterThanTen()).asList();
		System.assertEquals(2, filtered.size());
		System.assertEquals(20, filtered[0]);
		System.assertEquals(23, filtered[1]);
	}
}
