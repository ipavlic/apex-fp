@isTest
private class FilterTest {

	static List<Account> testData() {
		List<Account> accounts = new List<Account>();
		accounts.add(new Account(Name = 'Ok', AnnualRevenue = 100));
		accounts.add(new Account(Name = 'Wrong', AnnualRevenue = 60));
		accounts.add(new Account(Name = 'Ok', AnnualRevenue = 150));
		accounts.add(new Account(Name = 'Wrong', AnnualRevenue = 150));
		return accounts;
	}

	@isTest static void testFieldEqualsOkFilter() {
		
		List<Account> accounts = testData();
		
		List<Account> filtered = (List<Account>) Filter.field(Account.Name).equals('Ok').apply(accounts);
		
		system.assertEquals(2, filtered.size());
		for (Account acc : filtered) {
			system.assertEquals('Ok', acc.Name);
		}
		
		system.assertEquals(4, accounts.size());
		
		List<Account> extracted = (List<Account>) Filter.field(Account.Name).equals('Ok').extract(accounts);
		
		system.assertEquals(2, accounts.size());
		system.assertEquals(2, extracted.size());
		for (Account acc : extracted) {
			system.assertEquals('Ok', acc.Name);
		}
	}
	
	@isTest static void testMultipleFieldFilter() {
		
		List<Account> accounts = testData();
		
		List<Account> filtered = (List<Account>) Filter.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).gt(100).apply(accounts);
		
		system.assertEquals(1, filtered.size());
		for (Account acc : filtered) {
			system.assertEquals('Ok', acc.Name);
			system.assert(acc.AnnualRevenue > 100);
		}
		
		List<Account> extracted = (List<Account>) Filter.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).gt(100).extract(accounts);
		
		system.assertEquals(3, accounts.size());
		system.assertEquals(1, extracted.size());
		for (Account acc : extracted) {
			system.assertEquals('Ok', acc.Name);
			system.assert(acc.AnnualRevenue > 100);
		}
	}
	
	@isTest static void testSameFieldTokenExclusionCriteria() {
		
		List<Account> accounts = testData();
		
		List<Account> filtered = (List<Account>) Filter.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok').apply(accounts);
		
		system.assertEquals(0, filtered.size());
		
		List<Account> extracted = (List<Account>) Filter.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok').extract(accounts);
		
		system.assertEquals(4, accounts.size());
		system.assertEquals(0, extracted.size());
	}
	
	@isTest static void testSameFieldExclusionCriteria() {
		
		List<Account> accounts = testData();
		
		List<Account> filtered = (List<Account>) Filter.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok').apply(accounts);
		
		system.assertEquals(0, filtered.size());
		
		List<Account> extracted = (List<Account>) Filter.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok').extract(accounts);
		
		system.assertEquals(4, accounts.size());
		system.assertEquals(0, extracted.size());
	}
	
	@isTest static void testLongChaining() {
		
		List<Account> accounts = testData();
		
		List<Account> filtered = (List<Account>) Filter.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).geq(100).apply(accounts);
		
		system.assertEquals(1, filtered.size());
		
		List<Account> extracted = (List<Account>) Filter.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).geq(100).extract(accounts);
		
		system.assertEquals(3, accounts.size());
		system.assertEquals(1, extracted.size());
	}
	
	
	@isTest static void testSameFieldSandwichCriteria() {
		
		List<Account> accounts = testData();
		
		List<Account> filtered = (List<Account>) Filter.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60).apply(accounts);
		
		system.assertEquals(1, filtered.size());
		
		List<Account> extracted = (List<Account>) Filter.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60).extract(accounts);
		
		system.assertEquals(3, accounts.size());
		system.assertEquals(1, extracted.size());
	}
	
	@isTest static void testSameTokenSandwichCriteria() {
		
		List<Account> accounts = testData();
		
		List<Account> filtered = (List<Account>) Filter.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60).apply(accounts);
		
		system.assertEquals(1, filtered.size());
		
		List<Account> extracted = (List<Account>) Filter.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60).extract(accounts);
		
		system.assertEquals(3, accounts.size());
		system.assertEquals(1, extracted.size());
	}
	
	@isTest static void testComparisonFilter() {
		List<Account> accounts = testData();
		
		List<Account> filtered = (List<Account>) Filter.match(new Account(AnnualRevenue = 150)).apply(accounts);
		system.assertEquals(2, filtered.size());
		for (Account acc : filtered) {
			system.assertEquals(150, acc.AnnualRevenue);
		}
		
		List<Account> extracted = (List<Account>) Filter.match(new Account(AnnualRevenue = 150)).extract(accounts);
		system.assertEquals(2, accounts.size());
		system.assertEquals(2, extracted.size());
		for (Account acc : extracted) {
			system.assertEquals(150, acc.AnnualRevenue);
		}
	}
}