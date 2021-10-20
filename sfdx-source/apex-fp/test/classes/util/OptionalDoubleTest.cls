@IsTest(isParallel=true)
private class OptionalDoubleTest {
	@IsTest
	private static void optionalCanBeNull() {
		OptionalDouble optional = OptionalDouble.of(null);
	}

	@IsTest
	private static void nullIsNotPresent() {
		OptionalDouble optional = OptionalDouble.of(null);
		System.assertEquals(false, optional.isPresent());
	}

	@IsTest
	private static void getThrowsNoSuchElementExceptionWhenValueIsNotPresent() {
		OptionalDouble optional = OptionalDouble.of(null);
		try {
			Double value = optional.get();
			System.assert(false, 'Exception was not thrown');
		} catch (NoSuchElementException e) {
			System.assert(true);
		}
	}

	@IsTest
	private static void getReturnsValueWhenValueIsPresent() {
		Double d = 4.51;
		OptionalDouble optional = OptionalDouble.of(d);
		Double value = optional.get();
		System.assertEquals(d, value);
	}

	@IsTest
	private static void orElseReturnsOtherValueWhenValueIsNotPresent() {
		OptionalDouble optional = OptionalDouble.of(null);
		Double other = 1.19;
		Double value = optional.orElse(other);
		System.assertEquals(other, value);
	}

	@IsTest
	private static void orElseThrowThrowsWhenValueIsNotPreset() {
		OptionalDouble optional = OptionalDouble.of(null);
		Double other = 2.71;
		try {
			Double value = optional.orElseThrow(new IllegalOperationException('test'));
			System.assert(false, 'Exception was not thrown');
		} catch (IllegalOperationException e) {
			System.assertEquals('test', e.getMessage());
		}
	}

	@IsTest
	private static void orElseThrowReturnsValueWhenValueIsPresent() {
		Double d = 1.3;
		OptionalDouble optional = OptionalDouble.of(d);
		try {
			Double value = optional.orElseThrow(new IllegalOperationException('test'));
			System.assertEquals(d, value);
		} catch (IllegalOperationException e) {
			System.assert(false, 'Exception was thrown');
		}
	}

	@IsTest
	private static void emptyIsASingleton() {
		System.assertEquals(OptionalDouble.empty(), OptionalDouble.empty());
	}

	@IsTest
	private static void emptyIsNotPresent() {
		System.assertEquals(false, OptionalDouble.empty().isPresent());
	}
}
