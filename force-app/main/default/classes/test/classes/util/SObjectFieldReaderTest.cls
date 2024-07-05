@IsTest(isParallel=true)
private class SObjectFieldReaderTest {
	@IsTest
	private static void testResolving() {
		Account acc = new Account(Name = 'Test');
		Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Opportunity', StageName = 'Prospecting', CloseDate = Date.today().addDays(7));
		opp.Account = acc;

		Object value = new SObjectFieldReader().read(opp, 'Account.Name');
		System.Assert.areEqual('Test', value);
	}

	@IsTest
	private static void testInvalidObjectRelationException() {
		Opportunity opp = new Opportunity(Name = 'Opportunity', StageName = 'Prospecting', CloseDate = Date.today().addDays(7));

		Exception ex;

		try {
			new SObjectFieldReader().read(opp, 'ObjectThatShouldNotExist.Name');
		} catch (LambdaException e) {
			ex = e;
		}
		System.Assert.areNotEqual(null, ex);
		System.Assert.isTrue(ex.getMessage().contains('Cannot resolve'));
	}

	@IsTest
	private static void testInvalidFieldRelationException() {
		Account acc = new Account(Name = 'Test');
		Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Opportunity', StageName = 'Prospecting', CloseDate = Date.today().addDays(7));
		opp.Account = acc;

		Exception ex;

		try {
		new SObjectFieldReader().read(opp, 'Account.FieldThatShouldNotExist');
		} catch (LambdaException e) {
			ex = e;
		}
		System.Assert.areNotEqual(null, ex);
		System.Assert.isTrue(ex.getMessage().contains('Cannot resolve'));
	}

	@IsTest
	private static void testBlankRelationException() {
		Opportunity opp = new Opportunity(Name = 'Opportunity', StageName = 'Prospecting', CloseDate = Date.today().addDays(7));

		Exception ex;

		try {
			new SObjectFieldReader().read(opp, '');
		} catch (IllegalArgumentException e) {
			ex = e;
		}
		System.Assert.areNotEqual(null, ex);
		System.Assert.isTrue(ex.getMessage().contains('is blank'));
	}
}
