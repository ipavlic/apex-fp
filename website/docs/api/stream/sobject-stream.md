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

## `filter`

Returns a stream consisting of the elements of this stream that match the given `predicate`.

**Signature**

```apex
SObjectStream filter(SObjectPredicate predicate)
```

## `find`

Returns the first record `predicate` returns `true` for, or `null` if an element is not found. This consumes the stream.

**Signature**

```apex
SObject find(SObjectPredicate predicate)
```

## `mapAll`

**Signature**

```apex
SObjectStream mapAll(SObjectToSObjectFunction fn)
```

## `mapSome`

**Signature**

```apex
SObjectStream mapAll(SObjectPredicate predicate, SObjectToSObjectFunction fn)
```

## `remove`

Returns a stream consisting of the elements of this stream that do not match the given `predicate`.

**Signature**

```apex
SObjectStream remove(SObjectPredicate predicate)
```
**Example**

## `toList`

Collects the stream into a `List`. This consumes the stream.

**Signature**
```apex
List<SObject> toList()
```