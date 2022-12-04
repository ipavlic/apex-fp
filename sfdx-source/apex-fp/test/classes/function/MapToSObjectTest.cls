@IsTest(isParallel=true)
public with sharing class MapToSObjectTest {
	
	@IsTest
	private static void testFieldSetting() {
		Id oppId = TestUtility.getFakeId(Opportunity.SObjectType);
		Opportunity opp = new Opportunity(Id = oppId);
		Task task = (Task) new MapToSObject(Task.SObjectType).setField(Task.Subject, 'Test').call(opp);
		System.Assert.areEqual('Test', task.Subject);
	}

	@IsTest
	private static void testFieldNameSetting() {
		Id oppId = TestUtility.getFakeId(Opportunity.SObjectType);
		Opportunity opp = new Opportunity(Id = oppId);
		Task task = (Task) new MapToSObject(Task.SObjectType).setField('Subject', 'Test').call(opp);
		System.Assert.areEqual('Test', task.Subject);
	}

	@IsTest
	private static void testSimpleFieldMapping() {
		Id oppId = TestUtility.getFakeId(Opportunity.SObjectType);
		Opportunity opp = new Opportunity(Id = oppId);
		Task task = (Task) new MapToSObject(Task.SObjectType).mapField(Task.WhatId, Opportunity.Id).call(opp);
		System.Assert.areEqual(oppId, task.WhatId);
	}

	@IsTest
	private static void testSimpleFieldNameMapping() {
		Id oppId = TestUtility.getFakeId(Opportunity.SObjectType);
		Opportunity opp = new Opportunity(Id = oppId);
		Task task = (Task) new MapToSObject(Task.SObjectType).mapField(Task.WhatId, 'Id').call(opp);
		System.Assert.areEqual(oppId, task.WhatId);
	}

	@IsTest
	private static void testRelationMapping() {
		Id accountId = TestUtility.getFakeId(Account.SObjectType);
		Opportunity opp = new Opportunity(Account = new Account(Id = accountId));
		Task task = (Task) new MapToSObject(Task.SObjectType).mapField(Task.WhatId, 'Account.Id').call(opp);
		System.Assert.areEqual(accountId, task.WhatId);
	}
}