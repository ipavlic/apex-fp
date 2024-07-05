@IsTest(isParallel=true)
private class OptionalDoubleTest {
	@IsTest
	private static void optionalCanBeNull() {
		OptionalDouble optional = OptionalDouble.of(null);
	}

	@IsTest
	private static void nullIsNotPresent() {
		OptionalDouble optional = OptionalDouble.of(null);
		System.Assert.isFalse(optional.isPresent());
	}

	@IsTest
	private static void getThrowsNoSuchElementExceptionWhenValueIsNotPresent() {
		OptionalDouble optional = OptionalDouble.of(null);
		try {
			Double value = optional.get();
			System.Assert.fail('Exception was not thrown');
		} catch (Exception e) {
			System.Assert.isInstanceOfType(e, NoSuchElementException.class);
		}
	}

	@IsTest
	private static void getReturnsValueWhenValueIsPresent() {
		Double d = 4.51;
		OptionalDouble optional = OptionalDouble.of(d);
		Double value = optional.get();
		System.Assert.areEqual(d, value);
	}

	@IsTest
	private static void orElseReturnsOtherValueWhenValueIsNotPresent() {
		OptionalDouble optional = OptionalDouble.of(null);
		Double other = 1.19;
		Double value = optional.orElse(other);
		System.Assert.areEqual(other, value);
	}

	@IsTest
	private static void orElseThrowThrowsWhenValueIsNotPreset() {
		OptionalDouble optional = OptionalDouble.of(null);
		Double other = 2.71;
		try {
			Double value = optional.orElseThrow(new IllegalOperationException('test'));
			System.Assert.fail('Exception was not thrown');
		} catch (IllegalOperationException e) {
			System.Assert.areEqual('test', e.getMessage());
		}
	}

	@IsTest
	private static void orElseThrowReturnsValueWhenValueIsPresent() {
		Double d = 1.3;
		OptionalDouble optional = OptionalDouble.of(d);
		try {
			Double value = optional.orElseThrow(new IllegalOperationException('test'));
			System.Assert.areEqual(d, value);
		} catch (IllegalOperationException e) {
			System.Assert.fail('Exception was thrown');
		}
	}

	@IsTest
	private static void emptyIsASingleton() {
		System.Assert.areEqual(OptionalDouble.empty(), OptionalDouble.empty());
	}

	@IsTest
	private static void emptyIsNotPresent() {
		System.Assert.isFalse(OptionalDouble.empty().isPresent());
	}
}
