@IsTest
private class PrimitiveComparerTest {

	@IsTest
	static void booleanComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.assertEquals(0, comparer.compareBooleans(true, true));
		System.assertEquals(0, comparer.compareBooleans(false, false));
		System.assertEquals(-1, comparer.compareBooleans(false, true));
		System.assertEquals(1, comparer.compareBooleans(true, false));
	}

	@IsTest
	static void dateComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.assertEquals(-1, comparer.compareDates(Date.newInstance(2013,5,1), Date.newInstance(2013,6,1)));
		System.assertEquals(0, comparer.compareDates(Date.newInstance(2013,4,1), Date.newInstance(2013,4,1)));
		System.assertEquals(1, comparer.compareDates(Date.newInstance(2013,8,1), Date.newInstance(2013,7,1)));
	}

	@IsTest
	static void datetimeComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.assertEquals(-1, comparer.compareDatetimes(Datetime.newInstance(2013,5,1), Datetime.newInstance(2013,6,1)));
		System.assertEquals(0, comparer.compareDatetimes(Datetime.newInstance(2013,4,1), Datetime.newInstance(2013,4,1)));
		System.assertEquals(1, comparer.compareDatetimes(Datetime.newInstance(2013,8,1), Datetime.newInstance(2013,7,1)));
	}

	@IsTest
	static void timeComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.assertEquals(-1, comparer.compareTimes(Time.newInstance(1,0,0,0), Time.newInstance(2,0,0,0)));
		System.assertEquals(0, comparer.compareTimes(Time.newInstance(3,0,0,0), Time.newInstance(3,0,0,0)));
		System.assertEquals(1, comparer.compareTimes(Time.newInstance(5,0,0,0), Time.newInstance(4,0,0,0)));
	}

	@IsTest
	static void decimalComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.assertEquals(-1, comparer.compareDecimals(Decimal.valueOf(1), Decimal.valueOf(3)));
		System.assertEquals(0, comparer.compareDecimals(Decimal.valueOf(1), Decimal.valueOf(1)));
		System.assertEquals(1, comparer.compareDecimals(Decimal.valueOf(3), Decimal.valueOf(1)));
	}

	@IsTest
	static void doubleComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.assertEquals(-1, comparer.compareDoubles(Double.valueOf(1), Double.valueOf(3)));
		System.assertEquals(0, comparer.compareDoubles(Double.valueOf(1), Double.valueOf(1)));
		System.assertEquals(1, comparer.compareDoubles(Double.valueOf(3), Double.valueOf(1)));
	}

	@IsTest
	static void integerComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.assertEquals(-1, comparer.compareIntegers(1, 3));
		System.assertEquals(0, comparer.compareIntegers(1, 1));
		System.assertEquals(1, comparer.compareIntegers(3, 1));
	}

	@IsTest
	static void idComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		Id a = '000000000000001', b = '000000000000001', c = '000000000000002';
		System.assertEquals(0, comparer.compareIds(a, b));
		System.assertNotEquals(0, comparer.compareIds(a, c));
	}

	@IsTest
	static void longComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.assertEquals(-1, comparer.compareLongs(1L, 3L));
		System.assertEquals(0, comparer.compareLongs(1L, 1L));
		System.assertEquals(1, comparer.compareLongs(3L, 1L));
	}

	@IsTest
	static void stringComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		System.assertEquals(-1, comparer.compareStrings('abc', 'bbc'));
		System.assertEquals(0, comparer.compareStrings('efg', 'efg'));
		System.assertEquals(1, comparer.compareStrings('cdc', 'bbc'));
	}
}
