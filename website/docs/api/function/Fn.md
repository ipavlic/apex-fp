# Fn

`Fn` is a function factory for `SObject` functions and function factories.

## AssignTo

Returns a new [`AssignToSObject`](AssignToSObject) function.

## MapTo

Returns a new [`MapToSObject`](MapToSObject) or a [`MapToObject`](MapToObject) function. 

## Match

Returns a `Match` factory for building matching predicates.

### recordFields

**Signature**

Builds a [`RecordFieldMatch`](RecordFieldsMatch), a record matching predicate. The predicate returns `true` when applied to a record which matches all fields defined on the `prototype` record. Fields that are not defined on the `prototype` are not checked for equality.

```
RecordFieldsMatch recordFields(SObject prototype)
```

**Example**
```
RecordFieldsMatch isMatch = Match.recordFields(new Account{Name = 'Foo'});
isMatch.call(new Account{Name = 'Foo', Description = 'Some description'}); // true
isMatch.call(new Account{Name = 'Bar'}); // false
```

### field

Starts the construction of a field criteria matching function by defining a field. The field can be defined as an `Schema.SObjectField` or given as a `String` relation. Returns an [`IncompleteFieldsMatch`](IncompleteFieldsMatch) which can be completed into a [`FieldsMatch`](FieldsMatch) by invoking methods on it.

**Signature**

```
IncompleteFieldsMatch field(Schema.SObjectField field)
IncompleteFieldsMatch field(String fieldPath)
```
**Example**
```
Match.field(Opportunity.Amount).lessThan(10000)
Match.field('Parent.Id').equals(accountId);
```

## NotNull

Returns a `NotNull` predicate.