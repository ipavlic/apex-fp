# MatchFields

`MatchFields` implements [`SObjectPredicate`](SObjectPredicate) and returns `true` if a record satisfies all field matching conditions currently defined. `MatchFields` is constructed from an [`IncompleteMatchFields`](IncompleteMatchFields) with a fluent interface.

Additional conditions can be defined with `also()`, or its alias `field()`, to create complex matching functions.

## also() (alias: field())

Adds another field condition to the chain, returning an [`IncompleteMatchFields`](IncompleteMatchFields) to specify the comparison operation.

**Signature**
```apex
IncompleteMatchFields also(Schema.SObjectField field)
IncompleteMatchFields also(String fieldPath)
IncompleteMatchFields field(Schema.SObjectField field)
IncompleteMatchFields field(String fieldPath)
```

**Example**
```apex
// Chain multiple field conditions
MatchFields isHighValueTech = Fn.Match.field(Account.Name).equals('Acme')
    .also(Account.AnnualRevenue).greaterThan(100000)
    .field(Account.Industry).equals('Technology');

// Use in filtering
SObjectCollection filtered = accounts.filter(isHighValueTech);

// Use with call() from SObjectPredicate interface
Boolean matches = isHighValueTech.call(myAccount);
```
