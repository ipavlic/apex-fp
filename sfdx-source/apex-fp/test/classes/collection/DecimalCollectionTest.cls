@IsTest
public class DecimalCollectionTest {
	@IsTest
	static void testDecimalCollectionSum() {
		DecimalCollection c = new DecimalCollection(new List<Decimal>{100, 150});
		System.assertEquals(250, c.sum());
	}

	@IsTest
	static void testDecimalCollectionAverage() {
		DecimalCollection c = new DecimalCollection(new List<Decimal>{100, 150});
		System.assertEquals(125, c.average(0));
	}

	@IsTest
	static void testDecimalCollectionAverageWithRoundingMode() {
		DecimalCollection c = new DecimalCollection(new List<Decimal>{1, 2});
		System.assertEquals(1, c.average(0, System.RoundingMode.DOWN));
	}

	@IsTest
	static void testFilterWithObjectPredicate() {
		DecimalCollection c = new DecimalCollection(new List<Decimal>{null, 100, null, 150, null});
		List<Decimal> filtered = c.filter(ObjectPredicates.NotNull).asList();
		System.assertEquals(2, filtered.size());
		System.assertEquals(100, filtered[0]);
		System.assertEquals(150, filtered[1]);
	}

	private class IsTen implements DecimalPredicate {
		public Boolean apply(Decimal d) {
			return d != null && d == 10;
		}
	}

	@IsTest
	static void testFilterWithDecimalPredicate() {
		DecimalCollection c = new DecimalCollection(new List<Decimal>{null, 10, null, 20, null, 10});
		List<Decimal> filtered = c.filter(new IsTen()).asList();
		System.assertEquals(2, filtered.size());
		System.assertEquals(10, filtered[0]);
		System.assertEquals(10, filtered[1]);
	}
}
