@IsTest
public class SObjectStreamTest {
	@IsTest
	public static void testIteration() {
		List<Account> accounts = new List<Account>{
			new Account(Name = 'Ok', AnnualRevenue = 100),
			new Account(Name = 'Wrong', AnnualRevenue = 60),
			new Account(Name = 'Ok', AnnualRevenue = 150),
			new Account(Name = 'Wrong', AnnualRevenue = 150)
		};
		Iterator<SObject> iter = SObjectStream.of(accounts).filter(Match.field(Account.Name).equals('Ok'));
		
		List<SObject> filtered = new List<SObject>();
		while (iter.hasNext()) {
			filtered.add(iter.next());
		}
		System.assertEquals(2, filtered.size());
		System.assertEquals(accounts[0], filtered[0]);
		System.assertEquals(accounts[2], filtered[1]);
	}

	@IsTest
	public static void testIterationChaining() {
		List<Account> accounts = new List<Account>{
			new Account(Name = 'Ok', AnnualRevenue = 100),
			new Account(Name = 'Wrong', AnnualRevenue = 60),
			new Account(Name = 'Ok', AnnualRevenue = 150),
			new Account(Name = 'Wrong', AnnualRevenue = 150)
		};
		Iterator<SObject> iter = SObjectStream.of(accounts).filter(Match.field(Account.Name).equals('Ok')).filter(Match.field(Account.AnnualRevenue).equals(150));
		
		List<SObject> filtered = new List<SObject>();
		while (iter.hasNext()) {
			filtered.add(iter.next());
		}
		System.assertEquals(1, filtered.size());
		System.assertEquals(accounts[2], filtered[0]);
	}
}
