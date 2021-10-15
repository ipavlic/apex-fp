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
