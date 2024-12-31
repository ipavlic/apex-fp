@IsTest(IsParallel=true)
private class SObjectNotNullTest {
	@IsTest
	private static void nullSObjectReturnsFalse() {
		Assert.areEqual(false, new SObjectNotNull().call(null));
	}

	@IsTest
	private static void nonNullSObjectReturnsTrue() {
		Assert.areEqual(true, new SObjectNotNull().call(new Opportunity()));
	}
}