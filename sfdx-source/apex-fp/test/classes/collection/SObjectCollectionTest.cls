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
	private static void collectionCanBeInstantiatedFromAList() {
		SObjectCollection c = SObjectCollection.of(new List<Account>{new Account(Name = 'Foo'), new Account(Name = 'Bar')});
	}

	@IsTest
	private static void sizeReturnsTheNumberOfRecordsInACollection() {
		SObjectCollection c = SObjectCollection.of(new List<Account>{new Account(Name = 'Foo'), new Account(Name = 'Bar')});
		System.Assert.areEqual(2, c.size(), 'Size should be 2');

		c = SObjectCollection.of(new List<Account>());
		System.Assert.areEqual(0, c.size(), 'Size should be 0');
	}

	@IsTest
	private static void pluckIdsWithRelationReturnsIds() {
		Account fooAccount = new Account(Id = TestUtility.getFakeId(Account.SObjectType));
		Account barAccount = new Account(Id = TestUtility.getFakeId(Account.SObjectType));
		List<Opportunity> opportunities = new List<Opportunity>{
			new Opportunity(
				Name = 'Foo',
				Account = fooAccount
			),
			new Opportunity(
				Name = 'Bar',
				Account = barAccount
			)
		};
		SObjectCollection c = SObjectCollection.of(opportunities);
		List<Id> accountIds = c.pluckIds('Account.Id');

		System.Assert.areEqual(2, accountIds.size());
		System.Assert.areEqual(fooAccount.Id, accountIds[0]);
		System.Assert.areEqual(barAccount.Id, accountIds[1]);
	}

	@IsTest
	private static void groupByDatesGroupsWithApiFieldName() {
		Date today = Date.today();
		SObjectCollection c = SObjectCollection.of(new List<Opportunity>{
			new Opportunity(
				CloseDate = today,
				Name = 'Today'
			),
			new Opportunity(
				CloseDate = today,
				Name = 'Today'
			),
			new Opportunity(
				CloseDate = today.addDays(1),
				Name = 'Tomorrow'
			)
		});
		Map<Date, List<Opportunity>> oppsByDate = c.groupByDates(Opportunity.CloseDate);
		System.Assert.areEqual(2, oppsByDate.size());
		List<Opportunity> todaysOpps = oppsByDate.get(today);
		System.Assert.areEqual(2, todaysOpps.size());
		for (Opportunity o : todaysOpps) {
			System.Assert.areEqual('Today', o.Name);
		}

		List<Opportunity> tomorrowsOpps = oppsByDate.get(today.addDays(1));
		System.Assert.areEqual(1, tomorrowsOpps.size());
		for (Opportunity o : tomorrowsOpps) {
			System.Assert.areEqual('Tomorrow', o.Name);
		}
	}

	@IsTest
	private static void testAsMap() {
		Map<Id, SObject> recordMap = SObjectCollection.of(testAccounts()).asMap();
		System.Assert.areEqual(4, recordMap.size());
	}

	@IsTest
	private static void testAsTypedMap() {
		List<Account> accounts = testAccounts();
		Map<Id, Account> accountMap = (Map<Id, Account>) SObjectCollection.of(accounts).asMap(Map<Id, Account>.class);
		System.Assert.areEqual(accounts[0], accountMap.get(accounts[0].Id));
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
		System.Assert.areEqual(1, diffList1.size());
		System.Assert.areEqual(accountId1, diffList1[0].Id);

		SObjectCollection diff2 = c1.difference(c2, new Set<Schema.SObjectField>{Account.Name});
		List<Account> diffList2 = diff2.asList();
		System.Assert.areEqual(1, diffList2.size());
		System.Assert.areEqual(accountId1, diffList2[0].Id);

		SObjectCollection diff3 = c1.difference(c2, new Set<Schema.SObjectField>{Account.Name, Account.Id});
		List<Account> diffList3 = diff3.asList();
		System.Assert.areEqual(1, diffList3.size());
		System.Assert.areEqual(accountId1, diffList3[0].Id);

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
		System.Assert.areEqual(1, diffList4.size());
		System.Assert.areEqual(accountId2, diffList4[0].Id);
	}

	@IsTest
	private static void testPluckDecimals() {
		List<Decimal> revenues = SObjectCollection.of(testAccounts()).pluckDecimals(Account.AnnualRevenue);
		System.Assert.areEqual(4, revenues.size());
		System.Assert.areEqual(100.0, revenues[0]);
		System.Assert.areEqual(60.0, revenues[1]);
		System.Assert.areEqual(150.0, revenues[2]);
		System.Assert.areEqual(150.0, revenues[3]);
	}

	@IsTest
	private static void testPluckStrings() {
		List<String> names = SObjectCollection.of(testAccounts()).pluckStrings(Account.Name);
		System.Assert.areEqual(4, names.size());
		System.Assert.areEqual('Foo', names[0]);
		System.Assert.areEqual('Bar', names[1]);
		System.Assert.areEqual('Foo', names[2]);
		System.Assert.areEqual('Bar', names[3]);
	}

	@IsTest
	private static void testPluckIdsAsStrings() {
		List<String> ownerIds = SObjectCollection.of(testAccounts()).pluckStrings(Account.OwnerId);
		System.Assert.areEqual(4, ownerIds.size());
		System.Assert.areEqual(firstUserId, ownerIds[0]);
		System.Assert.areEqual(firstUserId, ownerIds[1]);
		System.Assert.areEqual(secondUserId, ownerIds[2]);
		System.Assert.areEqual(secondUserId, ownerIds[3]);
	}

	@IsTest
	private static void testPluckIds() {
		List<Id> ownerIds = SObjectCollection.of(testAccounts()).pluckIds(Account.OwnerId);
		// workaround for List.contains bug
		Set<Id> idSet = new Set<Id>(ownerIds);
		System.Assert.areEqual(2, idSet.size());
		System.Assert.isTrue(idSet.contains(firstUserId));
		System.Assert.isTrue(idSet.contains(secondUserId));
	}

	@IsTest
	private static void testPluckRecordIds() {
		List<Account> accounts = testAccounts();
		List<Id> recordIds = SObjectCollection.of(accounts).pluckIds();
		System.Assert.areEqual(4, recordIds.size());
		// workaround for List.contains bug
		Set<Id> idSet = new Set<Id>(recordIds);
		System.Assert.isTrue(idSet.contains(accounts[0].Id));
		System.Assert.isTrue(idSet.contains(accounts[1].Id));
		System.Assert.isTrue(idSet.contains(accounts[2].Id));
		System.Assert.isTrue(idSet.contains(accounts[3].Id));
	}

	@IsTest
	private static void testPluckBooleans() {
		List<User> users = new List<User>{
			new User(Title = 'Foo', IsActive = true),
			new User(Title = 'Bar', IsActive = true),
			new User(Title = 'Baz', IsActive = false)
		};
		List<Boolean> active = SObjectCollection.of(users).pluckBooleans(User.IsActive);
		System.Assert.areEqual(3, active.size());
		System.Assert.isTrue(active[0]);
		System.Assert.isTrue(active[1]);
		System.Assert.isFalse(active[2]);
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
		System.Assert.areEqual(2, filtered.size());

		for (Account a : filtered) {
			System.Assert.areEqual(150, a.AnnualRevenue);
		}
	}

	@IsTest
	private static void testGroupByStrings() {
		SObjectCollection c = SObjectCollection.of(testAccounts());
		Map<String, List<Account>> accountsByName = c.groupByStrings(Account.Name);
		System.Assert.areEqual(2, accountsByName.size());
		System.Assert.isTrue(accountsByName.keySet().contains('Foo'));
		System.Assert.isTrue(accountsByName.keySet().contains('Bar'));
		System.Assert.areEqual(2, accountsByName.get('Foo').size());
		System.Assert.areEqual(2, accountsByName.get('Bar').size());
		for (Account a : accountsByName.get('Foo')) {
			System.Assert.areEqual('Foo', a.Name);
		}
		for (Account a : accountsByName.get('Bar')) {
			System.Assert.areEqual('Bar', a.Name);
		}
	}

	@IsTest
	private static void testGroupByStringsApiFieldName() {
		SObjectCollection c = SObjectCollection.of(testAccounts());
		Map<String, List<Account>> accountsByName = c.groupByStrings('Name');
		System.Assert.areEqual(2, accountsByName.size());
		System.Assert.isTrue(accountsByName.keySet().contains('Foo'));
		System.Assert.isTrue(accountsByName.keySet().contains('Bar'));
		System.Assert.areEqual(2, accountsByName.get('Foo').size());
		System.Assert.areEqual(2, accountsByName.get('Bar').size());
		for (Account a : accountsByName.get('Foo')) {
			System.Assert.areEqual('Foo', a.Name);
		}
		for (Account a : accountsByName.get('Bar')) {
			System.Assert.areEqual('Bar', a.Name);
		}
	}

	@IsTest
	private static void testGroupByStringTyping() {
		SObjectCollection c = SObjectCollection.of(testAccounts());
		Map<String, List<Account>> accountsByName = c.groupByStrings(Account.Name);
		List<Account> fooAccounts = accountsByName.get('Foo');
		List<SObject> objects = fooAccounts;
		// since fooAccounts points to a returned list of SObjects, it can be anything!
		System.Assert.isInstanceOfType(objects, List<Opportunity>.class);

		accountsByName = c.groupBystrings(Account.Name, List<Account>.class);
		fooAccounts = accountsByName.get('Foo');
		objects = fooAccounts;
		// this time around, it works fine!
		System.Assert.isNotInstanceOfType(objects, List<Opportunity>.class);
		System.Assert.isInstanceOfType(objects, List<Account>.class);
	}

	@IsTest
	private static void testGroupByStringTypingApiFieldName() {
		SObjectCollection c = SObjectCollection.of(testAccounts());
		Map<String, List<Account>> accountsByName = c.groupByStrings('Name');
		List<Account> fooAccounts = accountsByName.get('Foo');
		List<SObject> objects = fooAccounts;
		// since fooAccounts points to a returned list of SObjects, it can be anything!
		System.Assert.isInstanceOfType(objects, List<Opportunity>.class);

		accountsByName = c.groupBystrings(Account.Name, List<Account>.class);
		fooAccounts = accountsByName.get('Foo');
		objects = fooAccounts;
		// this time around, it works fine!
		System.Assert.isNotInstanceOfType(objects, List<Opportunity>.class);
		System.Assert.isInstanceOfType(objects, List<Account>.class);
	}

	@IsTest
	private static void testGroupByDecimals() {
		SObjectCollection c = SObjectCollection.of(testAccounts());
		Map<Decimal, List<Account>> accountsByRevenue = c.groupByDecimals(Account.AnnualRevenue);
		System.Assert.areEqual(3, accountsByRevenue.size());
		System.Assert.isTrue(accountsByRevenue.keySet().contains(60));
		System.Assert.isTrue(accountsByRevenue.keySet().contains(100));
		System.Assert.isTrue(accountsByRevenue.keySet().contains(150));
		System.Assert.areEqual(1, accountsByRevenue.get(60).size());
		System.Assert.areEqual(1, accountsByRevenue.get(100).size());
		System.Assert.areEqual(2, accountsByRevenue.get(150).size());
		for (Account a : accountsByRevenue.get(150)) {
			System.Assert.areEqual(150.0, a.AnnualRevenue);
		}
	}

	@IsTest
	private static void testGroupByDecimalsApiFieldName() {
		SObjectCollection c = SObjectCollection.of(testAccounts());
		Map<Decimal, List<Account>> accountsByRevenue = c.groupByDecimals('AnnualRevenue');
		System.Assert.areEqual(3, accountsByRevenue.size());
		System.Assert.isTrue(accountsByRevenue.keySet().contains(60));
		System.Assert.isTrue(accountsByRevenue.keySet().contains(100));
		System.Assert.isTrue(accountsByRevenue.keySet().contains(150));
		System.Assert.areEqual(1, accountsByRevenue.get(60).size());
		System.Assert.areEqual(1, accountsByRevenue.get(100).size());
		System.Assert.areEqual(2, accountsByRevenue.get(150).size());
		for (Account a : accountsByRevenue.get(150)) {
			System.Assert.areEqual(150.0, a.AnnualRevenue);
		}
	}

	@IsTest
	private static void testGroupByIds() {
		SObjectCollection c = SObjectCollection.of(testAccounts());
		Map<Id, List<Account>> accountsByOwners = c.groupByIds(Account.OwnerId);
		System.Assert.areEqual(2, accountsByOwners.size());
		System.Assert.isTrue(accountsByOwners.keySet().contains(firstUserId));
		System.Assert.isTrue(accountsByOwners.keySet().contains(secondUserId));
		System.Assert.areEqual(2, accountsByOwners.get(firstUserId).size());
		System.Assert.areEqual(2, accountsByOwners.get(secondUserId).size());
		for (Account a : accountsByOwners.get(firstUserId)) {
			System.Assert.areEqual(firstUserId, a.OwnerId);
		}
	}

	@IsTest
	private static void testGroupByIdsApiFieldName() {
		SObjectCollection c = SObjectCollection.of(testAccounts());
		Map<Id, List<Account>> accountsByOwners = c.groupByIds('OwnerId');
		System.Assert.areEqual(2, accountsByOwners.size());
		System.Assert.isTrue(accountsByOwners.keySet().contains(firstUserId));
		System.Assert.isTrue(accountsByOwners.keySet().contains(secondUserId));
		System.Assert.areEqual(2, accountsByOwners.get(firstUserId).size());
		System.Assert.areEqual(2, accountsByOwners.get(secondUserId).size());
		for (Account a : accountsByOwners.get(firstUserId)) {
			System.Assert.areEqual(firstUserId, a.OwnerId);
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
		System.Assert.areEqual(2, usersByActive.size());
		System.Assert.isTrue(usersByActive.keySet().contains(true));
		System.Assert.isTrue(usersByActive.keySet().contains(false));
		System.Assert.areEqual(2, usersByActive.get(true).size());
		System.Assert.areEqual(1, usersByActive.get(false).size());
		for (User u : usersByActive.get(true)) {
			System.Assert.isTrue(u.IsActive);
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
		System.Assert.areEqual(2, usersByActive.size());
		System.Assert.isTrue(usersByActive.keySet().contains(true));
		System.Assert.isTrue(usersByActive.keySet().contains(false));
		System.Assert.areEqual(2, usersByActive.get(true).size());
		System.Assert.areEqual(1, usersByActive.get(false).size());
		for (User u : usersByActive.get(true)) {
			System.Assert.isTrue(u.IsActive);
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
		System.Assert.areEqual(1, picked.size());
		for (Opportunity opp : picked) {
			System.Assert.areEqual('Test', opp.Name);
			System.Assert.areEqual(100, opp.Amount);
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
		System.Assert.areEqual(Account.sObjectType, picked[0].getSObjectType(), 'First picked element should be an Account.');
		System.Assert.areEqual(Opportunity.sObjectType, picked[1].getSObjectType(), 'Second picked element should be an Opportunity.');
	}

	private static void verifyNamePick(SObjectCollection picked) {
		for (SObject obj : picked.asList()) {
			Map<String, Object> fields = obj.getPopulatedFieldsAsMap();
			System.Assert.areEqual(1, fields.size());
			System.Assert.isTrue(fields.containsKey('Name'));
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
		System.Assert.areEqual(1, filtered.size());
		System.Assert.areEqual('First', filtered[0].Name);
	}

	@IsTest
	private static void testHasValue() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());
		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.BillingCountry).hasValue()).asList();
		System.Assert.areEqual(0, filtered.size());

		filtered = (List<Account>) c.filter(Fn.Match.field(Account.Name).hasValue()).asList();
		System.Assert.areEqual(4, filtered.size());

	}

	@IsTest
	private static void testIsIn() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());
		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.AnnualRevenue).isIn(new Set<Decimal>{60, 150})).asList();
		System.Assert.areEqual(3, filtered.size());
		for (Account acc : filtered) {
			System.Assert.isTrue(acc.AnnualRevenue == 60 || acc.AnnualRevenue == 150);
		}
	}

	@IsTest
	private static void testIsNotIn() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());
		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.AnnualRevenue).notIn(new Set<Decimal>{60})).asList();
		System.Assert.areEqual(3, filtered.size());
		for (Account acc : filtered) {
			System.Assert.isTrue(acc.AnnualRevenue == 100 || acc.AnnualRevenue == 150);
		}
	}

	@IsTest
	private static void testUnsupportedFilteringType() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());

		try {
			List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.Name).equals(TimeZone.getTimeZone('CET'))).asList();
			System.Assert.fail();
		} catch (LambdaException e) {
			System.Assert.isTrue(e.getMessage().contains('not supported'));
		}
	}

	@IsTest
	private static void testFieldEqualsOkFilter() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.Name).equals('Ok')).asList();

		System.Assert.areEqual(2, filtered.size());
		for (Account acc : filtered) {
			System.Assert.areEqual('Ok', acc.Name);
		}

		List<Account> remaining = (List<Account>) c.remove(Fn.Match.field(Account.Name).equals('Ok')).asList();

		System.Assert.areEqual(2, remaining.size());
		for (Account acc : remaining) {
			System.Assert.areEqual('Wrong', acc.Name);
		}
	}

	@IsTest
	private static void testMultipleFieldFilter() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());
		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).gt(100)).asList();

		System.Assert.areEqual(1, filtered.size());
		for (Account acc : filtered) {
			System.Assert.areEqual('Ok', acc.Name);
			System.Assert.isTrue(acc.AnnualRevenue > 100);
		}

		List<Account> remaining = (List<Account>) c.remove(Fn.Match.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).gt(100)).asList();

		System.Assert.areEqual(3, remaining.size());
		for (Account acc : remaining) {
			System.Assert.isTrue(acc.AnnualRevenue <= 100 || acc.Name != 'Ok');
		}
	}

	@IsTest
	private static void testSameFieldTokenExclusionCriteria() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok')).asList();
		System.Assert.areEqual(0, filtered.size());

		List<Account> remaining = (List<Account>) c.remove(Fn.Match.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok')).asList();
		System.Assert.areEqual(4, remaining.size());
	}

	@IsTest
	private static void testSameFieldExclusionCriteria() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok')).asList();
		System.Assert.areEqual(0, filtered.size());

		List<Account> remaining = (List<Account>) c.remove(Fn.Match.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok')).asList();
		System.Assert.areEqual(4, remaining.size());
	}

	@IsTest
	private static void testLongChaining() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).geq(100)).asList();
		System.Assert.areEqual(1, filtered.size());

		List<Account> remaining = (List<Account>) c.remove(Fn.Match.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).geq(100)).asList();
		System.Assert.areEqual(3, remaining.size());
	}

	@IsTest
	private static void testSameFieldSandwichCriteria() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60)).asList();
		System.Assert.areEqual(1, filtered.size());

		List<Account> remaining = (List<Account>) c.remove(Fn.Match.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60)).asList();
		System.Assert.areEqual(3, remaining.size());
	}

	@IsTest
	private static void testSameTokenSandwichCriteria() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Fn.Match.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60)).asList();
		System.Assert.areEqual(1, filtered.size());

		List<Account> remaining = (List<Account>) c.remove(Fn.Match.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60)).asList();
		System.Assert.areEqual(3, remaining.size());
	}

	@IsTest
	private static void testComparisonFilter() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Fn.Match.recordFields(new Account(AnnualRevenue = 150))).asList();
		System.Assert.areEqual(2, filtered.size());
		for (Account acc : filtered) {
			System.Assert.areEqual(150, acc.AnnualRevenue);
		}

		List<Account> remaining = (List<Account>) c.remove(Fn.Match.recordFields(new Account(AnnualRevenue = 150))).asList();
		System.Assert.areEqual(2, remaining.size());
		for (Account acc : remaining) {
			System.Assert.areNotEqual(150, acc.AnnualRevenue);
		}
	}

	@IsTest
	private static void testListTyping() {
		SObjectCollection c = SObjectCollection.of(testFilterAccounts());
		List<sObject> filtered = c.filter(Fn.Match.field(Account.AnnualRevenue).lt(150)).asList(List<Account>.class);
		System.Assert.isInstanceOfType(filtered, List<Account>.class);
		System.Assert.isNotInstanceOfType(filtered, List<Opportunity>.class);

		List<sObject> filteredWithoutType = c.filter(Fn.Match.field(Account.AnnualRevenue).lt(150)).asList();
		// when no type is provided, the returned list is a list of sObjects which can be a list of anything!
		System.Assert.isInstanceOfType(filteredWithoutType, List<Account>.class);
		System.Assert.isInstanceOfType(filteredWithoutType, List<Opportunity>.class);

		List<sObject> remaining = c.remove(Fn.Match.field(Account.AnnualRevenue).lt(150)).asList(List<Account>.class);
		System.Assert.isInstanceOfType(remaining, List<Account>.class);
		System.Assert.isNotInstanceOfType(remaining, List<Opportunity>.class);

		List<sObject> remainingWithoutType = c.remove(Fn.Match.field(Account.AnnualRevenue).lt(150)).asList();
		// when no type is provided, the returned list is a list of sObjects which can be a list of anything!
		System.Assert.isInstanceOfType(remainingWithoutType, List<Account>.class);
		System.Assert.isInstanceOfType(remainingWithoutType, List<Opportunity>.class);
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
		System.Assert.areEqual(2, opportunities.size());
		System.Assert.areEqual(200, opportunities[0].Amount);
		System.Assert.areEqual(300, opportunities[1].Amount);
	}

	@IsTest
	private static void testMapSome() {
		List<Opportunity> opportunities = SObjectCollection.of(new List<Opportunity>{
			new Opportunity(Amount = 100),
			new Opportunity(Amount = 150)
		}).mapSome(Fn.Match.field('Amount').eq(100), new DoubleAmount()).asList();
		System.Assert.areEqual(2, opportunities.size());
		System.Assert.areEqual(200, opportunities[0].Amount);
		System.Assert.areEqual(150, opportunities[1].Amount);
	}

	@IsTest
	private static void testForEachWithModify() {
		List<Opportunity> opportunities = SObjectCollection.of(new List<Opportunity>{
			new Opportunity(Amount = 100),
			new Opportunity(Amount = 150)
		}).forEach(Fn.Modify.setFields(new Opportunity(Amount = 123))).asList();
		System.Assert.areEqual(123, opportunities[0].Amount);
		System.Assert.areEqual(123, opportunities[1].Amount);
	}

	@IsTest
	private static void testMapToDecimal() {
		List<Decimal> amounts = SObjectCollection.of(new List<Opportunity>{
			new Opportunity(Amount = 100),
			new Opportunity(Amount = 150)
		}).mapToDecimal(Opportunity.Amount).asList();

		System.Assert.areEqual(100, amounts[0]);
		System.Assert.areEqual(150, amounts[1]);
	}

	@IsTest
	private static void testMapToDouble() {
		List<Double> amounts = SObjectCollection.of(new List<Opportunity>{
			new Opportunity(Amount = 100),
			new Opportunity(Amount = 150)
		}).mapToDouble(Opportunity.Amount).asList();

		System.Assert.areEqual(100, amounts[0]);
		System.Assert.areEqual(150, amounts[1]);
	}

	@IsTest
	private static void testFind() {
		List<Account> accounts = new List<Account>{new Account(Name = 'Foo'), new Account(Name = 'Bar')};
		SObjectCollection accountCollection = SObjectCollection.of(accounts);
		OptionalSObject maybeFoo = accountCollection.find(Fn.Match.field(Account.Name).equals('Foo'));
		System.Assert.isTrue(maybeFoo.isPresent());
		System.Assert.areEqual(accounts[0], maybeFoo.get());

		OptionalSObject maybeBaz = accountCollection.find(Fn.Match.field(Account.Name).equals('Baz'));
		System.Assert.isFalse(maybeBaz.isPresent());
	}

	private class MappingTarget {
		public String name;
	}

	@IsTest
	private static void testMapAllToObjects() {
		List<MappingTarget> result = (List<MappingTarget>) SObjectCollection.of(new List<Account>{new Account(Name = 'foo'), new Account(Name = 'bar')})
			.mapAll(
				Fn.MapTo(MappingTarget.class).mapField('name', Account.Name)
			)
			.asList(List<MappingTarget>.class);

		System.Assert.areEqual(2, result.size());
		System.Assert.areEqual('foo', result[0].name);
		System.Assert.areEqual('bar', result[1].name);
	}
}