---
sidebar_position: 1
---

# SObjectCollection

`SObjectCollection` is an eager collection of `SObject` instances.

## `of`

Constructs an `SObjectCollection` with the provided `Iterable<SObject>` or `Set<SObject>`. 

**Signature**

```apex
static SObjectCollection of(Iterable<SObject> records)
static SObjectCollection of(Set<SObject> records)
```

**Example**

```apex
SObjectCollection.of([SELECT Id, Name, Amount FROM Opportunity WHERE Amount > 10000]);
SObjectCollection.of(Trigger.new);
```

## `isEmpty`

Returns true is the collection contains no elements, false otherwise.

**Signature**

```apex
Boolean isEmpty()
```

**Example**

```apex
SObjectCollection.of(new List<SObject>()).isEmpty(); // true
SObjectCollection.of(new List<Opportunity>{new Opportunity()}).isEmpty(); // false
```

## `difference`

Returns a collection view of those records that are not equal in the `other` collection, considering only `comparisonFields` in the comparison.

**Signature**

```apex
SObjectCollection difference(SObjectCollection other, Set<Schema.SObjectField> comparisonFields)
```
## `filter`

Returns a `SObjectCollection` view of records that satisfied `predicate`.

**Signature**

```apex
SObjectCollection filter(SObjectPredicate predicate)
```
Two predicates are provided out of the box, `FieldsMatch` and `RecordMatch`. They are instantiated through factory methods on `Match`.

**Example**

```apex
// List<Account> accounts = ...
SObjectCollection accountCollection = SObjectCollection.of(accounts);

Account prototype = new Account(Name = 'Foo');
SObjectCollection recordMatched = accountCollection.filter(Match.record(prototype));

SObjectCollection filtered = accountCollection.filter(Match.field(Account.Name).equals('Foo').also(Account.AnnualRevenue).greaterThan(100000));
```

## `remove`

`remove` works just like `filter`, but records which match a predicate are *removed* from the collection view instead of kept.

## pluck

### `pluckBooleans`

Plucks `Boolean` values at `field` or `relation`.

**Signature**

```apex
List<Boolean> pluckBooleans(Schema.SObjectField field)
List<Boolean> pluckBooleans(String relation)
```

### `pluckDates`

Plucks `Date` values at `field` or `relation`.

**Signature**

```apex
List<Date> pluckDates(Schema.SObjectField field)
List<Date> pluckDates(String relation)
```

### `pluckDatetimes`

Plucks `Datetime` values at `field` or `relation`.

**Signature**

```apex
List<Datetime> pluckDatetimes(Schema.SObjectField field)
List<Datetime> pluckDatetimes(String relation)
```

### `pluckDecimals`

Plucks numerical values at `field` or `relation`.

**Signature**

```apex
List<Decimal> pluckDecimals(Schema.SObjectField field)
List<Decimal> pluckDecimals(String relation)
```

### `pluckIds`

Plucks `Id` values at `field` or `relation` or `Id` field.

**Signature**

```apex
List<Id> pluckIds(Schema.SObjectField field)
List<Id> pluckIds(String relation)
List<Id> pluckIds()
```

### `pluckStrings`

Plucks `String` values at `field` or `relation`.

**Signature**

```apex
List<String> pluckStrings(Schema.SObjectField field)
List<String> pluckStrings(String relation)
```

**Example**

```apex
List<Opportunity> opportunities = new List<Opportunity>{
	new Opportunity(Name = 'Opp1', Account = new Account(Name = 'Acc1')),
	new Opportunity(Name = 'Opp2, Account = new Account(Name = 'Acc2'))
};
List<String> opportunityFieldNames = SObjectCollection.of(opportunities).pluckStrings(Opportunity.Name); // ['Opp1', 'Opp2']
List<String> opportunityRelationNames = SObjectCollection.of(opportunities).pluckStrings('Name'); // ['Opp1' 'Opp2']
List<String> accountRelationNames = SObjectCollection.of(opportunities).pluckStrings('Account.Name'); // ['Acc1', 'Acc2']
```

## groupBy

### `groupByBooleans`

Groups records by `Boolean` values at `field` or `apiFieldName`, with an optional strong `listType`.

**Signature**
```apex
Map<Boolean, List<SObject>> groupByBooleans(String apiFieldName, Type listType)
Map<Boolean, List<SObject>> groupByBooleans(String apiFieldName)
Map<Boolean, List<SObject>> groupByBooleans(Schema.SObjectField field, Type listType)
Map<Boolean, List<SObject>> groupByBooleans(Schema.SObjectField field)
```

### `groupByDates`

Groups records by `Date` values at `field` or `apiFieldName`, with an optional strong `listType`.

**Signature**
```apex
Map<Date, List<SObject>> groupByDates(String apiFieldName, Type listType)
Map<Date, List<SObject>> groupByDates(String apiFieldName)
Map<Date, List<SObject>> groupByDates(Schema.SObjectField field, Type listType)
Map<Date, List<SObject>> groupByBooleans(Schema.SObjectField field)
```

### `groupByDatetimes`

Groups records by `Datetime` values at `field` or `apiFieldName`, with an optional strong `listType`.

**Signature**
```apex
Map<Datetime, List<SObject>> groupByDatetimes(String apiFieldName, Type listType)
Map<Datetime, List<SObject>> groupByDatetimes(String apiFieldName)
Map<Datetime, List<SObject>> groupByDatetimes(Schema.SObjectField field, Type listType)
Map<Datetime, List<SObject>> groupByDatetimes(Schema.SObjectField field)
```

### `groupByDecimals`

Groups records by numeric values at `field` or `apiFieldName`, with an optional strong `listType`.

**Signature**
```apex
Map<Decimal, List<SObject>> groupByDecimals(String apiFieldName, Type listType)
Map<Decimal, List<SObject>> groupByDecimals(String apiFieldName)
Map<Decimal, List<SObject>> groupByDecimals(Schema.SObjectField field, Type listType)
Map<Decimal, List<SObject>> groupByDecimals(Schema.SObjectField field)
```

### `groupByIds`

Groups records by `Id` values at `field` or `apiFieldName`, with an optional strong `listType`.

**Signature**
```apex
Map<Id, List<SObject>> groupByIds(String apiFieldName, Type listType)
Map<Id, List<SObject>> groupByIds(String apiFieldName)
Map<Id, List<SObject>> groupByIds(Schema.SObjectField field, Type listType)
Map<Id, List<SObject>> groupByIds(Schema.SObjectField field)
```

### `groupByStrings`

Groups records by `String` values at `field` or `apiFieldName`, with an optional strong `listType`.

**Signature**
```apex
Map<String, List<SObject>> groupByStrings(String apiFieldName, Type listType)
Map<String, List<SObject>> groupByStrings(String apiFieldName)
Map<String, List<SObject>> groupByStrings(Schema.SObjectField field, Type listType)
Map<String, List<SObject>> groupByStrings(Schema.SObjectField field)
```

## `pick`

Returns a new `SObjectCollection` view of the collection which keeps just the specified `fields`, discarding others. Helps reduce overwriting potential for concurrent updates when locking is not an option.

**Signature**
```apex
SObjectCollection pick(List<Schema.SObjectField> fields)
SObjectCollection pick(Set<Schema.SObjectField> fields) 
SObjectCollection pick(List<String> apiFieldNames)
SObjectCollection pick(Set<String> apiFieldNames)
```

**Example**

```apex
List<Opportunity> opportunities = new List<Opportunity>{
	new Opportunity(Name = 'Foo', Amount = 10000, Description = 'Bar')
}
// Picked contains just Name and Amount fields. Description is not present.
SObjectCollection picked = SObjectCollection.of(opportunities).pick(new Set<String>{'Name', 'Amount'});
```

## `mapAll`

Maps all elements of `SObjectCollection` view into another `SObjectCollection` view with the provided `SObjectToSObjectFunction`-implementing function `fn`.

**Signature**
```apex
SObjectCollection mapAll(SObjectToSObjectFunction fn)
```

**Example**
```apex
private class DoubleAmount implements SObjectToSObjectFunction {
    public SObject apply(SObject record) {
        record.put('Amount', 2 * (Decimal) record.get('Amount'));
        return record;
    }
}

List<Opportunity> opps = new List<Opportunity>{
    new Opportunity(Amount = 100),
    new Opportunity(Amount = 150)
};

SObjectCollection.of(opps).mapAll(new DoubleAmount()); // amounts have been doubled
```

## `mapSome`

Returns a new `SObjectCollection` view formed by mapping those view elements that satisfy `SObjectPredicate`-implementing `predicate` with `SObjectToSObject`-implementing function `fn`, and keeping those that do not unchanged.

**Signature**
```apex
SObjectCollection mapSome(SObjectPredicate predicate, SObjectToSObjectFunction fn)
```

**Example**

```apex
private class DoubleAmount implements SObjectToSObjectFunction {
    public SObject apply(SObject record) {
        record.put('Amount', 2 * (Decimal) record.get('Amount'));
        return record;
    }
}

List<Opportunity> opps = new List<Opportunity>{
    new Opportunity(Amount = 100),
    new Opportunity(Amount = 150)
};

SObjectCollection.of(opps).mapSome(Match.field('Amount').gt(120), new DoubleAmount()); // 100 remains, but 150 has been doubled to 300
```

## mapTo

### `mapToDecimal`

Maps a numeric field at `field` or `relation` to a `DecimalCollection`. This is similar to `pluckDecimals`, but unlike a raw `List<Decimal>` returns a `DecimalCollection` which provides further functions.

**Signature**
```apex
DecimalCollection mapToDecimal(Schema.SObjectField field)
DecimalCollection mapToDecimal(String relation)
```

### `mapToDouble`

Maps a numeric field at `field` or `relation` to a `DoubleCollection`. This is similar to `pluckDoubles`, but unlike a raw `List<Double>` returns a `DoubleCollection` which provides further functions.

**Signature**

```apex
DoubleCollection mapToDouble(Schema.SObjectField field)
DoubleCollection mapToDouble(String relation)
```


**Example**
```apex
List<Opportunity> opps = new List<Opportunity>{
    new Opportunity(Amount = 100),
    new Opportunity(Amount = 150)
};

Double average = SObjectCollection.of(opps).mapToDouble(Opportunity.Amount).average();
```