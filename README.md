# Apex FP

![CI workflow](https://github.com/ipavlic/apex-fp/actions/workflows/ci.yml/badge.svg)
[![codecov](https://codecov.io/gh/ipavlic/apex-fp/branch/main/graph/badge.svg)](https://codecov.io/gh/ipavlic/apex-fp)

Apex FP provides functional constructs for `SObject` collections!

## Examples

`SObjectCollection` and `SObjectStream` wrap regular collections to offer functional constructs.  

### Filter

```apex
List<Opportunity> largeOpportunities = SObjectCollection.of(opportunities)
	.filter(Fn.Match
		.field(Opportunity.Amount).greaterThan(150000)
		.also(Opportunity.AccountId).equals(accountId))
	.asList();
```

### Map

```apex
List<Task> prospectingOpportunityTasks = SObjectCollection.of(Trigger.new)
	.filter(Fn.Match.recordFields(new Opportunity(Stage = 'Prospecting')))
	.mapAll(Fn.MapTo(Task.SObjectType)
		.setField(Task.Subject, 'Follow up')
		.mapField(Task.WhatId, Opportunity.Id))
	.asList();
```

```apex
List<Task> largeProspectingOpportunityFollowUpTasks = SObjectCollection.of(Trigger.new)
	.filter(Fn.Match.recordFields(new Opportunity(Stage = 'Prospecting')))
	.mapSome(
		Fn.Match.field(Opportunity.Amount).greaterThan(100000),
		Fn.MapTo(Task.SObjectType)
			.setField(Task.Subject, 'Follow up')
			.mapField(Task.WhatId, Opportunity.Id)
	)
	.asList();
```

### Modify

```apex
List<Opportunity> largeOpportunities = SObjectCollection.of(opportunities)
	.forEach(Fn.Modify
		.setField(Opportunity.Rank__c, 'Excellent')
	)
	.asList();
```

### Debug

```apex
SObjectCollection.of(opportunities).forEach(Fn.Debug);
```

### Group

```apex
Map<Id, List<Account>> accountsByParentId = SObjectCollection.of(accounts).groupByIds(Account.ParentId);
```

### Pick

```apex
List<Opportunity> idAndAmountOpportunities = SObjectCollection.of(opportunities)
	.pick(new Set<Schema.SObjectField>{Opportunity.Id, Opportunity.Amount})
	.asList();
```

### Pluck

```apex
List<Decimal> amounts = SObjectCollection.of(opportunities).pluckDecimals(Opportunity.Amount);
``` 

### Average

```apex
OptionalDecimal average = SObjectCollection.of(opportunities).mapToDecimal(Opportunity.Amount).average();
```

### Sum

```apex
OptionalDecimal sum = SObjectCollection.of(opportunities).mapToDecimal(Opportunity.Amount).sum();
```

### Min

```apex
OptionalDecimal min = SObjectCollection.of(opportunities).mapToDecimal(Opportunity.Amount).min();
```

### Max

```apex
OptionalDecimal max = SObjectCollection.of(opportunities).mapToDecimal(Opportunity.Amount).max();
```

Find more examples <a href="https://apexfp.org/examples">in the documentation</a>.

## Deploy to Salesforce

<a href="https://githubsfdeploy.herokuapp.com?owner=ipavlic&repo=apex-fp&ref=master">
  <img alt="Deploy to Salesforce" src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Read the documentation

<a href="https://www.apexfp.org">Apex FP documentation</a>
