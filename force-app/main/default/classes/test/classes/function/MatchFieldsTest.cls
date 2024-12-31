@IsTest
private class MatchFieldsTest {
	@IsTest
	static void containsDecimal() {
		System.Assert.isTrue(new MatchFields().field(Opportunity.Amount).isIn(new Set<Decimal>{10.0}).call(new Opportunity(Amount = 10.0)));
	}

	@IsTest
	static void containsDouble() {
		System.Assert.isTrue(new MatchFields().field(Opportunity.Amount).isIn(new Set<Double>{10.0}).call(new Opportunity(Amount = 10.0)));
	}

	@IsTest
	static void containsInteger() {
		System.Assert.isTrue(new MatchFields().field(Account.NumberOfEmployees).isIn(new Set<Integer>{10}).call(new Account(NumberOfEmployees = 10)));
	}

	@IsTest
	static void containsLong() {
		System.Assert.isTrue(new MatchFields().field(Account.NumberOfEmployees).isIn(new Set<Long>{10L}).call(new Account(NumberOfEmployees = 10)));
	}

	@IsTest
	static void containsBoolean() {
		System.Assert.isTrue(new MatchFields().field(Contact.DoNotCall).isIn(new Set<Boolean>{false}).call(new Contact(DoNotCall = false)));
		System.Assert.isFalse(new MatchFields().field(Contact.DoNotCall).isIn(new Set<Boolean>{true}).call(new Contact(DoNotCall = false)));
	}

	@IsTest
	static void containsDate() {
		Date today = Date.today();
		System.Assert.isTrue(new MatchFields().field(Event.ActivityDate).isIn(new Set<Date>{today}).call(new Event(ActivityDate = today)));
	}

	@IsTest
	static void containsDatetime() {
		Datetime now = Datetime.now();
		System.Assert.isTrue(new MatchFields().field(Event.ActivityDateTime).isIn(new Set<Datetime>{now}).call(new Event(ActivityDateTime = now)));
	}

	@IsTest
	static void containsId() {
		Id oppId = TestUtility.getFakeId(Opportunity.SObjectType);
		System.Assert.isTrue(new MatchFields().field(Opportunity.Id).isIn(new Set<Id>{oppId}).call(new Opportunity(Id = oppId)));
		System.Assert.isFalse(new MatchFields().field(Opportunity.Id).isIn(new Set<Id>{oppId}).call(new Opportunity(Id = TestUtility.getFakeId(Opportunity.SObjectType))));
	}

	@IsTest
	static void containsString() {
		System.Assert.isTrue(new MatchFields().field(Opportunity.Name).isIn(new Set<String>{'foo'}).call(new Opportunity(Name = 'foo')));
		System.Assert.isFalse(new MatchFields().field(Opportunity.Name).isIn(new Set<String>{'foo'}).call(new Opportunity(Name = 'bar')));
	}

	@IsTest
	static void containsString() {
		System.Assert.isTrue(new MatchFields().field(Opportunity.Name).isIn(new Set<String>{'foo'}).call(new Opportunity(Name = 'foo')));
		System.Assert.isFalse(new MatchFields().field(Opportunity.Name).isIn(new Set<String>{'foo'}).call(new Opportunity(Name = 'bar')));
	}
}