@IsTest
public class ListsTest {
	static List<Account> testData() {
		List<Account> accounts = new List<Account>();
		accounts.add(new Account(Name = 'Foo', AnnualRevenue = 100));
		accounts.add(new Account(Name = 'Bar', AnnualRevenue = 60));
		accounts.add(new Account(Name = 'Foo', AnnualRevenue = 150));
		accounts.add(new Account(Name = 'Bar', AnnualRevenue = 150));
		return accounts;
	}
	@IsTest
	public static void testPlucking() {
		List<Account> accounts = testData();
		List<String> names = Lists.pluckStringy(accounts, Account.Name);
		System.assertEquals(4, names.size());
		Set<String> nameSet = new Set<String>(names);
		System.assertEquals(2, nameSet.size());
		System.assert(nameSet.contains('Foo'));
		System.assert(nameSet.contains('Bar'));
	}
}