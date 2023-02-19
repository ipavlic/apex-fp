# Apex FP

![CI workflow](https://github.com/ipavlic/apex-fp/actions/workflows/ci.yml/badge.svg)
[![codecov](https://codecov.io/gh/ipavlic/apex-fp/branch/master/graph/badge.svg)](https://codecov.io/gh/ipavlic/apex-fp)

Apex FP provides functional constructs for `SObject` collections!

## Examples

Transform `SObjects` with a simple declarative API.

```apex
List<Opportunity> largeOpportunities = SObjectCollection.of(opportunities)
	.filter(Fn.Match
		.field(Opportunity.Amount).greaterThan(150000)
		.also(Opportunity.AccountId).equals(accountId))
	.asList();
```

```apex
List<Task> prospectingTasks = SObjectCollection.of(Trigger.new)
	.filter(Fn.Match.recordFields(new Opportunity(Stage = 'Prospecting')))
	.mapAll(Fn.MapTo(Task.SObjectType)
		.setField(Task.Subject, 'Follow up')
		.mapField(Task.WhatId, Opportunity.Id))
	.asList();
```

```apex
Map<Id, List<Account>> accountsByParentId = SObjectCollection.of(accounts).groupByIds(Account.ParentId);
```

```apex
Decimal averageOpportunityValue = SObjectCollection.of(opportunities).mapToDecimal(Opportunity.Amount).average();
```
Find more examples <a href="https://apexfp.org/examples">in the documentation</a>.

## Deploy to Salesforce

<a href="https://githubsfdeploy.herokuapp.com?owner=ipavlic&repo=apex-fp&ref=master">
  <img alt="Deploy to Salesforce" src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Read the documentation

<a href="https://www.apexfp.org">Apex FP documentation</a>
