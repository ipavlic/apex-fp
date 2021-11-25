@IsTest(isParallel=true)
private class DoubleCollectionTest {
	@IsTest
	private static void testSum() {
		DoubleCollection c = new DoubleCollection(new List<Double>{100, 150});
		System.assertEquals(250, c.sum().get());
	}

	@IsTest
	private static void maxShouldReturnAMaxIfItExists() {
		DoubleCollection c = new DoubleCollection(new List<Decimal>{100, 150, 120});
		System.assertEquals(150, c.max().get());
	}

	@IsTest
	private static void maxShouldReturnEmptyIfItDoesNotExist() {
		DoubleCollection c = new DoubleCollection(new List<Decimal>{null, null, null});
		System.assertEquals(OptionalDouble.empty(), c.max());
	}

	@IsTest
	private static void minShouldReturnAMinIfItExists() {
		DoubleCollection c = new DoubleCollection(new List<Decimal>{70, 80, 150, 120});
		System.assertEquals(70, c.min().get());
	}

	@IsTest
	private static void minShouldReturnEmptyIfItDoesNotExist() {
		DoubleCollection c = new DoubleCollection(new List<Decimal>{null, null, null});
		System.assertEquals(OptionalDouble.empty(), c.min());
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
	private static void doublePredicateShouldFilterNumbers() {
		DoubleCollection c = new DoubleCollection(new List<Double>{null, 20, 5, 23});
		List<Double> filtered = c.filter(new IsGreaterThanTen()).asList();
		System.assertEquals(2, filtered.size());
		System.assertEquals(20, filtered[0]);
		System.assertEquals(23, filtered[1]);
	}

	@IsTest
	private static void nullsShouldBeSummedToEmpty() {
		DoubleCollection c = new DoubleCollection(new List<Double>{null, null});
		OptionalDouble d = c.sum();
		System.assertEquals(false, d.isPresent(), 'Result should be empty');
	}

	@IsTest
	private static void asSetShouldReturnASet() {
		DoubleCollection c = new DoubleCollection(new List<Double>{null, 1, 1, null, 2});
		Set<Double> s = c.asSet();
		System.assertEquals(3, s.size(), 'Set has more than 3 elements');
		System.assert(s.contains(1));
		System.assert(s.contains(2));
	}
}
