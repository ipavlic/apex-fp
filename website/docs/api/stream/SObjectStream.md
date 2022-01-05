---
sidebar_position: 4
---

# SObjectStream

`SObjectStream` is a lazy collection of `SObject` instances which implements `Iterator<SObject>`. 

## of

Constructs an `SObjectStream` with the provided `Iterable<SObject>`. 

**Signature**

```
static SObjectStream of(Iterable<SObject> records)
```

**Example**

```
// List<Accounts> accounts = [...]
SObjectStream.of(accounts);
SObjectStream.of(Trigger.old);
```

## hasNext

**Signature**

```
virtual Boolean hasNext()
```
**Example**

SObjectStream accountStream = SObjectStream.of(Trigger.new);
while (accountStream.hasNext()) {
	Account acc = (Account) accountStream.next();
}

## next

**Signature**

```
virtual SObject next()
```

**Example**

```
SObjectStream largeOpportunities = SObjectStream.of(Trigger.new).filter(Fn.Match.field(Opportunity.Amount).gt(100000));
while (largeOpportunities.hasNext()) {
	Opportunity opp = (Opportunity) largeOpportunities.next();
}
```

## filter

Returns a stream consisting of the elements of this stream that match the given `predicate`.

**Signature**

```
SObjectStream filter(SObjectPredicate predicate)
```

## find

Returns an [`OptionalSObject`](../util/OptionalSObject) wrapping the first record `predicate` returns `true` for, or an empty `OptionalSObject` if no element is found. This consumes the stream.

**Signature**

```
OptionalSObject find(SObjectPredicate predicate)
```

## forEach

Iterates through the stream and invokes a function for each record. This consumes the stream.

**Signature**

```
void forEach(SObjectFunction fn)
```

## mapAll

**Signature**

```
SObjectStream mapAll(SObjectToSObjectFunction fn)
```

## mapSome

**Signature**

```
SObjectStream mapSome(SObjectPredicate predicate, SObjectToSObjectFunction fn)
```

## remove

Returns a stream consisting of the elements of this stream that do not match the given `predicate`.

**Signature**

```
SObjectStream remove(SObjectPredicate predicate)
```
**Example**

## toList

Collects the stream into a `List`. This consumes the stream.

**Signature**
```
List<SObject> toList()
```
