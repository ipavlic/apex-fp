@IsTest(IsParallel=true)
private class MapToSObjectTest {
	
	@IsTest
	private static void testSetFieldWithFieldValue() {
		Opportunity opp = new Opportunity();
		Task task = (Task) new MapToSObject(Task.SObjectType).setField(Task.Subject, 'Test').call(opp);
		System.Assert.areEqual('Test', task.Subject);
	}
	@IsTest
	private static void testSetFieldWithRelationValue() {
		Opportunity opp = new Opportunity();
		Task task = (Task) new MapToSObject(Task.SObjectType).setField('Subject', 'Test').call(opp);
		System.Assert.areEqual('Test', task.Subject);
	}

	@IsTest
	private static void testSetFieldsWithFieldValues() {
		Opportunity opp = new Opportunity();
		Task task = (Task) new MapToSObject(Task.SObjectType).setFields(new Map<Schema.SObjectField, Object>{
				Task.Subject => 'Test'
		}).call(opp);
		System.Assert.areEqual('Test', task.Subject);
	}

	@IsTest
	private static void testSetFieldsWithPrototype() {
		Opportunity opp = new Opportunity();
		Task task = (Task) new MapToSObject(Task.SObjectType).setFields(new Task(Subject = 'Test')).call(opp);
		System.Assert.areEqual('Test', task.Subject);
	}

	@IsTest
	private static void testMapFieldWithField() {
		Id oppId = TestUtility.getFakeId(Opportunity.SObjectType);
		Opportunity opp = new Opportunity(Id = oppId);
		Task task = (Task) new MapToSObject(Task.SObjectType).mapField(Task.WhatId, Opportunity.Id).call(opp);
		System.Assert.areEqual(oppId, task.WhatId);
	}

	@IsTest
	private static void testMapFieldWithRelation() {
		Id accountId = TestUtility.getFakeId(Account.SObjectType);
		Opportunity opp = new Opportunity(Account = new Account(Id = accountId));
		Task task = (Task) new MapToSObject(Task.SObjectType).mapField(Task.WhatId, 'Account.Id').call(opp);
		System.Assert.areEqual(accountId, task.WhatId);
	}

	@IsTest
	private static void testMapFieldNameWithRelation() {
		Id accountId = TestUtility.getFakeId(Account.SObjectType);
		Opportunity opp = new Opportunity(Account = new Account(Id = accountId));
		Task task = (Task) new MapToSObject(Task.SObjectType).mapField('WhatId', 'Account.Id').call(opp);
		System.Assert.areEqual(accountId, task.WhatId);
	}

	@IsTest
	private static void testMapFieldsWithFields() {
		Opportunity opp = new Opportunity(Description = 'Test', Amount = 500);
		Account account = (Account) new MapToSObject(Account.SObjectType).mapFields(new Map<Schema.SObjectfield, Schema.SObjectField>{
			Account.Description => Opportunity.Description,
			Account.AnnualRevenue => Opportunity.Amount
		}).call(opp);
		System.Assert.areEqual(account.Description, opp.Description);
		System.Assert.areEqual(account.AnnualRevenue, opp.Amount);
	}

	@IsTest
	private static void testMapFieldsWithRelations() {
		Opportunity opp = new Opportunity(Description = 'Test', Amount = 500);
		Account account = (Account) new MapToSObject(Account.SObjectType).mapFields(new Map<Schema.SObjectfield, String>{
				Account.Description => 'Description',
				Account.AnnualRevenue => 'Amount'
		}).call(opp);
		System.Assert.areEqual(account.Description, opp.Description);
		System.Assert.areEqual(account.AnnualRevenue, opp.Amount);
	}
}