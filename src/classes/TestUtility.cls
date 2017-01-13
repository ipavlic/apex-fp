public class TestUtility {

	private static final Double DEFAULT_EPSILON = 0.0001;

	static Integer counter = 1;

	public static String getTestId(Schema.SObjectType sot) {
		String numberString = String.valueOf(counter++);
		String prefix = sot.getDescribe().getKeyPrefix();
		return prefix + '0'.repeat(12 - numberString.length()) + numberString;
	}

	public static void assertEqualsEpsilon(Double expected, Double actual) {
		assertEqualsEpsilon(expected, actual, DEFAULT_EPSILON);
	}

	public static void assertEqualsEpsilon(Double expected, Double actual, Double epsilon) {
		Double delta = Math.abs(expected - actual);
		System.assert(delta < epsilon);
	}
}