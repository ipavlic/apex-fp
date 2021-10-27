@IsTest(isParallel=true)
private class SObjectCollectionTest {

	static Id firstUserId = TestUtility.getFakeId(User.SObjectType);
	static Id secondUserId = TestUtility.getFakeId(User.SObjectType);

	static List<Account> testAccounts() {
		return new List<Account>{
			new Account(Id = TestUtility.getFakeId(Account.SObjectType), OwnerId = firstUserId, Name = 'Foo', AnnualRevenue = 100),
			new Account(Id = TestUtility.getFakeId(Account.SObjectType), OwnerId = firstUserId, Name = 'Bar', AnnualRevenue = 60),
			new Account(Id = TestUtility.getFakeId(Account.SObjectType), OwnerId = secondUserId, Name = 'Foo', AnnualRevenue = 150),
			new Account(Id = TestUtility.getFakeId(Account.SObjectType), OwnerId = secondUserId, Name = 'Bar', AnnualRevenue = 150)
		};
	}

	@IsTest
	private static void testAsMap() {
		Map<Id, SObject> recordMap = SObjectCollection.of(testAccounts()).asMap();
		System.assertEquals(4, recordMap.size());
	}

	@IsTest
	private static void testAsTypedMap() {
		List<Account> accounts = testAccounts();
		Map<Id, Account> accountMap = (Map<Id, Account>) SObjectCollection.of(accounts).asMap(Map<Id, Account>.class);
		System.assertEquals(accounts[0], accountMap.get(accounts[0].Id));
	}

	@IsTest
	private static void testDifference() {
		Id accountId1 = TestUtility.getFakeId(Account.SObjectType);
		Id accountId2 = TestUtility.getFakeId(Account.SObjectType);
		Id accountId3 = TestUtility.getFakeId(Account.SObjectType);

		SObjectCollection c1 = SObjectCollection.of(new List<Account>{
			new Account(Id = accountId1, Name = 'Foo')
		});

		SObjectCollection c2 = SObjectCollection.of(new List<Account>{
			new Account(Id = accountId1, Name = 'Bar')
		});

		SObjectCollection diff1 = c1.difference(c2, new Set<Schema.SObjectField>{Account.Name});
		List<Account> diffList1 = diff1.asList();
		System.assertEquals(1, diffList1.size());
		System.assertEquals(accountId1, diffList1[0].Id);

		SObjectCollection diff2 = c1.difference(c2, new Set<Schema.SObjectField>{Account.Name});
		List<Account> diffList2 = diff2.asList();
		System.assertEquals(1, diffList2.size());
		System.assertEquals(accountId1, diffList2[0].Id);

		SObjectCollection diff3 = c1.difference(c2, new Set<Schema.SObjectField>{Account.Name, Account.Id});
		List<Account> diffList3 = diff3.asList();
		System.assertEquals(1, diffList3.size());
		System.assertEquals(accountId1, diffList3[0].Id);

		SObjectCollection c3 = SObjectCollection.of(new List<Account>{
			new Account(Id = accountId1, Name = 'Foo'),
			new Account(Id = accountId2, Name = 'Bar'),
			new Account(Id = accountId3, Name = 'Baz')
		});

		SObjectCollection c4 = SObjectCollection.of(new List<Account>{
			new Account(Id = accountId1, Name = 'Foo'),
			new Account(Id = accountId3, Name = 'Baz')
		});

		SObjectCollection diff4 = c3.difference(c4, new Set<Schema.SObjectField>{Account.Name, Account.Id});
		List<Account> diffList4 = diff4.asList();
		System.assertEquals(1, diffList4.size());
		System.assertEquals(accountId2, diffList4[0].Id);
	}

	@IsTest
	private static void testPluckDecimals() {
		List<Decimal> revenues = SObjectCollection.of(testAccounts()).pluckDecimals(Account.AnnualRevenue);
		System.assertEquals(4, revenues.size());
		System.assertEquals(100.0, revenues[0]);
		System.assertEquals(60.0, revenues[1]);
		System.assertEquals(150.0, revenues[2]);
		System.assertEquals(150.0, revenues[3]);
	}

	@IsTest
	private static void testPluckStrings() {
		List<String> names = SObjectCollection.of(testAccounts()).pluckStrings(Account.Name);
		System.assertEquals(4, names.size());
		System.assertEquals('Foo', names[0]);
		System.assertEquals('Bar', names[1]);
		System.assertEquals('Foo', names[2]);
		System.assertEquals('Bar', names[3]);
	}

	@IsTest
	private static void testPluckIdsAsStrings() {
		List<String> ownerIds = SObjectCollection.of(testAccounts()).pluckStrings(Account.OwnerId);
		System.assertEquals(4, ownerIds.size());
		System.assertEquals(firstUserId, ownerIds[0]);
		System.assertEquals(firstUserId, ownerIds[1]);
		System.assertEquals(secondUserId, ownerIds[2]);
		System.assertEquals(secondUserId, ownerIds[3]);
	}

	@IsTest
	private static void testPluckIds() {
		List<Id> ownerIds = SObjectCollection.of(testAccounts()).pluckIds(Account.OwnerId);
		// workaround for List.contains bug
		Set<Id> idSet = new Set<Id>(ownerIds);
		System.assertEquals(2, idSet.size());
		System.assert(idSet.contains(firstUserId));
		System.assert(idSet.contains(secondUserId));
	}

	@IsTest
	private static void testPluckRecordIds() {
		List<Account> accounts = testAccounts();
		List<Id> recordIds = SObjectCollection.of(accounts).pluckIds();
		System.assertEquals(4, recordIds.size());
		// workaround for List.contains bug
		Set<Id> idSet = new Set<Id>(recordIds);
		System.assert(idSet.contains(accounts[0].Id));
		System.assert(idSet.contains(accounts[1].Id));
		System.assert(idSet.contains(accounts[2].Id));
		System.assert(idSet.contains(accounts[3].Id));
	}

	@IsTest
	private static void testPluckBooleans() {
		List<User> users = new List<User>{
			new User(Title = 'Foo', IsActive = true),
			new User(Title = 'Bar', IsActive = true),
			new User(Title = 'Baz', IsActive = false)
		};
		List<Boolean> active = SObjectCollection.of(users).pluckBooleans(User.IsActive);
		System.assertEquals(3, active.size());
		System.assertEquals(true, active[0]);
		System.assertEquals(true, active[1]);
		System.assertEquals(false, active[2]);
	}

	@IsTest
	private static void testFieldsMatchFilter() {
		SObjectCollection c = SObjectCollection.of(new List<Account>{
			new Account(Id = TestUtility.getFakeId(Account.SObjectType), OwnerId = firstUserId, Name = 'Foo', AnnualRevenue = 100),
			new Account(Id = TestUtility.getFakeId(Account.SObjectType), OwnerId = firstUserId, Name = 'Bar', AnnualRevenue = 60),
			new Account(Id = TestUtility.getFakeId(Account.SObjectType), OwnerId = secondUserId, Name = 'Foo', AnnualRevenue = 150),
			new Account(Id = TestUtility.getFakeId(Account.SObjectType), OwnerId = secondUserId, Name = 'Bar', AnnualRevenue = 150)
		});

		List<Account> filtered = c.filter(Fn.Match.field(Account.AnnualRevenue).eq(150)).asList();
		System.assertEquals(2, filtered.size());

		for (Account a : filtered) {
			System.assertEquals(150, a.AnnualRevenue);
		}
	}

	@IsTest
	private static void testGroupByStrings() {
		SObjectCollection c = SObjectCollection.of(testAccounts());
		Map<String, List<Account>> accountsByName = c.groupByStrings(Account.Name);
		System.assertEquals(2, accountsByName.size());
		System.assert(accountsByName.keySet().contains('Foo'));
		System.assert(accountsByName.keySet().contains('Bar'));
		System.assertEquals(2, accountsByName.get('Foo').size());
		System.assertEquals(2, accountsByName.get('Bar').size());
		for (Account a : accountsByName.get('Foo')) {
			System.assertEquals('Foo', a.Name);
		}
		for (Account a : accountsByName.get('Bar')) {
			System.assertEquals('Bar', a.Name);
		}
	}

	@IsTest
	private static void testGroupByStringsApiFieldName() {
		SObjectCollection c = SObjectCollection.of(testAccounts());
		Map<String, List<Account>> accountsByName = c.groupByStrings('Name');
		System.assertEquals(2, accountsByName.size());
		System.assert(accountsByName.keySet().contains('Foo'));
		System.assert(accountsByName.keySet().contains('Bar'));
		System.assertEquals(2, accountsByName.get('Foo').size());
		System.assertEquals(2, accountsByName.get('Bar').size());
		for (Account a : accountsByName.get('Foo')) {
			System.assertEquals('Foo', a.Name);
		}
		for (Account a : accountsByName.get('Bar')) {
			System.assertEquals('Bar', a.Name);
		}
	}

	@IsTest
	private static void testGroupByStringTyping() {
		SObjectCollection c = SObjectCollection.of(testAccounts());
		Map<String, List<Account>> accountsByName = c.groupByStrings(Account.Name);
		List<Account> fooAccounts = accountsByName.get('Foo');
		List<SObject> objects = fooAccounts;
		// since fooAccounts points to a returned list of SObjects, it can be anything!
		System.assert(objects instanceof List<Opportunity>);

		accountsByName = c.groupBystrings(Account.Name, List<Account>.class);
		fooAccounts = accountsByName.get('Foo');
		objects = fooAccounts;
		// this time around, it works fine!
		System.assert(!(objects instanceof List<Opportunity>));
		System.assert(objects instanceof List<Account>);
	}

	@IsTest
	private static void testGroupByStringTypingApiFieldName() {
		SObjectCollection c = SObjectCollection.of(testAccounts());
		Map<String, List<Account>> accountsByName = c.groupByStrings('Name');
		List<Account> fooAccounts = accountsByName.get('Foo');
		List<SObject> objects = fooAccounts;
		// since fooAccounts points to a returned list of SObjects, it can be anything!
		System.assert(objects instanceof List<Opportunity>);

		accountsByName = c.groupBystrings(Account.Name, List<Account>.class);
		fooAccounts = accountsByName.get('Foo');
		objects = fooAccounts;
		// this time around, it works fine!
		System.assert(!(objects instanceof List<Opportunity>));
		System.assert(objects instanceof List<Account>);
	}

	@IsTest
	private static void testGroupByDecimals() {
		SObjectCollection c = SObjectCollection.of(testAccounts());
		Map<Decimal, List<Account>> accountsByRevenue = c.groupByDecimals(Account.AnnualRevenue);
		System.assertEquals(3, accountsByRevenue.size());
		System.assert(accountsByRevenue.keySet().contains(60));
		System.assert(accountsByRevenue.keySet().contains(100));
		System.assert(accountsByRevenue.keySet().contains(150));
		System.assertEquals(1, accountsByRevenue.get(60).size());
		System.assertEquals(1, accountsByRevenue.get(100).size());
		System.assertEquals(2, accountsByRevenue.get(150).size());
		for (Account a : accountsByRevenue.get(150)) {
			System.assertEquals(150.0, a.AnnualRevenue);
		}
	}

	@IsTest
	private static void testGroupByDecimalsApiFieldName() {
		SObjectCollection c = SObjectCollection.of(testAccounts());
		Map<Decimal, List<Account>> accountsByRevenue = c.groupByDecimals('AnnualRevenue');
		System.assertEquals(3, accountsByRevenue.size());
		System.assert(accountsByRevenue.keySet().contains(60));
		System.assert(accountsByRevenue.keySet().contains(100));
		System.assert(accountsByRevenue.keySet().contains(150));
		System.assertEquals(1, accountsByRevenue.get(60).size());
		System.assertEquals(1, accountsByRevenue.get(100).size());
		System.assertEquals(2, accountsByRevenue.get(150).size());
		for (Account a : accountsByRevenue.get(150)) {
			System.assertEquals(150.0, a.AnnualRevenue);
		}
	}

	@IsTest
	private static void testGroupByIds() {
		SObjectCollection c = SObjectCollection.of(testAccounts());
		Map<Id, List<Account>> accountsByOwners = c.groupByIds(Account.OwnerId);
		System.assertEquals(2, accountsByOwners.size());
		System.assert(accountsByOwners.keySet().contains(firstUserId));
		System.assert(accountsByOwners.keySet().contains(secondUserId));
		System.assertEquals(2, accountsByOwners.get(firstUserId).size());
		System.assertEquals(2, accountsByOwners.get(secondUserId).size());
		for (Account a : accountsByOwners.get(firstUserId)) {
			System.assertEquals(firstUserId, a.OwnerId);
		}
	}

	@IsTest
	private static void testGroupByIdsApiFieldName() {
		SObjectCollection c = SObjectCollection.of(testAccounts());
		Map<Id, List<Account>> accountsByOwners = c.groupByIds('OwnerId');
		System.assertEquals(2, accountsByOwners.size());
		System.assert(accountsByOwners.keySet().contains(firstUserId));
		System.assert(accountsByOwners.keySet().contains(secondUserId));
		System.assertEquals(2, accountsByOwners.get(firstUserId).size());
		System.assertEquals(2, accountsByOwners.get(secondUserId).size());
		for (Account a : accountsByOwners.get(firstUserId)) {
			System.assertEquals(firstUserId, a.OwnerId);
		}
	}

	@IsTest
	private static void testGroupByBooleans() {
		SObjectCollection c = SObjectCollection.of(new List<User>{
			new User(Title = 'Foo', IsActive = true),
			new User(Title = 'Bar', IsActive = true),
			new User(Title = 'Baz', IsActive = false)
		});
		Map<Boolean, List<User>> usersByActive = c.groupByBooleans(User.IsActive);
		System.assertEquals(2, usersByActive.size());
		System.assert(usersByActive.keySet().contains(true));
		System.assert(usersByActive.keySet().contains(false));
		System.assertEquals(2, usersByActive.get(true).size());
		System.assertEquals(1, usersByActive.get(false).size());
		for (User u : usersByActive.get(true)) {
			System.assertEquals(true, u.IsActive);
		}
	}

	@IsTest
	private static void testGroupByBooleansApiFieldName() {
		SObjectCollection c = SObjectCollection.of(new List<User>{
			new User(Title = 'Foo', IsActive = true),
			new User(Title = 'Bar', IsActive = true),
			new User(Title = 'Baz', IsActive = false)
		});
		Map<Boolean, List<User>> usersByActive = c.groupByBooleans('IsActive');
		System.assertEquals(2, usersByActive.size());
		System.assert(usersByActive.keySet().contains(true));
		System.assert(usersByActive.keySet().contains(false));
		System.assertEquals(2, usersByActive.get(true).size());
		System.assertEquals(1, usersByActive.get(false).size());
		for (User u : usersByActive.get(true)) {
			System.assertEquals(true, u.IsActive);
		}
	}

	@IsTest
	private static void pickShouldPickFields() {
		SObjectCollection c = SObjectCollection.of(new List<Account>{
			new Account(Name = 'Test1', AnnualRevenue = 100),
			new Account(Name = 'Test2', AnnualRevenue = 200)
		});
		verifyNamePick(c.pick(new List<Schema.SObjectField>{Account.Name}));
		verifyNamePick(c.pick(new Set<Schema.SObjectField>{Account.Name}));
		verifyNamePick(c.pick(new List<String>{'Name'}));
		verifyNamePick(c.pick(new Set<String>{'Name'}));
	}

	@IsTest
	private static void pickedFieldsShouldHaveValues() {
		SObjectCollection c = SObjectCollection.of(new List<Opportunity>{
			new Opportunity(Name = 'Test', Amount = 100, Description = 'Test description')
		});
		List<Opportunity> picked = c.pick(new List<String>{'Name', 'Amount'}).asList();
		System.assertEquals(1, picked.size());
		for (Opportunity opp : picked) {
			System.assertEquals('Test', opp.Name);
			System.assertEquals(100, opp.Amount);
		}
	}

	@IsTest
	private static void pickShouldPickHeterogenousRecords() {
		SObjectCollection c = SObjectCollection.of(new List<SObject>{
			new Account(Name = 'Test1', AnnualRevenue = 100),
			new Opportunity(Name = 'Test1', Description = 'Test description')
		});
		verifyNamePick(c.pick(new List<String>{'Name'}));
		verifyNamePick(c.pick(new Set<String>{'Name'}));
	}

	@IsTest
	private static void pickShouldHaveMatchingObjectTypes() {
		SObjectCollection c = SObjectCollection.of(new List<SObject>{
			new Account(Name = 'Test1', AnnualRevenue = 100),
			new Opportunity(Name = 'Test1', Description = 'Test description')
		});
		List<SObject> picked = c.pick(new List<String>{'Name'}).asList();
		System.assertEquals(Account.sObjectType, picked[0].getSObjectType(), 'First picked element should be an Account.');
		System.assertEquals(Opportunity.sObjectType, picked[1].getSObjectType(), 'Second picked element should be an Opportunity.');
	}

	private static void verifyNamePick(SObjectCollection picked) {
		for (SObject obj : picked.asList()) {
			Map<String, Object> fields = obj.getPopulatedFieldsAsMap();
			System.assertEquals(1, fields.size());
			System.assert(fields.containsKey('Name'));
		}
	}

	static List<Account> testFilterAccounts() {
		List<Account> accounts = new List<Account>{
			new Account(Name = 'Ok', AnnualRevenue = 100),
			new Account(Name = 'Wrong', AnnualRevenue = 60),
			new Account(Name = 'Ok', AnnualRevenue = 150),
			new Account(Name = 'Wrong', AnnualRevenue = 150)
		};
		return accounts;
	}

	@IsTest
	private static void testRelationalFiltering() {
		List<Account> accounts = new List<Account>{
			new Account(Name = 'Ok', AnnualRevenue = 100),
			new Account(Name = 'Wrong', AnnualRevenue = 60)
		};
		List<Opportunity> opps = new List<Opportunity>{
			new Opportunity(
				Name = 'First',
				CloseDate = Date.today().addDays(3),
				Account = accounts[0]
			),
			new Opportunity(
				Name = 'Second',
				CloseDate = Date.today().addDays(6),
				Account = accounts[1]
			)
		};
		SObjectCollection c = SObjectCollection.of(opps);
		List<Opportunity> filtered = (List<Opportunity>) c.filter(Fn.Match.field('Account.AnnualRevenue').greaterThan(70)).asList();
		System.assertEquals(1, filtered.size());
		System.assertEquals('First', filtered[0].Name);
	}

	@IsTest
	private static void testHasValue() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());
		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.BillingCountry).hasValue()).asList();
		System.assertEquals(0, filtered.size());

		filtered = (List<Account>) c.filter(Fn.Match.field(Account.Name).hasValue()).asList();
		System.assertEquals(4, filtered.size());

	}

	@IsTest
	private static void testIsIn() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());
		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.AnnualRevenue).isIn(new Set<Decimal>{60, 150})).asList();
		System.assertEquals(3, filtered.size());
		for (Account acc : filtered) {
			System.assert(acc.AnnualRevenue == 60 || acc.AnnualRevenue == 150);
		}
	}

	@IsTest
	private static void testIsNotIn() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());
		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.AnnualRevenue).notIn(new Set<Decimal>{60})).asList();
		System.assertEquals(3, filtered.size());
		for (Account acc : filtered) {
			System.assert(acc.AnnualRevenue == 100 || acc.AnnualRevenue == 150);
		}
	}

	@IsTest
	private static void testUnsupportedFilteringType() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());

		try {
			List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.Name).equals(TimeZone.getTimeZone('CET'))).asList();
			System.assert(false);
		} catch (LambdaException e) {
			System.assert(e.getMessage().contains('not supported'));
		}
	}

	@IsTest
	private static void testFieldEqualsOkFilter() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.Name).equals('Ok')).asList();

		System.assertEquals(2, filtered.size());
		for (Account acc : filtered) {
			System.assertEquals('Ok', acc.Name);
		}

		List<Account> remaining = (List<Account>) c.remove(Fn.Match.field(Account.Name).equals('Ok')).asList();

		System.assertEquals(2, remaining.size());
		for (Account acc : remaining) {
			System.assertEquals('Wrong', acc.Name);
		}
	}

	@IsTest
	private static void testMultipleFieldFilter() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());
		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).gt(100)).asList();

		System.assertEquals(1, filtered.size());
		for (Account acc : filtered) {
			System.assertEquals('Ok', acc.Name);
			System.assert(acc.AnnualRevenue > 100);
		}

		List<Account> remaining = (List<Account>) c.remove(Fn.Match.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).gt(100)).asList();

		System.assertEquals(3, remaining.size());
		for (Account acc : remaining) {
			System.assert(acc.AnnualRevenue <= 100 || acc.Name != 'Ok');
		}
	}

	@IsTest
	private static void testSameFieldTokenExclusionCriteria() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok')).asList();
		System.assertEquals(0, filtered.size());

		List<Account> remaining = (List<Account>) c.remove(Fn.Match.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok')).asList();
		System.assertEquals(4, remaining.size());
	}

	@IsTest
	private static void testSameFieldExclusionCriteria() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok')).asList();
		System.assertEquals(0, filtered.size());

		List<Account> remaining = (List<Account>) c.remove(Fn.Match.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok')).asList();
		System.assertEquals(4, remaining.size());
	}

	@IsTest
	private static void testLongChaining() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).geq(100)).asList();
		System.assertEquals(1, filtered.size());

		List<Account> remaining = (List<Account>) c.remove(Fn.Match.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).geq(100)).asList();
		System.assertEquals(3, remaining.size());
	}

	@IsTest
	private static void testSameFieldSandwichCriteria() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60)).asList();
		System.assertEquals(1, filtered.size());

		List<Account> remaining = (List<Account>) c.remove(Fn.Match.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60)).asList();
		System.assertEquals(3, remaining.size());
	}

	@IsTest
	private static void testSameTokenSandwichCriteria() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60)).asList();
		System.assertEquals(1, filtered.size());

		List<Account> remaining = (List<Account>) c.remove(Fn.Match.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60)).asList();
		System.assertEquals(3, remaining.size());
	}

	@IsTest
	private static void testComparisonFilter() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Fn.Match.recordFields(new Account(AnnualRevenue = 150))).asList();
		System.assertEquals(2, filtered.size());
		for (Account acc : filtered) {
			System.assertEquals(150, acc.AnnualRevenue);
		}

		List<Account> remaining = (List<Account>) c.remove(Fn.Match.recordFields(new Account(AnnualRevenue = 150))).asList();
		System.assertEquals(2, remaining.size());
		for (Account acc : remaining) {
			System.assertNotEquals(150, acc.AnnualRevenue);
		}
	}

	@IsTest
	private static void testListTyping() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());
		List<sObject> filtered = c.filter(Fn.Match.field(Account.AnnualRevenue).lt(150)).asList(List<Account>.class);
		System.assert(filtered instanceof List<Account>);
		System.assert(!(filtered instanceof List<Opportunity>));

		List<sObject> filteredWithoutType = c.filter(Fn.Match.field(Account.AnnualRevenue).lt(150)).asList();
		// when no type is provided, the returned list is a list of sObjects which can be a list of anything!
		System.assert(filteredWithoutType instanceof List<Account>);
		System.assert(filteredWithoutType instanceof List<Opportunity>);

		List<sObject> remaining = c.remove(Fn.Match.field(Account.AnnualRevenue).lt(150)).asList(List<Account>.class);
		System.assert(remaining instanceof List<Account>);
		System.assert(!(remaining instanceof List<Opportunity>));

		List<sObject> remainingWithoutType = c.remove(Fn.Match.field(Account.AnnualRevenue).lt(150)).asList();
		// when no type is provided, the returned list is a list of sObjects which can be a list of anything!
		System.assert(remainingWithoutType instanceof List<Account>);
		System.assert(remainingWithoutType instanceof List<Opportunity>);
	}

	private class DoubleAmount implements SObjectToSObjectFunction {
		public SObject call(SObject record) {
			record.put('Amount', 2 * (Decimal) record.get('Amount'));
			return record;
		}
	}

	@IsTest
	private static void testMapAll() {
		List<Opportunity> opportunities = SObjectCollection.of(new List<Opportunity>{
			new Opportunity(Amount = 100),
			new Opportunity(Amount = 150)
		}).mapAll(new DoubleAmount()).asList();
		System.assertEquals(2, opportunities.size());
		System.assertEquals(200, opportunities[0].Amount);
		System.assertEquals(300, opportunities[1].Amount);
	}

	@IsTest
	private static void testMapSome() {
		List<Opportunity> opportunities = SObjectCollection.of(new List<Opportunity>{
			new Opportunity(Amount = 100),
			new Opportunity(Amount = 150)
		}).mapSome(Fn.Match.field('Amount').eq(100), new DoubleAmount()).asList();
		System.assertEquals(2, opportunities.size());
		System.assertEquals(200, opportunities[0].Amount);
		System.assertEquals(150, opportunities[1].Amount);
	}

	@IsTest
	private static void testForEachWithAssignTo() {
		List<Opportunity> opportunities = SObjectCollection.of(new List<Opportunity>{
			new Opportunity(Amount = 100),
			new Opportunity(Amount = 150)
		}).forEach(Fn.AssignTo.setFields(new Opportunity(Amount = 123))).asList();
		System.assertEquals(123, opportunities[0].Amount);
		System.assertEquals(123, opportunities[1].Amount);
	}

	@IsTest
	private static void testMapToDecimal() {
		List<Decimal> amounts = SObjectCollection.of(new List<Opportunity>{
			new Opportunity(Amount = 100),
			new Opportunity(Amount = 150)
		}).mapToDecimal(Opportunity.Amount).asList();

		System.assertEquals(100, amounts[0]);
		System.assertEquals(150, amounts[1]);
	}

	@IsTest
	private static void testMapToDouble() {
		List<Double> amounts = SObjectCollection.of(new List<Opportunity>{
			new Opportunity(Amount = 100),
			new Opportunity(Amount = 150)
		}).mapToDouble(Opportunity.Amount).asList();

		System.assertEquals(100, amounts[0]);
		System.assertEquals(150, amounts[1]);
	}

	@IsTest
	private static void testFind() {
		List<Account> accounts = new List<Account>{new Account(Name = 'Foo'), new Account(Name = 'Bar')};
		SObjectCollection accountCollection = SObjectCollection.of(accounts);
		OptionalSObject maybeFoo = accountCollection.find(Fn.Match.field(Account.Name).equals('Foo'));
		System.assert(maybeFoo.isPresent());
		System.assertEquals(accounts[0], maybeFoo.get());

		OptionalSObject maybeBaz = accountCollection.find(Fn.Match.field(Account.Name).equals('Baz'));
		System.assertEquals(false, maybeBaz.isPresent());
	}
}