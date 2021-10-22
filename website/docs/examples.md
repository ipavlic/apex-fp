---
sidebar_position: 2
---

# Examples

## Filtering

### SObjectCollection

```apex title="Find opportunities over 150,000"
// List<Opportunity> opportunities = ...
SObjectCollection.of(opportunities).filter(Fn.Match.field(Opportunity.Amount).greaterThan(150000));
```

```apex title="Find opportunities over 150,000 that belong to a specific account"
// List<Opportunity> opportunities = ...
// Id accountId = ...
SObjectCollection.of(opportunities).filter(Fn.Match.field(Opportunity.Amount).greaterThan(150000).also(Opportunity.AccountId).equals(accountId));
```

## Grouping

### SObjectCollection

```apex title="Group accounts by parent accounts"
Map<Id, List<Account>> accountsByParentId = SObjectCollection.of(accounts).groupByIds(Account.ParentId);
```

## Mapping

### SObjectCollection

```apex title="Create tasks for opportunities of specific stage in a trigger"
List<Task> prospectingTasks = SObjectCollection.of(Trigger.new)
	.filter(Fn.Match.recordFields(new Opportunity(Stage = 'Prospecting')))
	.mapAll(Fn.MapTo(Task.SObjectType).setField(Task.Subject, 'Follow up').mapField(Task.WhatId, Opportunity.Id));
```

```apex title="Find average opportunity value"
OptionalDecimal averageOpportunityValue = SObjectCollection.of(opportunities).mapToDecimal(Opportunity.Amount).average();
```

```apex title="Pluck opportunity values"
List<Decimal> opportunityValues = SObjectCollection.of(opportunities).pluckDecimal(Opportunity.Amount);
```