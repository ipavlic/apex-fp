@IsTest(isParallel=true)
private class OptionalDecimalTest {
	@IsTest
	private static void optionalCanBeNull() {
		OptionalDecimal optional = OptionalDecimal.of(null);
	}

	@IsTest
	private static void nullIsNotPresent() {
		OptionalDecimal optional = OptionalDecimal.of(null);
		System.Assert.isFalse(optional.isPresent());
	}

	@IsTest
	private static void getThrowsNoSuchElementExceptionWhenValueIsNotPresent() {
		OptionalDecimal optional = OptionalDecimal.of(null);
		try {
			Decimal value = optional.get();
			System.Assert.fail('Exception was not thrown');
		} catch (Exception e) {
			System.Assert.isInstanceOfType(e, NoSuchElementException.class);
		}
	}

	@IsTest
	private static void getReturnsValueWhenValueIsPresent() {
		Decimal d = 4.51;
		OptionalDecimal optional = OptionalDecimal.of(d);
		Decimal value = optional.get();
		System.Assert.areEqual(d, value);
	}

	@IsTest
	private static void orElseReturnsOtherValueWhenValueIsNotPresent() {
		OptionalDecimal optional = OptionalDecimal.of(null);
		Decimal other = 1.19;
		Decimal value = optional.orElse(other);
		System.Assert.areEqual(other, value);
	}

	@IsTest
	private static void orElseThrowThrowsWhenValueIsNotPreset() {
		OptionalDecimal optional = OptionalDecimal.of(null);
		Decimal other = 2.71;
		try {
			Decimal value = optional.orElseThrow(new IllegalOperationException('test'));
			System.Assert.fail('Exception was not thrown');
		} catch (IllegalOperationException e) {
			System.Assert.areEqual('test', e.getMessage());
		}
	}

	@IsTest
	private static void orElseThrowReturnsValueWhenValueIsPresent() {
		Decimal d = 1.3;
		OptionalDecimal optional = OptionalDecimal.of(d);
		try {
			Decimal value = optional.orElseThrow(new IllegalOperationException('test'));
			System.Assert.areEqual(d, value);
		} catch (IllegalOperationException e) {
			System.Assert.fail('Exception was thrown');
		}
	}

	@IsTest
	private static void emptyIsASingleton() {
		System.Assert.areEqual(OptionalDecimal.empty(), OptionalDecimal.empty());
	}

	@IsTest
	private static void emptyIsNotPresent() {
		System.Assert.isFalse(OptionalDecimal.empty().isPresent());
	}
}
