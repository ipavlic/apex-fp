@IsTest
private class SObjectFieldReaderTest {
	@IsTest
	static void testResolving() {
		Account acc = new Account(Name = 'Test');
		Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Opportunity', StageName = 'Prospecting', CloseDate = Date.today().addDays(7));
		opp.Account = acc;

		Object value = new SObjectFieldReader().read(opp, 'Account.Name');
		System.assertEquals('Test', value);
	}

	@IsTest
	static void testInvalidObjectRelationException() {
		Opportunity opp = new Opportunity(Name = 'Opportunity', StageName = 'Prospecting', CloseDate = Date.today().addDays(7));

		Exception ex;

		try {
			new SObjectFieldReader().read(opp, 'ObjectThatShouldNotExist.Name');
		} catch (LambdaException e) {
			ex = e;
		}
		System.assert(ex != null);
		System.assert(ex.getMessage().contains('Cannot resolve'));
	}

	@IsTest
	static void testInvalidFieldRelationException() {
		Account acc = new Account(Name = 'Test');
		Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Opportunity', StageName = 'Prospecting', CloseDate = Date.today().addDays(7));
		opp.Account = acc;

		Exception ex;

		try {
		new SObjectFieldReader().read(opp, 'Account.FieldThatShouldNotExist');
		} catch (LambdaException e) {
			ex = e;
		}
		System.assert(ex != null);
		System.assert(ex.getMessage().contains('Cannot resolve'));
	}

	@IsTest
	static void testBlankRelationException() {
		Opportunity opp = new Opportunity(Name = 'Opportunity', StageName = 'Prospecting', CloseDate = Date.today().addDays(7));

		Exception ex;

		try {
			new SObjectFieldReader().read(opp, '');
		} catch (LambdaException e) {
			ex = e;
		}
		System.assert(ex != null);
		System.assert(ex.getMessage().contains('is blank'));
	}
}
