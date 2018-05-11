@IsTest
private class GroupByTest {
	static Id firstUserId = TestUtility.getTestId(User.SObjectType);
	static Id secondUserId = TestUtility.getTestId(User.SObjectType);

	static List<Account> testData() {
		List<Account> accounts = new List<Account>();
		accounts.add(new Account(OwnerId = firstUserId, Name = 'Foo', AnnualRevenue = 100));
		accounts.add(new Account(OwnerId = firstUserId, Name = 'Bar', AnnualRevenue = 60));
		accounts.add(new Account(OwnerId = firstUserId, Name = 'Foo', AnnualRevenue = 150));
		accounts.add(new Account(OwnerId = secondUserId, Name = 'Bar', AnnualRevenue = 150));
		return accounts;
	}

	@IsTest
	public static void testGroupByStrings() {
		List<Account> accounts = testData();
		Map<String, List<Account>> accountsByName = GroupBy.strings(Account.Name, accounts);
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
		List<Account> accounts = testData();
		Map<String, List<Account>> accountsByName = GroupBy.strings(Account.Name, accounts);
		List<Account> fooAccounts = accountsByName.get('Foo');
		List<SObject> objects = fooAccounts;
		// since fooAccounts points to a returned list of SObjects, it can be anything!
		System.assert(objects instanceof List<Opportunity>);

		accountsByName = GroupBy.strings(Account.Name, accounts, List<Account>.class);
		fooAccounts = accountsByName.get('Foo');
		objects = fooAccounts;
		// this time around, it works fine!
		System.assert(!(objects instanceof List<Opportunity>));
		System.assert(objects instanceof List<Account>);
	}

	@IsTest
	public static void testGroupByDecimals() {
		List<Account> accounts = testData();
		Map<Decimal, List<Account>> accountsByRevenue = GroupBy.decimals(Account.AnnualRevenue, accounts);
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
		List<Account> accounts = testData();
		Map<Id, List<Account>> accountsByOwners = GroupBy.ids(Account.OwnerId, accounts);
		System.assertEquals(2, accountsByOwners.size());
		System.assert(accountsByOwners.keySet().contains(firstUserId));
		System.assert(accountsByOwners.keySet().contains(secondUserId));
		System.assertEquals(3, accountsByOwners.get(firstUserId).size());
		System.assertEquals(1, accountsByOwners.get(secondUserId).size());
		for (Account a : accountsByOwners.get(firstUserId)) {
			System.assertEquals(firstUserId, a.OwnerId);
		}
	}

	@IsTest
	public static void testGroupByBooleans() {
		List<User> users = new List<User>{
			new User(Title = 'Foo', IsActive = true),
			new User(Title = 'Bar', IsActive = true),
			new User(Title = 'Baz', IsActive = false)
		};
		Map<Boolean, List<User>> usersByActive = GroupBy.booleans(User.IsActive, users);
		System.assertEquals(2, usersByActive.size());
		System.assert(usersByActive.keySet().contains(true));
		System.assert(usersByActive.keySet().contains(false));
		System.assertEquals(2, usersByActive.get(true).size());
		System.assertEquals(1, usersByActive.get(false).size());
		for (User u : usersByActive.get(true)) {
			System.assertEquals(true, u.IsActive);
		}
	}
}
