@IsTest
private class PluckTest {
	static Id firstUserId = TestUtility.getTestId(User.SObjectType);
	static Id secondUserId = TestUtility.getTestId(User.SObjectType);

	static List<Account> testData() {
		List<Account> accounts = new List<Account>();
		accounts.add(new Account(Id = TestUtility.getTestId(Account.SObjectType), OwnerId = firstUserId, Name = 'Foo', AnnualRevenue = 100));
		accounts.add(new Account(Id = TestUtility.getTestId(Account.SObjectType), OwnerId = firstUserId, Name = 'Bar', AnnualRevenue = 60));
		accounts.add(new Account(Id = TestUtility.getTestId(Account.SObjectType), OwnerId = secondUserId, Name = 'Foo', AnnualRevenue = 150));
		accounts.add(new Account(Id = TestUtility.getTestId(Account.SObjectType), OwnerId = secondUserId, Name = 'Bar', AnnualRevenue = 150));
		return accounts;
	}

	@IsTest
	public static void testPluckDecimals() {
		List<Account> accounts = testData();
		List<Decimal> revenues = Pluck.decimals(Account.AnnualRevenue, accounts);
		System.assertEquals(4, revenues.size());
		System.assertEquals(100.0, revenues[0]);
		System.assertEquals(60.0, revenues[1]);
		System.assertEquals(150.0, revenues[2]);
		System.assertEquals(150.0, revenues[3]);
	}

	@IsTest
	public static void testPluckStrings() {
		List<Account> accounts = testData();
		List<String> names = Pluck.strings(Account.Name, accounts);
		System.assertEquals(4, names.size());
		System.assertEquals('Foo', names[0]);
		System.assertEquals('Bar', names[1]);
		System.assertEquals('Foo', names[2]);
		System.assertEquals('Bar', names[3]);
	}

	@IsTest
	public static void testPluckIdsAsStrings() {
		List<Account> accounts = testData();
		List<String> ownerIds = Pluck.strings(Account.OwnerId, accounts);
		System.assertEquals(4, ownerIds.size());
		System.assertEquals(firstUserId, ownerIds[0]);
		System.assertEquals(firstUserId, ownerIds[1]);
		System.assertEquals(secondUserId, ownerIds[2]);
		System.assertEquals(secondUserId, ownerIds[3]);
	}

	@IsTest
	public static void testPluckIds() {
		List<Account> accounts = testData();
		Set<Id> ownerIds = Pluck.ids(Account.OwnerId, accounts);
		System.assertEquals(2, ownerIds.size());
		System.assert(ownerIds.contains(firstUserId));
		System.assert(ownerIds.contains(secondUserId));
	}

	@IsTest
	public static void testPluckRecordIds() {
		List<Account> accounts = testData();
		Set<Id> recordIds = Pluck.ids(accounts);
		System.assertEquals(4, recordIds.size());
		System.assert(recordIds.contains(accounts[0].Id));
		System.assert(recordIds.contains(accounts[1].Id));
		System.assert(recordIds.contains(accounts[2].Id));
		System.assert(recordIds.contains(accounts[3].Id));
	}

	@IsTest
	public static void testPluckBooleans() {
		List<User> users = new List<User>{
			new User(Title = 'Foo', IsActive = true),
			new User(Title = 'Bar', IsActive = true),
			new User(Title = 'Baz', IsActive = false)
		};
		List<Boolean> activity = Pluck.booleans(User.IsActive, users);
		System.assertEquals(3, activity.size());
		System.assertEquals(true, activity[0]);
		System.assertEquals(true, activity[1]);
		System.assertEquals(false, activity[2]);
	}
}
