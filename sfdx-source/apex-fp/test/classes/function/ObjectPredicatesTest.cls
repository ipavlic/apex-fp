@IsTest(isParallel=true)
private class ObjectPredicatesTest {
	@IsTest
	private static void testNonNull() {
		ObjectPredicate predicate = ObjectPredicates.NotNull;
		System.assertEquals(false, predicate.call(null));
		System.assertEquals(true, predicate.call(10));
		System.assertEquals(true, predicate.call(''));
	}
}
