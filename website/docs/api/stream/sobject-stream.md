---
sidebar_position: 4
---

# `SObjectStream`

`SObjectStream` is a lazy collection of `SObject` instances which implements `Iterator<SObject>`. 

## `of`

Constructs an `SObjectStream` with the provided `Iterable<SObject>`. 

**Signature**

```apex
static SObjectStream of(Iterable<SObject> records)
```

**Example**

```apex
// List<Accounts> accounts = [...]
SObjectStream.of(accounts);
SObjectStream.of(Trigger.old);
```

## `filter`

**Signature**

```apex
SObjectStream filter(SObjectPredicate predicate)
```
**Example**

## `remove`

**Signature**

```apex
SObjectStream remove(SObjectPredicate predicate)
```
**Example**

## `mapAll`

**Signature**

```apex
SObjectStream mapAll(SObjectToSObjectFunction fn)
```
**Example**

## `mapSome`

**Signature**

```apex
SObjectStream mapAll(SObjectPredicate predicate, SObjectToSObjectFunction fn)
```
**Example**

## `find`

Iterates over elements of the collection, returning the first record `predicate` returns `true` for, or `null` if an element is not found.

**Signature**

```apex
SObject find(SObjectPredicate predicate)
```

## `hasNext`

**Signature**

```apex
virtual Boolean hasNext()
```
**Example**

SObjectStream accountStream = SObjectStream.of(Trigger.new);
while (accountStream.hasNext()) {
	Account acc = (Account) accountStream.next();
}

## `next`

**Signature**

```apex
virtual SObject next()
```

**Example**

```apex
SObjectStream largeOpportunities = SObjectStream.of(Trigger.new).filter(Match.field(Opportunity.Amount).gt(100000));
while (largeOpportunities.hasNext()) {
	Opportunity opp = (Opportunity) largeOpportunities.next();
}
```

## `toList`

Collects the stream into a `List`. This consumes the stream.

**Signature**
```apex
List<SObject> toList()
```