@IsTest
private class OptionalTest {
	@IsTest
	public static void testOptionalRoundtrip() {
		Optional opt = Optional.of('foo');
		System.assertEquals('foo', opt.get());
	}

	@IsTest
	public static void testOptionalPresenceChecking() {
		Optional opt = Optional.of('foo');
		System.assertEquals(true, opt.isPresent());

		opt = Optional.ofNullable(null);
		System.assertEquals(false, opt.isPresent());

		opt = Optional.empty();
		System.assertEquals(false, opt.isPresent());
	}

	@IsTest
	public static void testEmptyOptionalReferentialEquality() {
		Optional opt1 = Optional.ofNullable(null);
		Optional opt2 = Optional.empty();

		System.assert(opt1 == opt2);
	}

	@IsTest
	public static void testOptionalOfThrowsExceptionOnNull() {
		try {
			Optional opt = Optional.of(null);
			System.assert(false, 'Exception was not thrown');
		} catch (LambdaException e) {
			System.assert(true);
		}
	}

	@IsTest
	public static void testOrElse() {
		Optional o = Optional.empty();
		Object result = o.orElse('other');
		System.assertEquals('other', result);
	}
}
