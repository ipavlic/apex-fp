---
sidebar_position: 3
---

# DecimalCollection

## sum

**Signature**
```apex
Decimal sum()
```

Sums non-null `Decimal` values. Returns `null` if no such values exist in the collection.

**Example**
```apex
Decimal total = new DecimalCollection(new List<Decimal>){1, 2, 3}).sum(); // 6
```

## average

Averages non-null Decimal values. Returns `null` if no such values exist in the collection.

**Signature**
```apex
Decimal average()
```

**Example**
```apex
Decimal average = new DecimalCollection(new List<Decimal>){1, 2, 3}).average(); // 2
```

## filter

Filters all values satisfying the `predicate` into a new `DecimalCollection` view

**Signature**

```apex
DecimalCollection filter(ObjectPredicate predicate)
```