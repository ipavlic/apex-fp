public class TestUtility {

	static Integer counter = 1;

	public static String getTestId(Schema.SObjectType sot) {
		String numberString = String.valueOf(counter++);
		String prefix = sot.getDescribe().getKeyPrefix();
		return prefix + '0'.repeat(12 - numberString.length()) + numberString;
	}
}