public class TestUtility {

	static Integer counter = 1;

	public static String getFakeId(Schema.SObjectType sot) {
		String index = String.valueOf(counter++);
		String prefix = sot.getDescribe().getKeyPrefix();
		return prefix + '0'.repeat(12 - index.length()) + index;
	}
}