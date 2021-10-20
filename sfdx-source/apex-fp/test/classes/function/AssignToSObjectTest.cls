@IsTest(isParallel=true)
private class AssignToSObjectTest {
	@IsTest
	private static void definedFieldsAreUsed() {
		Opportunity opp = new Opportunity();
		new AssignToSObject().setFields(new Opportunity(Amount = 1000, Name = 'Test')).call(opp);
		System.assertEquals(1000, opp.Amount);
		System.assertEquals('Test', opp.Name);
	}

	@IsTest
	private static void fieldsAreOverwritten() {
		Opportunity opp = new Opportunity(Amount = 1000);
		new AssignToSObject().setFields(new Opportunity(Amount = 2000)).call(opp);
		System.assertEquals(2000, opp.Amount);
	}
}