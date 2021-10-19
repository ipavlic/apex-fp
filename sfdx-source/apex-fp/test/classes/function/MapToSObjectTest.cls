@IsTest
public with sharing class MapToSObjectTest {
	
	@IsTest
	public static void testFieldSetting() {
		Id oppId = TestUtility.getTestId(Opportunity.SObjectType);
		Opportunity opp = new Opportunity(Id = oppId);
		Task task = (Task) new MapToSObject(Task.SObjectType).setField(Task.Subject, 'Test').apply(opp);
		System.assertEquals('Test', task.Subject);
	}

	@IsTest
	public static void testFieldNameSetting() {
		Id oppId = TestUtility.getTestId(Opportunity.SObjectType);
		Opportunity opp = new Opportunity(Id = oppId);
		Task task = (Task) new MapToSObject(Task.SObjectType).setField('Subject', 'Test').apply(opp);
		System.assertEquals('Test', task.Subject);
	}

	@IsTest
	public static void testSimpleFieldMapping() {
		Id oppId = TestUtility.getTestId(Opportunity.SObjectType);
		Opportunity opp = new Opportunity(Id = oppId);
		Task task = (Task) new MapToSObject(Task.SObjectType).mapField(Task.WhatId, Opportunity.Id).apply(opp);
		System.assertEquals(oppId, task.WhatId);
	}

	@IsTest
	public static void testSimpleFieldNameMapping() {
		Id oppId = TestUtility.getTestId(Opportunity.SObjectType);
		Opportunity opp = new Opportunity(Id = oppId);
		Task task = (Task) new MapToSObject(Task.SObjectType).mapField(Task.WhatId, 'Id').apply(opp);
		System.assertEquals(oppId, task.WhatId);
	}

	@IsTest
	public static void testRelationMapping() {
		Id accountId = TestUtility.getTestId(Account.SObjectType);
		Opportunity opp = new Opportunity(Account = new Account(Id = accountId));
		Task task = (Task) new MapToSObject(Task.SObjectType).mapField(Task.WhatId, 'Account.Id').apply(opp);
		System.assertEquals(accountId, task.WhatId);
	}
}