# `Match`

`Match` is a matching predicate factory, designed to build functions for higher order functions of [`SObjectCollection`](../collection/sobject-collection) and [`SObjectStream`](../stream/sobject-stream).

## `recordFields`

**Signature**

Builds a [`RecordFieldMatch`](record-fields-match), a record matching predicate. The predicate returns `true` when applied to a record which matches all fields defined on the `prototype` record. Fields that are not defined on the `prototype` are not checked for equality.

```apex
RecordFieldsMatch recordFields(SObject prototype)
```

**Example**
```apex
RecordFieldsMatch isMatch = Match.recordFields(new Account{Name = 'Foo'});
isMatch.apply(new Account{Name = 'Foo', Description = 'Some description'}); // true
isMatch.apply(new Account{Name = 'Bar'}); // false
```

## `field`

Starts the construction of a field criteria matching function by defining a field. The field can be defined as an `Schema.SObjectField` or given as a `String` relation. Returns an [`IncompleteFieldsMatch`](incomplete-fields-match) which can be completed into a [`FieldsMatch`](fields-match) by invoking methods on it.

**Signature**

```apex
IncompleteFieldsMatch field(Schema.SObjectField field)
IncompleteFieldsMatch field(String fieldPath)
```
**Example**
```apex
Match.field(Opportunity.Amount).lessThan(10000)
Match.field('Parent.Id').equals(accountId);
```
