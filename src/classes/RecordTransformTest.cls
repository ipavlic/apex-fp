@IsTest
public class RecordTransformTest {
	@IsTest
	public static void definedFieldsAreUsed() {
		Opportunity opp = new Opportunity();
		RecordTransform t = Transform.record(new Opportunity(Amount = 1000, Name = 'Test'));
		t.apply(opp);
		System.assertEquals(1000, opp.Amount);
		System.assertEquals('Test', opp.Name);
	}

	@IsTest
	public static void fieldsAreOverwritten() {
		Opportunity opp = new Opportunity(Amount = 1000);
		RecordTransform t = Transform.record(new Opportunity(Amount = 2000));
		t.apply(opp);
		System.assertEquals(2000, opp.Amount);
	}
}
