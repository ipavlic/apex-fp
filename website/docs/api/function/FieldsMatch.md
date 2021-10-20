# FieldsMatch

`FieldsMatch` implements [`SObjectPredicate`](SObjectPredicate) and returns `true` if a record satisfies all field matching conditions currently defined. `FieldsMatch` is constructed from an [`IncompleteFieldsMatch`](IncompleteFieldsMatch) with a fluent interface.

Additional conditions can be defined with `also`, or its alias `field`, to create complex matching functions.

## also (alias field)

Adds another field condition to the chain.

**Signature**

```
IncompleteFieldsMatch also(Schema.SObjectField field)
IncompleteFieldsMatch also(String fieldPath)
```

**Example**

```
FieldsMatch m = Match.field(Account.Name).equals('Foo').also(Account.AnnualRevenue).greaterThan(100000);
```