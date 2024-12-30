@IsTest(IsParallel=true)
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
	private static void testBlankRelationException() {
		try {
			new SObjectFieldReader().read(new Opportunity(), '');
			System.Assert.fail();
		} catch (IllegalArgumentException e) {
			System.Assert.isTrue(e.getMessage().contains('is blank'));
		}
	}

	@IsTest
	private static void invalidFieldThrowsAnException() {
		try {
			new SObjectFieldReader().read(new Opportunity(), '!');
			System.Assert.fail();
		} catch (IllegalArgumentException e) {
			System.Assert.isTrue(e.getMessage().startsWith('Cannot resolve'));
		}
	}

	@IsTest
	private static void nullRelatedRecordThrowsAnException() {
		Account a = null;
		Opportunity opp = new Opportunity();
		opp.Account = a;
		try {
			new SObjectFieldReader().read(opp, 'Account.Name');
			System.Assert.fail();
		} catch (IllegalArgumentException e) {
			System.Assert.isTrue(e.getMessage().startsWith('Cannot resolve'));
		}
	}

	@IsTest
	private static void invalidObjectThrowsAnException() {
		Opportunity opp = new Opportunity();
		try {
			new SObjectFieldReader().read(opp, '!.Amount');
			System.Assert.fail();
		} catch (IllegalArgumentException e) {
			System.Assert.isTrue(e.getMessage().startsWith('Cannot resolve'));
		}
	}

	@IsTest
	private static void nullRecordThrowsAnException() {
		try {
			new SObjectFieldReader().read(null, 'Amount');
			System.Assert.fail();
		} catch (IllegalArgumentException e) {
			System.Assert.areEqual('Provided record is null', e.getMessage());
		}
	}
}
