@IsTest(isParallel=true)
private class OptionalSObjectTest {
	@IsTest
	private static void optionalCanBeNull() {
		OptionalSObject optional = OptionalSObject.of(null);
	}

	@IsTest
	private static void nullIsNotPresent() {
		OptionalSObject optional = OptionalSObject.of(null);
		System.assertEquals(false, optional.isPresent());
	}

	@IsTest
	private static void getThrowsNoSuchElementExceptionWhenValueIsNotPresent() {
		OptionalSObject optional = OptionalSObject.of(null);
		try {
			SObject value = optional.get();
			System.assert(false, 'Exception was not thrown');
		} catch (NoSuchElementException e) {
			System.assert(true);
		}
	}

	@IsTest
	private static void getReturnsValueWhenValueIsPresent() {
		Account account = new Account(Name = 'Foo');
		OptionalSObject optional = OptionalSObject.of(account);
		SObject record = optional.get();
		System.assertEquals(account, record);
	}

	@IsTest
	private static void orElseReturnsOtherValueWhenValueIsNotPresent() {
		OptionalSObject optional = OptionalSObject.of(null);
		SObject other = new Account(Name = 'Foo');
		SObject value = optional.orElse(other);
		System.assertEquals(other, value);
	}

	@IsTest
	private static void orElseThrowThrowsWhenValueIsNotPreset() {
		OptionalSObject optional = OptionalSObject.of(null);
		SObject other = new Account(Name = 'Foo');
		try {
			SObject value = optional.orElseThrow(new IllegalOperationException('test'));
			System.assert(false, 'Exception was not thrown');
		} catch (IllegalOperationException e) {
			System.assertEquals('test', e.getMessage());
		}
	}

	@IsTest
	private static void emptyIsASingleton() {
		System.assertEquals(OptionalSObject.empty(), OptionalSObject.empty());
	}

	@IsTest
	private static void emptyIsNotPresent() {
		System.assertEquals(false, OptionalSObject.empty().isPresent());
	}
}
