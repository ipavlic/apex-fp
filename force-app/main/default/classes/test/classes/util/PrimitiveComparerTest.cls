@IsTest(IsParallel=true)
private class PrimitiveComparerTest {
	@IsTest
	private static void nullComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.Assert.areEqual(-1, comparer.compare(null, 5));
		System.Assert.areEqual(1, comparer.compare('foo', null));
		System.Assert.areEqual(0, comparer.compare(null, null));
	}

	@IsTest
	private static void booleanComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.Assert.areEqual(0, comparer.compare(true, true));
		System.Assert.areEqual(0, comparer.compare(false, false));
		System.Assert.areEqual(-1, comparer.compare(false, true));
		System.Assert.areEqual(1, comparer.compare(true, false));
	}

	@IsTest
	private static void dateComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.Assert.areEqual(-1, comparer.compare(Date.newInstance(2013,5,1), Date.newInstance(2013,6,1)));
		System.Assert.areEqual(0, comparer.compare(Date.newInstance(2013,4,1), Date.newInstance(2013,4,1)));
		System.Assert.areEqual(1, comparer.compare(Date.newInstance(2013,8,1), Date.newInstance(2013,7,1)));
	}

	@IsTest
	private static void datetimeComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.Assert.areEqual(-1, comparer.compare(Datetime.newInstance(2013,5,1), Datetime.newInstance(2013,6,1)));
		System.Assert.areEqual(0, comparer.compare(Datetime.newInstance(2013,4,1), Datetime.newInstance(2013,4,1)));
		System.Assert.areEqual(1, comparer.compare(Datetime.newInstance(2013,8,1), Datetime.newInstance(2013,7,1)));
	}

	@IsTest
	private static void timeComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.Assert.areEqual(-1, comparer.compare(Time.newInstance(1,0,0,0), Time.newInstance(2,0,0,0)));
		System.Assert.areEqual(0, comparer.compare(Time.newInstance(3,0,0,0), Time.newInstance(3,0,0,0)));
		System.Assert.areEqual(1, comparer.compare(Time.newInstance(5,0,0,0), Time.newInstance(4,0,0,0)));
	}

	@IsTest
	private static void decimalComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.Assert.areEqual(-1, comparer.compare(Decimal.valueOf(1), Decimal.valueOf(3)));
		System.Assert.areEqual(0, comparer.compare(Decimal.valueOf(1), Decimal.valueOf(1)));
		System.Assert.areEqual(1, comparer.compare(Decimal.valueOf(3), Decimal.valueOf(1)));
	}

	@IsTest
	private static void doubleComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.Assert.areEqual(-1, comparer.compare(Double.valueOf(1), Double.valueOf(3)));
		System.Assert.areEqual(0, comparer.compare(Double.valueOf(1), Double.valueOf(1)));
		System.Assert.areEqual(1, comparer.compare(Double.valueOf(3), Double.valueOf(1)));
	}

	@IsTest
	private static void integerComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.Assert.areEqual(-1, comparer.compare(1, 3));
		System.Assert.areEqual(0, comparer.compare(1, 1));
		System.Assert.areEqual(1, comparer.compare(3, 1));
	}

	@IsTest
	private static void longComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.Assert.areEqual(-1, comparer.compare(1L, 3L));
		System.Assert.areEqual(0, comparer.compare(1L, 1L));
		System.Assert.areEqual(1, comparer.compare(3L, 1L));
	}

	@IsTest
	private static void idComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		Id a = '000000000000001', b = '000000000000001', c = '000000000000002';
		System.Assert.areEqual(0, comparer.compare(a, b));
		System.Assert.areNotEqual(0, comparer.compare(a, c));
	}

	@IsTest
	private static void stringComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.Assert.areEqual(-1, comparer.compare('abc', 'bbc'));
		System.Assert.areEqual(0, comparer.compare('efg', 'efg'));
		System.Assert.areEqual(1, comparer.compare('cdc', 'bbc'));
	}
}
