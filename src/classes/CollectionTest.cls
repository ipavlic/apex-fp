@IsTest
public class CollectionTest {

	static Id firstUserId = TestUtility.getTestId(User.SObjectType);
	static Id secondUserId = TestUtility.getTestId(User.SObjectType);

	static List<Account> testAccounts() {
		return new List<Account>{
			new Account(Id = TestUtility.getTestId(Account.SObjectType), OwnerId = firstUserId, Name = 'Foo', AnnualRevenue = 100),
			new Account(Id = TestUtility.getTestId(Account.SObjectType), OwnerId = firstUserId, Name = 'Bar', AnnualRevenue = 60),
			new Account(Id = TestUtility.getTestId(Account.SObjectType), OwnerId = secondUserId, Name = 'Foo', AnnualRevenue = 150),
			new Account(Id = TestUtility.getTestId(Account.SObjectType), OwnerId = secondUserId, Name = 'Bar', AnnualRevenue = 150)
		};
	}

	@IsTest
	public static void testAsMap() {
		Map<Id, SObject> recordMap = Collection.of(testAccounts()).asMap();
		System.assertEquals(4, recordMap.size());
	}

	@IsTest
	public static void testAsTypedMap() {
		List<Account> accounts = testAccounts();
		Map<Id, Account> accountMap = (Map<Id, Account>) Collection.of(accounts).asMap(Map<Id, Account>.class);
		System.assertEquals(accounts[0], accountMap.get(accounts[0].Id));
	}

	@IsTest
	public static void testDifference() {
		Id accountId1 = TestUtility.getTestId(Account.SObjectType);
		Id accountId2 = TestUtility.getTestId(Account.SObjectType);
		Id accountId3 = TestUtility.getTestId(Account.SObjectType);

		Collection c1 = Collection.of(new List<Account>{
			new Account(Id = accountId1, Name = 'Foo')
		});

		Collection c2 = Collection.of(new List<Account>{
			new Account(Id = accountId1, Name = 'Bar')
		});

		Collection diff1 = c1.difference(c2, new Set<Schema.SObjectField>{Account.Name});
		List<Account> diffList1 = diff1.asList();
		System.assertEquals(1, diffList1.size());
		System.assertEquals(accountId1, diffList1[0].Id);

		Collection diff2 = c1.difference(c2, new Set<Schema.SObjectField>{Account.Name});
		List<Account> diffList2 = diff2.asList();
		System.assertEquals(1, diffList2.size());
		System.assertEquals(accountId1, diffList2[0].Id);

		Collection diff3 = c1.difference(c2, new Set<Schema.SObjectField>{Account.Name, Account.Id});
		List<Account> diffList3 = diff3.asList();
		System.assertEquals(1, diffList3.size());
		System.assertEquals(accountId1, diffList3[0].Id);

		Collection c3 = Collection.of(new List<Account>{
			new Account(Id = accountId1, Name = 'Foo'),
			new Account(Id = accountId2, Name = 'Bar'),
			new Account(Id = accountId3, Name = 'Baz')
		});

		Collection c4 = Collection.of(new List<Account>{
			new Account(Id = accountId1, Name = 'Foo'),
			new Account(Id = accountId3, Name = 'Baz')
		});

		Collection diff4 = c3.difference(c4, new Set<Schema.SObjectField>{Account.Name, Account.Id});
		List<Account> diffList4 = diff4.asList();
		System.assertEquals(1, diffList4.size());
		System.assertEquals(accountId2, diffList4[0].Id);
	}

	@IsTest
	public static void testPluckDecimals() {
		List<Decimal> revenues = Collection.of(testAccounts()).pluckDecimals(Account.AnnualRevenue);
		System.assertEquals(4, revenues.size());
		System.assertEquals(100.0, revenues[0]);
		System.assertEquals(60.0, revenues[1]);
		System.assertEquals(150.0, revenues[2]);
		System.assertEquals(150.0, revenues[3]);
	}

	@IsTest
	public static void testPluckStrings() {
		List<String> names = Collection.of(testAccounts()).pluckStrings(Account.Name);
		System.assertEquals(4, names.size());
		System.assertEquals('Foo', names[0]);
		System.assertEquals('Bar', names[1]);
		System.assertEquals('Foo', names[2]);
		System.assertEquals('Bar', names[3]);
	}

	@IsTest
	public static void testPluckIdsAsStrings() {
		List<String> ownerIds = Collection.of(testAccounts()).pluckStrings(Account.OwnerId);
		System.assertEquals(4, ownerIds.size());
		System.assertEquals(firstUserId, ownerIds[0]);
		System.assertEquals(firstUserId, ownerIds[1]);
		System.assertEquals(secondUserId, ownerIds[2]);
		System.assertEquals(secondUserId, ownerIds[3]);
	}

	@IsTest
	public static void testPluckIds() {
		List<Id> ownerIds = Collection.of(testAccounts()).pluckIds(Account.OwnerId);
		// workaround for List.contains bug
		Set<Id> idSet = new Set<Id>(ownerIds);
		System.assertEquals(2, idSet.size());
		System.assert(idSet.contains(firstUserId));
		System.assert(idSet.contains(secondUserId));
	}

	@IsTest
	public static void testPluckRecordIds() {
		List<Account> accounts = testAccounts();
		List<Id> recordIds = Collection.of(accounts).pluckIds();
		System.assertEquals(4, recordIds.size());
		// workaround for List.contains bug
		Set<Id> idSet = new Set<Id>(recordIds);
		System.assert(idSet.contains(accounts[0].Id));
		System.assert(idSet.contains(accounts[1].Id));
		System.assert(idSet.contains(accounts[2].Id));
		System.assert(idSet.contains(accounts[3].Id));
	}

	@IsTest
	public static void testPluckBooleans() {
		List<User> users = new List<User>{
			new User(Title = 'Foo', IsActive = true),
			new User(Title = 'Bar', IsActive = true),
			new User(Title = 'Baz', IsActive = false)
		};
		List<Boolean> active = Collection.of(users).pluckBooleans(User.IsActive);
		System.assertEquals(3, active.size());
		System.assertEquals(true, active[0]);
		System.assertEquals(true, active[1]);
		System.assertEquals(false, active[2]);
	}

	@IsTest
	public static void testFieldsMatchFilter() {
		Collection c = Collection.of(new List<Account>{
			new Account(Id = TestUtility.getTestId(Account.SObjectType), OwnerId = firstUserId, Name = 'Foo', AnnualRevenue = 100),
			new Account(Id = TestUtility.getTestId(Account.SObjectType), OwnerId = firstUserId, Name = 'Bar', AnnualRevenue = 60),
			new Account(Id = TestUtility.getTestId(Account.SObjectType), OwnerId = secondUserId, Name = 'Foo', AnnualRevenue = 150),
			new Account(Id = TestUtility.getTestId(Account.SObjectType), OwnerId = secondUserId, Name = 'Bar', AnnualRevenue = 150)
		});

		List<Account> filtered = c.filter(Match.field(Account.AnnualRevenue).eq(150)).asList();
		System.assertEquals(2, filtered.size());

		for (Account a : filtered) {
			System.assertEquals(150, a.AnnualRevenue);
		}
	}

	@IsTest
	public static void testGroupByStrings() {
		Collection c = Collection.of(testAccounts());
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
	public static void testGroupByStringsApiFieldName() {
		Collection c = Collection.of(testAccounts());
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
	public static void testGroupByStringTyping() {
		Collection c = Collection.of(testAccounts());
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
	public static void testGroupByStringTypingApiFieldName() {
		Collection c = Collection.of(testAccounts());
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
	public static void testGroupByDecimals() {
		Collection c = Collection.of(testAccounts());
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
	public static void testGroupByDecimalsApiFieldName() {
		Collection c = Collection.of(testAccounts());
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
	public static void testGroupByIds() {
		Collection c = Collection.of(testAccounts());
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
	public static void testGroupByIdsApiFieldName() {
		Collection c = Collection.of(testAccounts());
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
	public static void testGroupByBooleans() {
		Collection c = Collection.of(new List<User>{
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
	public static void testGroupByBooleansApiFieldName() {
		Collection c = Collection.of(new List<User>{
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
	public static void pickShouldPickFields() {
		Collection c = Collection.of(new List<Account>{
			new Account(Name = 'Test1', AnnualRevenue = 100),
			new Account(Name = 'Test2', AnnualRevenue = 200)
		});
		verifyNamePick(c.pick(new List<Schema.SObjectField>{Account.Name}));
		verifyNamePick(c.pick(new Set<Schema.SObjectField>{Account.Name}));
		verifyNamePick(c.pick(new List<String>{'Name'}));
		verifyNamePick(c.pick(new Set<String>{'Name'}));
	}

	@IsTest
	public static void pickedFieldsShouldHaveValues() {
		Collection c = Collection.of(new List<Opportunity>{
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
	public static void pickShouldPickHeterogenousRecords() {
		Collection c = Collection.of(new List<SObject>{
			new Account(Name = 'Test1', AnnualRevenue = 100),
			new Opportunity(Name = 'Test1', Description = 'Test description')
		});
		verifyNamePick(c.pick(new List<String>{'Name'}));
		verifyNamePick(c.pick(new Set<String>{'Name'}));
	}

	@IsTest
	public static void pickShouldHaveMatchingObjectTypes() {
		Collection c = Collection.of(new List<SObject>{
			new Account(Name = 'Test1', AnnualRevenue = 100),
			new Opportunity(Name = 'Test1', Description = 'Test description')
		});
		List<SObject> picked = c.pick(new List<String>{'Name'}).asList();
		System.assertEquals(Account.sObjectType, picked[0].getSObjectType(), 'First picked element should be an Account.');
		System.assertEquals(Opportunity.sObjectType, picked[1].getSObjectType(), 'Second picked element should be an Opportunity.');
	}

	private static void verifyNamePick(Collection picked) {
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
	static void testRelationalFiltering() {
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
		Collection c = Collection.of(opps);
		List<Opportunity> filtered = (List<Opportunity>) c.filter(Match.field('Account.AnnualRevenue').greaterThan(70)).asList();
		System.assertEquals(1, filtered.size());
		System.assertEquals('First', filtered[0].Name);
	}

	@IsTest
	static void testHasValue() {
		Collection c = Collection.of(testFilterAccounts());
		List<Account> filtered = (List<Account>) c.filter(Match.field(Account.Industry).hasValue()).asList();
		System.assertEquals(0, filtered.size());

		filtered = (List<Account>) c.filter(Match.field(Account.Name).hasValue()).asList();
		System.assertEquals(4, filtered.size());

	}

	@IsTest
	static void testIsIn() {
		Collection c = Collection.of(testFilterAccounts());
		List<Account> filtered = (List<Account>) c.filter(Match.field(Account.AnnualRevenue).isIn(new Set<Decimal>{60, 150})).asList();
		System.assertEquals(3, filtered.size());
		for (Account acc : filtered) {
			System.assert(acc.AnnualRevenue == 60 || acc.AnnualRevenue == 150);
		}
	}

	@IsTest
	static void testIsNotIn() {
		Collection c = Collection.of(testFilterAccounts());
		List<Account> filtered = (List<Account>) c.filter(Match.field(Account.AnnualRevenue).notIn(new Set<Decimal>{60})).asList();
		System.assertEquals(3, filtered.size());
		for (Account acc : filtered) {
			System.assert(acc.AnnualRevenue == 100 || acc.AnnualRevenue == 150);
		}
	}

	@IsTest
	static void testFieldEqualsOkFilter() {
		Collection c = Collection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Match.field(Account.Name).equals('Ok')).asList();

		System.assertEquals(2, filtered.size());
		for (Account acc : filtered) {
			System.assertEquals('Ok', acc.Name);
		}

		List<Account> remaining = (List<Account>) c.remove(Match.field(Account.Name).equals('Ok')).asList();

		System.assertEquals(2, remaining.size());
		for (Account acc : remaining) {
			System.assertEquals('Wrong', acc.Name);
		}
	}

	@IsTest
	static void testMultipleFieldFilter() {
		Collection c = Collection.of(testFilterAccounts());
		List<Account> filtered = (List<Account>) c.filter(Match.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).gt(100)).asList();

		System.assertEquals(1, filtered.size());
		for (Account acc : filtered) {
			System.assertEquals('Ok', acc.Name);
			System.assert(acc.AnnualRevenue > 100);
		}

		List<Account> remaining = (List<Account>) c.remove(Match.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).gt(100)).asList();

		System.assertEquals(3, remaining.size());
		for (Account acc : remaining) {
			System.assert(acc.AnnualRevenue <= 100 || acc.Name != 'Ok');
		}
	}

	@IsTest
	static void testSameFieldTokenExclusionCriteria() {
		Collection c = Collection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Match.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok')).asList();
		System.assertEquals(0, filtered.size());

		List<Account> remaining = (List<Account>) c.remove(Match.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok')).asList();
		System.assertEquals(4, remaining.size());
	}

	@IsTest
	static void testSameFieldExclusionCriteria() {
		Collection c = Collection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Match.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok')).asList();
		System.assertEquals(0, filtered.size());

		List<Account> remaining = (List<Account>) c.remove(Match.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok')).asList();
		System.assertEquals(4, remaining.size());
	}

	@IsTest
	static void testLongChaining() {
		Collection c = Collection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Match.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).geq(100)).asList();
		System.assertEquals(1, filtered.size());

		List<Account> remaining = (List<Account>) c.remove(Match.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).geq(100)).asList();
		System.assertEquals(3, remaining.size());
	}

	@IsTest
	static void testSameFieldSandwichCriteria() {
		Collection c = Collection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Match.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60)).asList();
		System.assertEquals(1, filtered.size());

		List<Account> remaining = (List<Account>) c.remove(Match.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60)).asList();
		System.assertEquals(3, remaining.size());
	}

	@IsTest
	static void testSameTokenSandwichCriteria() {
		Collection c = Collection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Match.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60)).asList();
		System.assertEquals(1, filtered.size());

		List<Account> remaining = (List<Account>) c.remove(Match.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60)).asList();
		System.assertEquals(3, remaining.size());
	}

	@IsTest
	static void testComparisonFilter() {
		Collection c = Collection.of(testFilterAccounts());

		List<Account> filtered = (List<Account>) c.filter(Match.record(new Account(AnnualRevenue = 150))).asList();
		System.assertEquals(2, filtered.size());
		for (Account acc : filtered) {
			System.assertEquals(150, acc.AnnualRevenue);
		}

		List<Account> remaining = (List<Account>) c.remove(Match.record(new Account(AnnualRevenue = 150))).asList();
		System.assertEquals(2, remaining.size());
		for (Account acc : remaining) {
			System.assertNotEquals(150, acc.AnnualRevenue);
		}
	}

	@IsTest
	static void testListTyping() {
		Collection c = Collection.of(testFilterAccounts());
		List<sObject> filtered = c.filter(Match.field(Account.AnnualRevenue).lt(150)).asList(List<Account>.class);
		System.assert(filtered instanceof List<Account>);
		System.assert(!(filtered instanceof List<Opportunity>));

		List<sObject> filteredWithoutType = c.filter(Match.field(Account.AnnualRevenue).lt(150)).asList();
		// when no type is provided, the returned list is a list of sObjects which can be a list of anything!
		System.assert(filteredWithoutType instanceof List<Account>);
		System.assert(filteredWithoutType instanceof List<Opportunity>);

		List<sObject> remaining = c.remove(Match.field(Account.AnnualRevenue).lt(150)).asList(List<Account>.class);
		System.assert(remaining instanceof List<Account>);
		System.assert(!(remaining instanceof List<Opportunity>));

		List<sObject> remainingWithoutType = c.remove(Match.field(Account.AnnualRevenue).lt(150)).asList();
		// when no type is provided, the returned list is a list of sObjects which can be a list of anything!
		System.assert(remainingWithoutType instanceof List<Account>);
		System.assert(remainingWithoutType instanceof List<Opportunity>);
	}

	private class DoubleAmount implements SObjectToSObjectFunction {
		public SObject apply(SObject record) {
			record.put('Amount', 2 * (Decimal) record.get('Amount'));
			return record;
		}
	}

	@IsTest
	static void testMapAll() {
		List<Opportunity> opportunities = Collection.of(new List<Opportunity>{
			new Opportunity(Amount = 100),
			new Opportunity(Amount = 150)
		}).mapAll(new DoubleAmount()).asList();
		System.assertEquals(2, opportunities.size());
		System.assertEquals(200, opportunities[0].Amount);
		System.assertEquals(300, opportunities[1].Amount);
	}

	@IsTest
	static void testMapSome() {
		List<Opportunity> opportunities = Collection.of(new List<Opportunity>{
			new Opportunity(Amount = 100),
			new Opportunity(Amount = 150)
		}).mapSome(Match.field('Amount').eq(100), new DoubleAmount()).asList();
		System.assertEquals(2, opportunities.size());
		System.assertEquals(200, opportunities[0].Amount);
		System.assertEquals(150, opportunities[1].Amount);
	}

	@IsTest
	static void testMapWithCopyFields() {
		List<Opportunity> opportunities = Collection.of(new List<Opportunity>{
			new Opportunity(Amount = 100),
			new Opportunity(Amount = 150)
		}).mapAll(CopyFields.fromRecord(new Opportunity(Amount = 123))).asList();
		System.assertEquals(123, opportunities[0].Amount);
		System.assertEquals(123, opportunities[1].Amount);
	}

	@IsTest
	static void testMapToDecimal() {
		List<Decimal> amounts = Collection.of(new List<Opportunity>{
			new Opportunity(Amount = 100),
			new Opportunity(Amount = 150)
		}).mapToDecimal(Opportunity.Amount).asList();

		System.assertEquals(100, amounts[0]);
		System.assertEquals(150, amounts[1]);
	}

	@IsTest
	static void testMapToDouble() {
		List<Double> amounts = Collection.of(new List<Opportunity>{
			new Opportunity(Amount = 100),
			new Opportunity(Amount = 150)
		}).mapToDouble(Opportunity.Amount).asList();

		System.assertEquals(100, amounts[0]);
		System.assertEquals(150, amounts[1]);
	}
    
    @IsTest
	public static void testSortName() {
		List<Account> records = Collection.of(testAccounts()).asList();
        Collection.sort(records, Account.Name);

        system.assertEquals('Bar', records.get(0).Name);
        system.assertEquals('Bar', records.get(1).Name);
        system.assertEquals('Foo', records.get(2).Name);
        system.assertEquals('Foo', records.get(3).Name);
	}
    
    @IsTest
	public static void testSortRevenue() {
		List<Account> records = Collection.of(testAccounts()).asList();
        Collection.sort(records, Account.AnnualRevenue);

        system.assertEquals('Bar', records.get(0).Name);
        system.assertEquals('Foo', records.get(1).Name);
        system.assertEquals(60, records.get(0).AnnualRevenue);
        system.assertEquals(100, records.get(1).AnnualRevenue);
	}
}