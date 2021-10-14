# `FieldsMatch`

`FieldsMatch` implements `SObjectPredicate` and returns `true` if a record satisfies all field matching conditions currently defined. `FieldsMatch` is constructed from an `IncompleteFieldsMatch` with a fluent interface. Additional conditions can be defined with `also`, or its alias, `field`:

## `also` (alias `field`)

Adds another field condition to the chain.

**Signature**

| Method | Alias | Description |
|--------|-------|-------------|
| `IncompleteFieldsMatch also(Schema.SObjectField field)` | `field` | Defines another condition to match |
| `IncompleteFieldsMatch also(String fieldPath)` | `field` | Defines another condition to match |

```apex
FieldsMatch m = Match.field(Account.Name).equals('Foo').also(Account.AnnualRevenue).greaterThan(100000);
```