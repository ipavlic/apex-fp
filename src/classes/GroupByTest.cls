@IsTest
public class GroupByTest {
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
		Map<String, List<sObject>> accountsByName = GroupBy.strings(accounts, Account.Name);
		System.assertEquals(2, accountsByName.size());
		System.assert(accountsByName.keySet().contains('Foo'));
		System.assert(accountsByName.keySet().contains('Bar'));
		System.assertEquals(2, accountsByName.get('Foo').size());
		System.assertEquals(2, accountsByName.get('Bar').size());
		List<Account> fooAccounts = accountsByName.get('Foo');
		for (Account a : fooAccounts) {
			System.assertEquals('Foo', a.Name);
		}
		List<Account> barAccounts = accountsByName.get('Bar');
		for (Account a : barAccounts) {
			System.assertEquals('Bar', a.Name);
		}
	}
	@IsTest
	public static void testGroupByDecimals() {
		List<Account> accounts = testData();
		Map<Decimal, List<sObject>> accountsByRevenue = GroupBy.decimals(accounts, Account.AnnualRevenue);
		System.assertEquals(3, accountsByRevenue.size());
		System.assert(accountsByRevenue.keySet().contains(60));
		System.assert(accountsByRevenue.keySet().contains(100));
		System.assert(accountsByRevenue.keySet().contains(150));
		System.assertEquals(1, accountsByRevenue.get(60).size());
		System.assertEquals(1, accountsByRevenue.get(100).size());
		System.assertEquals(2, accountsByRevenue.get(150).size());
		List<Account> biggestAccounts = accountsByRevenue.get(150);
		for (Account a : biggestAccounts) {
			System.assertEquals(150.0, a.AnnualRevenue);
		}
	}
	@IsTest
	public static void testGroupByIds() {
		List<Account> accounts = testData();
		Map<Id, List<sObject>> accountsByOwners = GroupBy.ids(accounts, Account.OwnerId);
		System.assertEquals(2, accountsByOwners.size());
		System.assert(accountsByOwners.keySet().contains(firstUserId));
		System.assert(accountsByOwners.keySet().contains(secondUserId));
		System.assertEquals(3, accountsByOwners.get(firstUserId).size());
		System.assertEquals(1, accountsByOwners.get(secondUserId).size());
		List<Account> firstUserAccounts = accountsByOwners.get(firstUserId);
		for (Account a : firstUserAccounts) {
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
		Map<Boolean, List<sObject>> usersByActive = GroupBy.booleans(users, User.IsActive);
		System.assertEquals(2, usersByActive.size());
		System.assert(usersByActive.keySet().contains(true));
		System.assert(usersByActive.keySet().contains(false));
		System.assertEquals(2, usersByActive.get(true).size());
		System.assertEquals(1, usersByActive.get(false).size());
		List<User> activeUsers = usersByActive.get(true);
		for (User u : activeUsers) {
			System.assertEquals(true, u.IsActive);
		}
	}
}