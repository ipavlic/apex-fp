@IsTest
public class CopyTest {
	@IsTest
	public static void definedFieldsAreUsed() {
		Opportunity opp = new Opportunity();
		Copy.recordFields(new Opportunity(Amount = 1000, Name = 'Test')).apply(opp);
		System.assertEquals(1000, opp.Amount);
		System.assertEquals('Test', opp.Name);
	}

	@IsTest
	public static void fieldsAreOverwritten() {
		Opportunity opp = new Opportunity(Amount = 1000);
		Copy.recordFields(new Opportunity(Amount = 2000)).apply(opp);
		System.assertEquals(2000, opp.Amount);
	}
}
