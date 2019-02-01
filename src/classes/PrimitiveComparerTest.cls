@IsTest
private class PrimitiveComparerTest {

	@IsTest
	static void booleanComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		system.assertEquals(ComparisonResult.EQUALS, comparer.compareBooleans(true, true));
		system.assertEquals(ComparisonResult.EQUALS, comparer.compareBooleans(false, false));
		system.assertEquals(ComparisonResult.NOT_EQUALS, comparer.compareBooleans(false, true));
		system.assertEquals(ComparisonResult.NOT_EQUALS, comparer.compareBooleans(true, false));
	}

	@IsTest
	static void dateComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		system.assertEquals(ComparisonResult.LESS_THAN, comparer.compareDates(Date.newInstance(2013,5,1), Date.newInstance(2013,6,1)));
		system.assertEquals(ComparisonResult.EQUALS, comparer.compareDates(Date.newInstance(2013,4,1), Date.newInstance(2013,4,1)));
		system.assertEquals(ComparisonResult.GREATER_THAN, comparer.compareDates(Date.newInstance(2013,8,1), Date.newInstance(2013,7,1)));
	}

	@IsTest
	static void datetimeComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		system.assertEquals(ComparisonResult.LESS_THAN, comparer.compareDatetimes(Datetime.newInstance(2013,5,1), Datetime.newInstance(2013,6,1)));
		system.assertEquals(ComparisonResult.EQUALS, comparer.compareDatetimes(Datetime.newInstance(2013,4,1), Datetime.newInstance(2013,4,1)));
		system.assertEquals(ComparisonResult.GREATER_THAN, comparer.compareDatetimes(Datetime.newInstance(2013,8,1), Datetime.newInstance(2013,7,1)));
	}

	@IsTest
	static void timeComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		system.assertEquals(ComparisonResult.LESS_THAN, comparer.compareTimes(Time.newInstance(1,0,0,0), Time.newInstance(2,0,0,0)));
		system.assertEquals(ComparisonResult.EQUALS, comparer.compareTimes(Time.newInstance(3,0,0,0), Time.newInstance(3,0,0,0)));
		system.assertEquals(ComparisonResult.GREATER_THAN, comparer.compareTimes(Time.newInstance(5,0,0,0), Time.newInstance(4,0,0,0)));
	}

	@IsTest
	static void decimalComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		system.assertEquals(ComparisonResult.LESS_THAN, comparer.compareDecimals(Decimal.valueOf(1), Decimal.valueOf(3)));
		system.assertEquals(ComparisonResult.GREATER_THAN, comparer.compareDecimals(Decimal.valueOf(3), Decimal.valueOf(1)));
		system.assertEquals(ComparisonResult.EQUALS, comparer.compareDecimals(Decimal.valueOf(1), Decimal.valueOf(1)));
	}

	@IsTest
	static void doubleComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		system.assertEquals(ComparisonResult.LESS_THAN, comparer.compareDoubles(Double.valueOf(1), Double.valueOf(3)));
		system.assertEquals(ComparisonResult.GREATER_THAN, comparer.compareDoubles(Double.valueOf(3), Double.valueOf(1)));
		system.assertEquals(ComparisonResult.EQUALS, comparer.compareDoubles(Double.valueOf(1), Double.valueOf(1)));
	}

	@IsTest
	static void integerComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		system.assertEquals(ComparisonResult.LESS_THAN, comparer.compareIntegers(1, 3));
		system.assertEquals(ComparisonResult.GREATER_THAN, comparer.compareIntegers(3, 1));
		system.assertEquals(ComparisonResult.EQUALS, comparer.compareIntegers(1, 1));
	}

	@IsTest
	static void idComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		Id a = '000000000000001', b = '000000000000001', c = '000000000000002';
		system.assertEquals(ComparisonResult.EQUALS, comparer.compareIds(a, b));
		system.assertEquals(ComparisonResult.NOT_EQUALS, comparer.compareIds(a, c));
	}

	@IsTest
	static void longComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		system.assertEquals(ComparisonResult.LESS_THAN, comparer.compareLongs(1L, 3L));
		system.assertEquals(ComparisonResult.GREATER_THAN, comparer.compareLongs(3L, 1L));
		system.assertEquals(ComparisonResult.EQUALS, comparer.compareLongs(1L, 1L));
	}

	@IsTest
	static void stringComparison() {
		PrimitiveComparer comparer = new PrimitiveComparer();
		system.assertEquals(ComparisonResult.LESS_THAN, comparer.compareStrings('abc', 'bbc'));
		system.assertEquals(ComparisonResult.GREATER_THAN, comparer.compareStrings('cdc', 'bbc'));
		system.assertEquals(ComparisonResult.EQUALS, comparer.compareStrings('efg', 'efg'));
	}
}
