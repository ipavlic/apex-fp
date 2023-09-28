@IsTest(isParallel=true)
private class SObjectStreamTest {
	@IsTest
	private static void testFilter() {
		List<Account> accounts = new List<Account>{
			new Account(Name = 'Ok', AnnualRevenue = 100),
			new Account(Name = 'Wrong', AnnualRevenue = 60),
			new Account(Name = 'Ok', AnnualRevenue = 150),
			new Account(Name = 'Wrong', AnnualRevenue = 150)
		};
		Iterator<SObject> iter = SObjectStream.of(accounts).filter(Fn.Match.field(Account.Name).equals('Ok'));
		
		List<SObject> filtered = new List<SObject>();
		while (iter.hasNext()) {
			filtered.add(iter.next());
		}
		System.Assert.areEqual(2, filtered.size());
		System.Assert.areEqual(accounts[0], filtered[0]);
		System.Assert.areEqual(accounts[2], filtered[1]);
	}

	@IsTest
	private static void testFilterChaining() {
		List<Account> accounts = new List<Account>{
			new Account(Name = 'Ok', AnnualRevenue = 100),
			new Account(Name = 'Wrong', AnnualRevenue = 60),
			new Account(Name = 'Ok', AnnualRevenue = 150),
			new Account(Name = 'Wrong', AnnualRevenue = 150)
		};
		Iterator<SObject> iter = SObjectStream.of(accounts).filter(Fn.Match.field(Account.Name).equals('Ok')).filter(Fn.Match.field(Account.AnnualRevenue).equals(150));
		
		List<SObject> filtered = new List<SObject>();
		while (iter.hasNext()) {
			filtered.add(iter.next());
		}
		System.Assert.areEqual(1, filtered.size());
		System.Assert.areEqual(accounts[2], filtered[0]);
	}

	@IsTest
	private static void testRemove() {
		List<Account> accounts = new List<Account>{
			new Account(Name = 'Ok', AnnualRevenue = 100),
			new Account(Name = 'Wrong', AnnualRevenue = 60),
			new Account(Name = 'Ok', AnnualRevenue = 150),
			new Account(Name = 'Wrong', AnnualRevenue = 150)
		};
		Iterator<SObject> iter = SObjectStream.of(accounts).remove(Fn.Match.field(Account.Name).equals('Wrong'));		
		
		List<SObject> filtered = new List<SObject>();
		while (iter.hasNext()) {
			filtered.add(iter.next());
		}
		
		System.Assert.areEqual(2, filtered.size());
		System.Assert.areEqual(accounts[0], filtered[0]);
		System.Assert.areEqual(accounts[2], filtered[1]);
	}

	// @IsTest
	// public static void testMapAll() {
	// 	List<Account> accounts = new List<Account>{
	// 		new Account(Name = 'Ok'),
	// 		new Account(Name = 'Wrong'),
	// 		new Account(Name = 'Ok'),
	// 		new Account(Name = 'Wrong')
	// 	};
	// 	Iterator<SObject> iter = SObjectStream.of(accounts).mapAll(Copy.recordFields(new Account(AnnualRevenue = 100)));		
		
	// 	List<SObject> mapped = new List<SObject>();
	// 	while (iter.hasNext()) {
	// 		mapped.add(iter.next());
	// 	}
		
	// 	System.Assert.areEqual(4, mapped.size());
	// 	for (SObject record : mapped) {
	// 		System.Assert.areEqual(100, ((Account) record).AnnualRevenue);
	// 	}
	// }

	// @IsTest
	// public static void testMapSome() {
	// 	List<Account> accounts = new List<Account>{
	// 		new Account(Name = 'Ok'),
	// 		new Account(Name = 'Wrong'),
	// 		new Account(Name = 'Ok'),
	// 		new Account(Name = 'Wrong')
	// 	};
	// 	Iterator<SObject> iter = SObjectStream.of(accounts).mapSome(Match.field(Account.Name).equals('Ok'), Copy.recordFields(new Account(AnnualRevenue = 100)));
		
	// 	List<SObject> mapped = new List<SObject>();
	// 	while (iter.hasNext()) {
	// 		mapped.add(iter.next());
	// 	}
		
	// 	System.Assert.areEqual(4, mapped.size());
	// 	for (SObject record : mapped) {
	// 		Account a = (Account) record;
	// 		if (a.Name == 'Ok') {
	// 			System.Assert.areEqual(100, a.AnnualRevenue);
	// 		} else {
	// 			System.Assert.areEqual(null, a.AnnualRevenue);
	// 		}
	// 	}
	// }

	@IsTest
	private static void findFindsAnExistingRecord() {
		List<Account> accounts = new List<Account>{
			new Account(Name = 'One'),
			new Account(Name = 'Two'),
			new Account(Name = 'Three'),
			new Account(Name = 'Four')
		};

		OptionalSObject maybeAcc = SObjectStream.of(accounts).find(Fn.Match.field(Account.Name).equals('Three'));
		System.Assert.isTrue(maybeAcc.isPresent());
		System.Assert.areEqual(accounts[2], maybeAcc.get());
	}

	@IsTest
	private static void findReturnsEmptyWhenRecordDoesNotExist() {
		List<Account> accounts = new List<Account>{
			new Account(Name = 'One'),
			new Account(Name = 'Two'),
			new Account(Name = 'Three'),
			new Account(Name = 'Four')
		};

		OptionalSObject maybeAcc = SObjectStream.of(accounts).find(Fn.Match.field(Account.Name).equals('Five'));
		System.Assert.isTrue(!maybeAcc.isPresent());
	}
}
