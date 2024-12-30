@IsTest(IsParallel=true)
private class ModifySObjectTest {

	@IsTest
	private static void stringDefinedFieldIsUsed() {
		Opportunity opp = new Opportunity();
		new ModifySObject().setField('Amount', 1000).call(opp);
		System.Assert.areEqual(1000, opp.Amount);
	}

	@IsTest
	private static void fieldTokenDefinedFieldIsUsed() {
		Opportunity opp = new Opportunity();
		new ModifySObject().setField(Opportunity.Amount, 1000).call(opp);
		System.Assert.areEqual(1000, opp.Amount);
	}

	@IsTest
	private static void fieldTokenDefinedFieldAreUsed() {
		Opportunity opp = new Opportunity();
		new ModifySObject().setFields(new Map<SObjectField, Object>{
			Opportunity.Name => 'Test',
			Opportunity.Amount => 1000
		}).call(opp);
		System.Assert.areEqual(1000, opp.Amount);
		System.Assert.areEqual('Test', opp.Name);
	}

	@IsTest
	private static void prototypeDefinedFieldsAreUsed() {
		Opportunity opp = new Opportunity();
		new ModifySObject().setFields(new Opportunity(Amount = 1000, Name = 'Test')).call(opp);
		System.Assert.areEqual(1000, opp.Amount);
		System.Assert.areEqual('Test', opp.Name);
	}

	@IsTest
	private static void fieldsAreOverwritten() {
		Opportunity opp = new Opportunity(Amount = 1000);
		new ModifySObject().setFields(new Opportunity(Amount = 2000)).call(opp);
		System.Assert.areEqual(2000, opp.Amount);
	}

	@IsTest
	private static void exceptionIsThrownForNull() {
		try {
			new ModifySObject().setField(Opportunity.Amount, 100).call(null);
			System.Assert.fail();
		} catch (IllegalArgumentException e) {
			System.Assert.areEqual('Record is null', e.getMessage());
		}
	}
}