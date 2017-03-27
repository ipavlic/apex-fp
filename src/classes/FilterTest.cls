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
	static void testHasValue() {
		List<Account> accounts = testData();
		List<Account> filtered = (List<Account>) Filter.field(Account.Industry).hasValue().apply(accounts);
		System.assertEquals(0, filtered.size());

		filtered = (List<Account>) Filter.field(Account.Name).hasValue().apply(accounts);
		System.assertEquals(4, filtered.size());
	}

	@IsTest
	static void testIsIn() {
		List<Account> accounts = testData();
		List<Account> filtered = (List<Account>) Filter.field(Account.AnnualRevenue).isIn(new Set<Decimal>{60, 150}).apply(accounts);
		System.assertEquals(3, filtered.size());
		for (Account acc : filtered) {
			System.assert(acc.AnnualRevenue == 60 || acc.AnnualRevenue == 150);
		}
	}

	@IsTest
	static void testIsNotIn() {
		List<Account> accounts = testData();
		List<Account> filtered = (List<Account>) Filter.field(Account.AnnualRevenue).notIn(new Set<Decimal>{60}).apply(accounts);
		System.assertEquals(3, filtered.size());
		for (Account acc : filtered) {
			System.assert(acc.AnnualRevenue == 100 || acc.AnnualRevenue == 150);
		}
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

	@IsTest
	static void testListTyping() {
		List<Account> accounts = testData();
		List<sObject> filtered = Filter.field(Account.AnnualRevenue).lt(150).apply(accounts, List<Account>.class);
		System.assert(filtered instanceof List<Account>);
		System.assert(!(filtered instanceof List<Opportunity>));

		List<sObject> filteredWithoutType = Filter.field(Account.AnnualRevenue).lt(150).apply(accounts);
		// when no type is provided, the returned list is a list of sObjects which can be a list of anything!
		System.assert(filteredWithoutType instanceof List<Account>);
		System.assert(filteredWithoutType instanceof List<Opportunity>);

		List<sObject> extracted = Filter.field(Account.AnnualRevenue).lt(150).apply(accounts, List<Account>.class);
		System.assert(extracted instanceof List<Account>);
		System.assert(!(extracted instanceof List<Opportunity>));

		List<sObject> extractedWithoutType = Filter.field(Account.AnnualRevenue).lt(150).apply(accounts);
		// when no type is provided, the returned list is a list of sObjects which can be a list of anything!
		System.assert(extractedWithoutType instanceof List<Account>);
		System.assert(extractedWithoutType instanceof List<Opportunity>);
	}

	@IsTest
	static void testLazyFiltering() {
		List<Account> accounts = testData();
		Iterable<Account> lazyResults = (Iterable<Account>) Filter.field(Account.Name).eq('Ok').applyLazy(accounts);
		Iterator<Account> iter = lazyResults.iterator();
		System.assert(iter.hasNext());
		Account next = iter.next();
		System.assertEquals('Ok', next.Name);
		System.assertEquals(100, next.AnnualRevenue);
		System.assert(iter.hasNext());
		next = iter.next();
		System.assertEquals('Ok', next.Name);
		System.assertEquals(150, next.AnnualRevenue);
		System.assert(!iter.hasNext());
		Boolean isExceptionThrown = false;
		try {
			iter.next();
		} catch (NoSuchElementException e) {
			isExceptionThrown = true;
		}
		System.assert(isExceptionThrown, 'NoSuchElementException should have been thrown.');
	}

	@IsTest
	static void testLazyFilteringWithNoResults() {
		List<Account> accounts = testData();
		Iterable<Account> lazyResults = (Iterable<Account>) Filter.field(Account.Name).eq('Foo').applyLazy(accounts);
		Iterator<Account> iter = lazyResults.iterator();
		System.assert(!iter.hasNext());
	}

	@IsTest
	static void testMultipleLazyFiltering() {
		List<Account> accounts = testData();
		Iterable<Account> lazyResults = (Iterable<Account>) Filter.field(Account.Name).eq('Ok').applyLazy(accounts);
		Integer countOk = 0;
		Iterator<Account> iter = lazyResults.iterator();
		while (iter.hasNext()) {
			iter.next();
			countOk++;
		}
		System.assertEquals(2, countOk);

		lazyResults = (Iterable<Account>) Filter.field(Account.Name).eq('Wrong').applyLazy(accounts);
		Integer countWrong = 0;
		iter = lazyResults.iterator();
		while (iter.hasNext()) {
			iter.next();
			countWrong++;
		}
		System.assertEquals(2, countWrong);
	}
}