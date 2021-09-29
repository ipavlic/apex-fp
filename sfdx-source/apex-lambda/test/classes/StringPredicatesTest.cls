@IsTest
public class StringPredicatesTest {
	@IsTest
	public static void testLongerThan() {
		StringPredicate predicate = StringPredicates.longerThan(2);
		System.assertEquals(true, predicate.apply('123'));
		System.assertEquals(false, predicate.apply('12'));
		System.assertEquals(false, predicate.apply('1'));
		System.assertEquals(false, predicate.apply(null));
	}

    @IsTest
	public static void testShorterThan() {
		StringPredicate predicate = StringPredicates.shorterThan(2);
		System.assertEquals(true, predicate.apply('1'));
		System.assertEquals(true, predicate.apply(''));
		System.assertEquals(false, predicate.apply(null));
		System.assertEquals(false, predicate.apply('12'));
	}
}
