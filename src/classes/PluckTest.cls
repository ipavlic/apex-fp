@IsTest
public class PluckTest {
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
		List<Decimal> revenues = Pluck.decimals(accounts, Account.AnnualRevenue);
		Decimal total = 0;
		for (Decimal revenue : revenues) {
			total += revenue; 
		}
		System.assertEquals(460.0, total);
	}
}