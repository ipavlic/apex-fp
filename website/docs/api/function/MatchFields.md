# MatchFields

`MatchFields` implements [`SObjectPredicate`](SObjectPredicate) and returns `true` if a record satisfies all field matching conditions currently defined. `MatchFields` is constructed from an [`IncompleteFieldsMatch`](IncompleteFieldsMatch) with a fluent interface.

Additional conditions can be defined with `also`, or its alias `field`, to create complex matching functions.

## also (alias field)

Adds another field condition to the chain.

**Signature**

```
IncompleteMatchFields also(Schema.SObjectField field)
IncompleteMatchFields also(String fieldPath)
```

**Example**

```
MatchFields m = Match.field(Account.Name).equals('Foo').also(Account.AnnualRevenue).greaterThan(100000);
```