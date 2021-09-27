@IsTest
public class ObjectPredicatesTest {
	@IsTest
	public static void testNonNull() {
		ObjectPredicate predicate = ObjectPredicates.NotNull;
		System.assertEquals(false, predicate.apply(null));
		System.assertEquals(true, predicate.apply(10));
		System.assertEquals(true, predicate.apply(''));
	}
}
