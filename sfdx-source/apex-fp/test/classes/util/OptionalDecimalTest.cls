@IsTest(isParallel=true)
private class OptionalDecimalTest {
	@IsTest
	private static void optionalCanBeNull() {
		OptionalDecimal optional = OptionalDecimal.of(null);
	}

	@IsTest
	private static void nullIsNotPresent() {
		OptionalDecimal optional = OptionalDecimal.of(null);
		System.assertEquals(false, optional.isPresent());
	}

	@IsTest
	private static void getThrowsNoSuchElementExceptionWhenValueIsNotPresent() {
		OptionalDecimal optional = OptionalDecimal.of(null);
		try {
			Decimal value = optional.get();
			System.assert(false, 'Exception was not thrown');
		} catch (NoSuchElementException e) {
			System.assert(true);
		}
	}

	@IsTest
	private static void getReturnsValueWhenValueIsPresent() {
		Decimal d = 4.51;
		OptionalDecimal optional = OptionalDecimal.of(d);
		Decimal value = optional.get();
		System.assertEquals(d, value);
	}

	@IsTest
	private static void orElseReturnsOtherValueWhenValueIsNotPresent() {
		OptionalDecimal optional = OptionalDecimal.of(null);
		Decimal other = 1.19;
		Decimal value = optional.orElse(other);
		System.assertEquals(other, value);
	}

	@IsTest
	private static void orElseThrowThrowsWhenValueIsNotPreset() {
		OptionalDecimal optional = OptionalDecimal.of(null);
		Decimal other = 2.71;
		try {
			Decimal value = optional.orElseThrow(new IllegalOperationException('test'));
			System.assert(false, 'Exception was not thrown');
		} catch (IllegalOperationException e) {
			System.assertEquals('test', e.getMessage());
		}
	}

	@IsTest
	private static void orElseThrowReturnsValueWhenValueIsPresent() {
		Decimal d = 1.3;
		OptionalDecimal optional = OptionalDecimal.of(d);
		try {
			Decimal value = optional.orElseThrow(new IllegalOperationException('test'));
			System.assertEquals(d, value);
		} catch (IllegalOperationException e) {
			System.assert(false, 'Exception was thrown');
		}
	}

	@IsTest
	private static void emptyIsASingleton() {
		System.assertEquals(OptionalDecimal.empty(), OptionalDecimal.empty());
	}

	@IsTest
	private static void emptyIsNotPresent() {
		System.assertEquals(false, OptionalDecimal.empty().isPresent());
	}
}
