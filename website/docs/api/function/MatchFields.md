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
MatchFields matcher = Fn.Match.field(Account.Name).equals('Acme')
    .also(Account.AnnualRevenue).greaterThan(100000)
    .field(Account.Industry).equals('Technology');

// Use in filtering
SObjectCollection filtered = accounts.filter(matcher);
```

## call()

Evaluates all field conditions against the provided record. Returns `true` only if all conditions are satisfied.

**Signature**
```apex
Boolean call(SObject record)
```

**Example**
```apex
MatchFields highValueTech = Fn.Match.field(Account.Industry).equals('Technology')
    .also(Account.AnnualRevenue).greaterThan(1000000);

Boolean matches = highValueTech.call(myAccount);
```
