Apex FP provides functional constructs for `SObject` collections!

# Examples

Transform `SObjects` with a simple declarative API.

```apex
List<Opportunity> largeOpportunities = SObjectCollection.of(opportunities).filter(Match.field(Opportunity.Amount).greaterThan(150000).also(Opportunity.AccountId).equals(accountId)).asList();
```

```apex
Map<Id, List<Account>> accountsByParentId = SObjectCollection.of(accounts).groupByIds(Account.ParentId);
```

```apex
Decimal averageOpportunityValue = SObjectCollection.of(opportunities).mapToDecimal(Opportunity.Amount).average();
```
Find more examples <a href="https://apexfp.org/examples">in the documentation</a>.

# Deploy to Salesforce

<a href="https://githubsfdeploy.herokuapp.com?owner=ipavlic&repo=apex-fp&ref=master">
  <img alt="Deploy to Salesforce" src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

# Read the documentation

<a href="https://www.apexfp.org">Apex FP documentation</a>