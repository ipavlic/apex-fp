@IsTest(IsParallel=true)
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
	private static void filterThrowsExceptionWhenNextIsCalledAndHasNextIsFalse() {
		List<Account> accounts = new List<Account>{
				new Account(Name = 'Wrong', AnnualRevenue = 100)
		};
		Iterator<SObject> iter = SObjectStream.of(accounts).filter(Fn.Match.field(Account.Name).equals('Ok'));

		try {
			iter.next();
			System.Assert.fail();
		} catch (NoSuchElementException e) {
			System.Assert.isTrue(true);
		}
	}

	@IsTest
	private static void removeThrowsExceptionWhenNextIsCalledAndHasNextIsFalse() {
		List<Account> accounts = new List<Account>{
				new Account(Name = 'Ok', AnnualRevenue = 100)
		};
		Iterator<SObject> iter = SObjectStream.of(accounts).remove(Fn.Match.field(Account.Name).equals('Ok'));

		try {
			iter.next();
			System.Assert.fail();
		} catch (NoSuchElementException e) {
			System.Assert.isTrue(true);
		}
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

	@IsTest
	private static void mapAll() {
		List<Account> accounts = new List<Account>{
				new Account(Name = '1'),
				new Account(Name = '2')
		};

		SObjectStream stream = SObjectStream.of(accounts).mapAll(
				Fn.MapTo(Opportunity.SObjectType)
						.mapField(Opportunity.Name, Account.Name)
		);
		System.Assert.isTrue(stream.hasNext());
		Opportunity opp1 = (Opportunity) stream.next();
		System.Assert.areEqual('1', opp1.Name);

		System.Assert.isTrue(stream.hasNext());
		Opportunity opp2 = (Opportunity) stream.next();
		System.Assert.areEqual('2', opp2.Name);

		System.Assert.isFalse(stream.hasNext());
	}

	@IsTest
	private static void toList() {
		List<Account> accounts = new List<Account>{
				new Account(Name = '1'),
				new Account(Name = '2')
		};

		List<Account> streamedAccounts = SObjectStream.of(accounts).toList();
		System.Assert.areEqual(2, streamedAccounts.size());
		System.Assert.areEqual('1', streamedAccounts[0].Name);
		System.Assert.areEqual('2', streamedAccounts[1].Name);
	}

	private class Counter implements SObjectFunction {
		private Integer total = 0;
		public void call(SObject record) {
			total++;
		}
		public Integer total() {
			return total;
		}
	}

	@IsTest
	private static void forEach() {
		List<Account> accounts = new List<Account>{
				new Account(),
				new Account(),
				new Account()
		};
		Counter counter = new Counter();
		SObjectStream.of(accounts).forEach(counter);
		System.Assert.areEqual(3, counter.total());
	}
}
