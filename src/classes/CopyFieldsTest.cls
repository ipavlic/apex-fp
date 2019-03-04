@IsTest
public class CopyFieldsTest {
	@IsTest
	public static void definedFieldsAreUsed() {
		Opportunity opp = new Opportunity();
		CopyFields c = CopyFields.fromRecord(new Opportunity(Amount = 1000, Name = 'Test'));
		c.apply(opp);
		System.assertEquals(1000, opp.Amount);
		System.assertEquals('Test', opp.Name);
	}

	@IsTest
	public static void fieldsAreOverwritten() {
		Opportunity opp = new Opportunity(Amount = 1000);
		CopyFields c = CopyFields.fromRecord(new Opportunity(Amount = 2000));
		c.apply(opp);
		System.assertEquals(2000, opp.Amount);
	}
}
