@IsTest
private class MatchFieldsTest {
	@IsTest
	static void isInDecimal() {
		System.Assert.isTrue(new MatchFields().field(Opportunity.Amount).isIn(new Set<Decimal>{10.0}).call(new Opportunity(Amount = 10.0)));
	}

	@IsTest
	static void isInDouble() {
		System.Assert.isTrue(new MatchFields().field(Opportunity.Amount).isIn(new Set<Double>{10.0}).call(new Opportunity(Amount = 10.0)));
	}

	@IsTest
	static void isInInteger() {
		System.Assert.isTrue(new MatchFields().field(Account.NumberOfEmployees).isIn(new Set<Integer>{10}).call(new Account(NumberOfEmployees = 10)));
	}

	@IsTest
	static void isInLong() {
		System.Assert.isTrue(new MatchFields().field(Account.NumberOfEmployees).isIn(new Set<Long>{10L}).call(new Account(NumberOfEmployees = 10)));
	}

	@IsTest
	static void isInBoolean() {
		System.Assert.isTrue(new MatchFields().field(Contact.DoNotCall).isIn(new Set<Boolean>{false}).call(new Contact(DoNotCall = false)));
		System.Assert.isFalse(new MatchFields().field(Contact.DoNotCall).isIn(new Set<Boolean>{true}).call(new Contact(DoNotCall = false)));
	}

	@IsTest
	static void isInDate() {
		Date today = Date.today();
		System.Assert.isTrue(new MatchFields().field(Event.ActivityDate).isIn(new Set<Date>{today}).call(new Event(ActivityDate = today)));
	}

	@IsTest
	static void isInDatetime() {
		Datetime now = Datetime.now();
		System.Assert.isTrue(new MatchFields().field(Event.ActivityDateTime).isIn(new Set<Datetime>{now}).call(new Event(ActivityDateTime = now)));
	}

	@IsTest
	static void isInId() {
		Id oppId = TestUtility.getFakeId(Opportunity.SObjectType);
		System.Assert.isTrue(new MatchFields().field(Opportunity.Id).isIn(new Set<Id>{oppId}).call(new Opportunity(Id = oppId)));
		System.Assert.isFalse(new MatchFields().field(Opportunity.Id).isIn(new Set<Id>{oppId}).call(new Opportunity(Id = TestUtility.getFakeId(Opportunity.SObjectType))));
	}

	@IsTest
	static void isInString() {
		System.Assert.isTrue(new MatchFields().field(Opportunity.Name).isIn(new Set<String>{'foo'}).call(new Opportunity(Name = 'foo')));
		System.Assert.isFalse(new MatchFields().field(Opportunity.Name).isIn(new Set<String>{'foo'}).call(new Opportunity(Name = 'bar')));
	}

	@IsTest
	static void isInThrowsExceptionForUnsupportedSetTypes() {
		try {
			new MatchFields().field(Opportunity.Name).isIn(new Set<Opportunity>{}).call(new Opportunity(Name = 'foo'));
			System.Assert.fail();
		} catch (IllegalArgumentException e) {
			System.Assert.isTrue(e.getMessage().startsWith('Provided set type is not supported'));
		}
	}

	@IsTest
	static void isNotIn() {
		System.Assert.isTrue(new MatchFields().field(Opportunity.Name).isNotIn(new Set<String>{'foo'}).call(new Opportunity(Name = 'bar')));
	}

	@IsTest
	static void fieldPathCanBeUsedForMatching() {
		Opportunity opp = new Opportunity(Account = new Account(Name = 'foo'));
		System.Assert.isTrue(new MatchFields().field('Account.Name').equals('foo').call(opp));
		System.Assert.isFalse(new MatchFields().field('Account.Name').equals('bar').call(opp));
	}

	@IsTest
	static void alsoAddsAnotherConditionWithFieldPath() {
		Opportunity opp = new Opportunity(Account = new Account(Name = 'foo'), Name = 'bar');
		System.Assert.isTrue(new MatchFields().field('Account.Name').equals('foo').also('Name').equals('bar').call(opp));
		System.Assert.isFalse(new MatchFields().field('Account.Name').equals('foo').also('Name').equals('baz').call(opp));
	}

	@IsTest
	static void nullEqualsNullIsTrue() {
		Opportunity opp = new Opportunity(Name = null);
		System.Assert.isTrue(new MatchFields().field(Opportunity.Name).equals(null).call(opp));
	}

	@IsTest
	static void notNullEqualsNullIsFalse() {
		Opportunity opp = new Opportunity(Name = 'foo');
		System.Assert.isFalse(new MatchFields().field(Opportunity.Name).equals(null).call(opp));
	}

	@IsTest
	static void nullNotEqualsNullIsFalse() {
		Opportunity opp = new Opportunity(Name = null);
		System.Assert.isFalse(new MatchFields().field(Opportunity.Name).notEquals(null).call(opp));
	}

	@IsTest
	static void notNullNotEqualsNullIsTrue() {
		Opportunity opp = new Opportunity(Name = 'foo');
		System.Assert.isTrue(new MatchFields().field(Opportunity.Name).notEquals(null).call(opp));
	}

	@IsTest
	static void inequalityComparisonsWithNullReturnFalse() {
		Opportunity opp = new Opportunity(Amount = 10);
		System.Assert.isFalse(new MatchFields().field(Opportunity.Amount).greaterThan(null).call(opp));
		System.Assert.isFalse(new MatchFields().field(Opportunity.Amount).greaterThanOrEquals(null).call(opp));
		System.Assert.isFalse(new MatchFields().field(Opportunity.Amount).lessThan(null).call(opp));
		System.Assert.isFalse(new MatchFields().field(Opportunity.Amount).lessThanOrEquals(null).call(opp));
		System.Assert.isFalse(new MatchFields().field(Opportunity.Amount).gt(null).call(opp));
		System.Assert.isFalse(new MatchFields().field(Opportunity.Amount).geq(null).call(opp));
		System.Assert.isFalse(new MatchFields().field(Opportunity.Amount).lt(null).call(opp));
		System.Assert.isFalse(new MatchFields().field(Opportunity.Amount).leq(null).call(opp));
	}

	@IsTest
	static void lessThan() {
		Opportunity opp = new Opportunity(Amount = 100);
		System.Assert.isTrue(new MatchFields().field(Opportunity.Amount).lessThan(200).call(opp));
		System.Assert.isFalse(new MatchFields().field(Opportunity.Amount).lessThan(100).call(opp));
		System.Assert.isFalse(new MatchFields().field(Opportunity.Amount).lessThan(50).call(opp));
	}

	@IsTest
	static void lessThanOrEquals() {
		Opportunity opp = new Opportunity(Amount = 100);
		System.Assert.isTrue(new MatchFields().field(Opportunity.Amount).lessThanOrEquals(100).call(opp));
		System.Assert.isFalse(new MatchFields().field(Opportunity.Amount).lessThanOrEquals(50).call(opp));
	}

	@IsTest
	static void greaterThan() {
		Opportunity opp = new Opportunity(Amount = 100);
		System.Assert.isTrue(new MatchFields().field(Opportunity.Amount).greaterThan(50).call(opp));
		System.Assert.isFalse(new MatchFields().field(Opportunity.Amount).greaterThan(100).call(opp));
		System.Assert.isFalse(new MatchFields().field(Opportunity.Amount).greaterThan(200).call(opp));
	}

	@IsTest
	static void greaterThanOrEquals() {
		Opportunity opp = new Opportunity(Amount = 100);
		System.Assert.isTrue(new MatchFields().field(Opportunity.Amount).greaterThanOrEquals(100).call(opp));
		System.Assert.isFalse(new MatchFields().field(Opportunity.Amount).greaterThanOrEquals(200).call(opp));
	}
}