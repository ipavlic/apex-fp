@IsTest
public class ObjectPredicatesTest {
	@IsTest
	public static void testNonNull() {
		ObjectPredicate predicate = ObjectPredicates.NotNull;
		System.assertEquals(false, predicate.call(null));
		System.assertEquals(true, predicate.call(10));
		System.assertEquals(true, predicate.call(''));
	}
}
