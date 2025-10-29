# Fn

`Fn` is the main function factory providing access to function builders and predicates for working with SObjects.

## NotNull

A static instance of [`SObjectNotNull`](SObjectNotNull) predicate that returns `true` when an SObject is not null.

**Example**
```apex
List<Account> accounts = new List<Account>{acc1, null, acc2};
SObjectCollection nonNull = SObjectCollection.of(accounts).filter(Fn.NotNull);
```

## Match

A static instance of [`MatchSObject`](MatchSObject) providing methods to build field matching predicates.

### Match.recordFields()

Builds a [`MatchRecordFields`](MatchRecordFields) predicate that returns `true` when applied to a record which matches all fields defined on the `prototype` record. Fields that are not defined on the `prototype` are not checked for equality.

**Signature**
```apex
MatchRecordFields recordFields(SObject prototype)
```

**Example**
```apex
MatchRecordFields isMatch = Fn.Match.recordFields(new Account{Name = 'Foo'});
isMatch.call(new Account{Name = 'Foo', Description = 'Some description'}); // true
isMatch.call(new Account{Name = 'Bar'}); // false
```

### Match.field()

Starts the construction of a field criteria matching function by defining a field. The field can be defined as a `Schema.SObjectField` or given as a `String` relation. Returns an [`IncompleteMatchFields`](IncompleteMatchFields) which can be completed into a [`MatchFields`](MatchFields) by invoking comparison methods on it.

**Signature**
```apex
IncompleteMatchFields field(Schema.SObjectField field)
IncompleteMatchFields field(String fieldPath)
```

**Example**
```apex
MatchFields amountCheck = Fn.Match.field(Opportunity.Amount).lessThan(10000);
MatchFields parentCheck = Fn.Match.field('Parent.Id').equals(accountId);
```

## Modify

Returns a new [`ModifySObject`](ModifySObject) function builder for modifying SObject fields.

**Example**
```apex
ModifySObject updateStatus = Fn.Modify.setField(Account.Status__c, 'Active');
updateStatus.call(myAccount);
```

## MapTo

Returns a new mapping function to transform SObjects.

### MapTo(Schema.SObjectType)

Returns a new [`MapToSObject`](MapToSObject) function for mapping SObjects to a different SObject type.

**Signature**
```apex
MapToSObject MapTo(Schema.SObjectType type)
```

### MapTo(Type)

Returns a new [`MapToObject`](MapToObject) function for mapping SObjects to custom Apex objects.

**Signature**
```apex
MapToObject MapTo(Type type)
```
