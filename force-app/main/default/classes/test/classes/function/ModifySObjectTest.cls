@IsTest(isParallel=true)
private class ModifySObjectTest {
	@IsTest
	private static void definedFieldsAreUsed() {
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
}