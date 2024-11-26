@IsTest(IsParallel=true)
private class OptionalSObjectTest {
	@IsTest
	private static void optionalCanHoldNull() {
		OptionalSObject optional = OptionalSObject.of(null);
		System.Assert.isNotNull(optional);
	}

	@IsTest
	private static void nullIsNotPresent() {
		OptionalSObject optional = OptionalSObject.of(null);
		System.Assert.isFalse(optional.isPresent());
	}

	@IsTest
	private static void getThrowsNoSuchElementExceptionWhenValueIsNotPresent() {
		OptionalSObject optional = OptionalSObject.of(null);
		try {
			optional.get();
			System.Assert.fail('Exception was not thrown');
		} catch (NoSuchElementException e) {
			System.Assert.isInstanceOfType(e, NoSuchElementException.class);
		}
	}

	@IsTest
	private static void getReturnsValueWhenValueIsPresent() {
		Account account = new Account(Name = 'Foo');
		OptionalSObject optional = OptionalSObject.of(account);
		SObject record = optional.get();
		System.Assert.areEqual(account, record);
	}

	@IsTest
	private static void orElseReturnsOtherValueWhenValueIsNotPresent() {
		OptionalSObject optional = OptionalSObject.of(null);
		SObject other = new Account(Name = 'Foo');
		SObject value = optional.orElse(other);
		System.Assert.areEqual(other, value);
	}

	@IsTest
	private static void orElseThrowThrowsWhenValueIsNotPreset() {
		OptionalSObject optional = OptionalSObject.of(null);
		try {
			optional.orElseThrow(new IllegalOperationException('test'));
			System.Assert.fail('Exception was not thrown');
		} catch (IllegalOperationException e) {
			System.Assert.areEqual('test', e.getMessage());
		}
	}

	@IsTest
	private static void emptyIsASingleton() {
		System.Assert.areEqual(OptionalSObject.empty(), OptionalSObject.empty());
	}

	@IsTest
	private static void emptyIsNotPresent() {
		System.Assert.isFalse(OptionalSObject.empty().isPresent());
	}
}
