---
sidebar_position: 2
---

# Examples

## Filtering

### `SObjectCollection`

```apex title="Find opportunities over 150,000"
// List<Opportunity> opportunities = ...
SObjectCollection.of(opportunities).filter(Match.field(Opportunity.Amount).greaterThan(150000));
```

```apex title="Find opportunities over 150,000 that belong to a specific account"
// List<Opportunity> opportunities = ...
// Id accountId = ...
SObjectCollection.of(opportunities).filter(Match.field(Opportunity.Amount).greaterThan(150000).also(Opportunity.AccountId).equals(accountId));
```

## Grouping

### `SObjectCollection`

```apex title="Group accounts by parent accounts"
Map<Id, List<Account>> accountsByParentId = SObjectCollection.of(accounts).groupByIds(Account.ParentId);
```

## Mapping

### `SObjectCollection`

```apex title="Pluck opportunity values"
List<Decimal> opportunityValues = SObjectCollection.of(opportunities).pluckDecimal(Opportunity.Amount);
```

```apex title="Find average opportunity value"
Decimal averageOpportunityValue = SObjectCollection.of(opportunities).mapToDecimal(Opportunity.Amount).average();
```