@IsTest
public class AssignToSObjectTest {
	@IsTest
	public static void definedFieldsAreUsed() {
		Opportunity opp = new Opportunity();
		AssignTo.SObject().setFields(new Opportunity(Amount = 1000, Name = 'Test')).call(opp);
		System.assertEquals(1000, opp.Amount);
		System.assertEquals('Test', opp.Name);
	}

	@IsTest
	public static void fieldsAreOverwritten() {
		Opportunity opp = new Opportunity(Amount = 1000);
		AssignTo.SObject().setFields(new Opportunity(Amount = 2000)).call(opp);
		System.assertEquals(2000, opp.Amount);
	}
}
