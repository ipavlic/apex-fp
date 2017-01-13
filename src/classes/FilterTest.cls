@IsTest
private class FilterTest {
	static List<Account> testData() {
		List<Account> accounts = new List<Account>();
		accounts.add(new Account(Name = 'Ok', AnnualRevenue = 100));
		accounts.add(new Account(Name = 'Wrong', AnnualRevenue = 60));
		accounts.add(new Account(Name = 'Ok', AnnualRevenue = 150));
		accounts.add(new Account(Name = 'Wrong', AnnualRevenue = 150));
		return accounts;
	}

	@IsTest
	static void testFieldEqualsOkFilter() {
		List<Account> accounts = testData();

		List<Account> filtered = (List<Account>) Filter.field(Account.Name).equals('Ok').apply(accounts);

		System.assertEquals(2, filtered.size());
		for (Account acc : filtered) {
			System.assertEquals('Ok', acc.Name);
		}

		System.assertEquals(4, accounts.size());

		List<Account> extracted = (List<Account>) Filter.field(Account.Name).equals('Ok').extract(accounts);

		System.assertEquals(2, accounts.size());
		System.assertEquals(2, extracted.size());
		for (Account acc : extracted) {
			System.assertEquals('Ok', acc.Name);
		}
	}

	@IsTest
	static void testMultipleFieldFilter() {

		List<Account> accounts = testData();
		List<Account> filtered = (List<Account>) Filter.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).gt(100).apply(accounts);

		System.assertEquals(1, filtered.size());
		for (Account acc : filtered) {
			System.assertEquals('Ok', acc.Name);
			System.assert(acc.AnnualRevenue > 100);
		}

		List<Account> extracted = (List<Account>) Filter.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).gt(100).extract(accounts);

		System.assertEquals(3, accounts.size());
		System.assertEquals(1, extracted.size());
		for (Account acc : extracted) {
			System.assertEquals('Ok', acc.Name);
			System.assert(acc.AnnualRevenue > 100);
		}
	}

	@IsTest
	static void testSameFieldTokenExclusionCriteria() {

		List<Account> accounts = testData();

		List<Account> filtered = (List<Account>) Filter.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok').apply(accounts);
		System.assertEquals(0, filtered.size());

		List<Account> extracted = (List<Account>) Filter.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok').extract(accounts);
		System.assertEquals(4, accounts.size());
		System.assertEquals(0, extracted.size());
	}

	@IsTest
	static void testSameFieldExclusionCriteria() {

		List<Account> accounts = testData();

		List<Account> filtered = (List<Account>) Filter.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok').apply(accounts);

		System.assertEquals(0, filtered.size());

		List<Account> extracted = (List<Account>) Filter.field(Account.Name).equals('Ok').also(Account.Name).neq('Ok').extract(accounts);
	
		System.assertEquals(4, accounts.size());
		System.assertEquals(0, extracted.size());
	}

	@IsTest
	static void testLongChaining() {
		List<Account> accounts = testData();

		List<Account> filtered = (List<Account>) Filter.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).geq(100).apply(accounts);

		System.assertEquals(1, filtered.size());

		List<Account> extracted = (List<Account>) Filter.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).geq(100).extract(accounts);

		System.assertEquals(3, accounts.size());
		System.assertEquals(1, extracted.size());
	}

	@IsTest
	static void testSameFieldSandwichCriteria() {
		List<Account> accounts = testData();

		List<Account> filtered = (List<Account>) Filter.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60).apply(accounts);

		System.assertEquals(1, filtered.size());

		List<Account> extracted = (List<Account>) Filter.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60).extract(accounts);

		System.assertEquals(3, accounts.size());
		System.assertEquals(1, extracted.size());
	}

	@IsTest
	static void testSameTokenSandwichCriteria() {
		List<Account> accounts = testData();

		List<Account> filtered = (List<Account>) Filter.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60).apply(accounts);	
		System.assertEquals(1, filtered.size());

		List<Account> extracted = (List<Account>) Filter.field(Account.AnnualRevenue).lt(150).also(Account.AnnualRevenue).gt(60).extract(accounts);

		System.assertEquals(3, accounts.size());
		System.assertEquals(1, extracted.size());
	}

	@IsTest
	static void testComparisonFilter() {
		List<Account> accounts = testData();

		List<Account> filtered = (List<Account>) Filter.match(new Account(AnnualRevenue = 150)).apply(accounts);
		System.assertEquals(2, filtered.size());
		for (Account acc : filtered) {
			System.assertEquals(150, acc.AnnualRevenue);
		}

		List<Account> extracted = (List<Account>) Filter.match(new Account(AnnualRevenue = 150)).extract(accounts);
		System.assertEquals(2, accounts.size());
		System.assertEquals(2, extracted.size());
		for (Account acc : extracted) {
			System.assertEquals(150, acc.AnnualRevenue);
		}
	}
}