---
sidebar_position: 3
---

# DecimalCollection

## sum

**Signature**
```
Decimal sum()
```

Sums non-null `Decimal` values if they exist. Returns an empty optional if no such values exist.

**Example**
```
Decimal total = new DecimalCollection(new List<Decimal>){1, 2, 3}).sum(); // 6
```

## average

Averages non-null `Decimal` values if they exist. Returns an empty optional if no such values exist.

**Signature**
```
Decimal average()
```

**Example**
```
Decimal average = new DecimalCollection(new List<Decimal>){1, 2, 3}).average(); // 2
```

## filter

Filters all values satisfying the `predicate` into a new `DecimalCollection` view

**Signature**

```
DecimalCollection filter(ObjectPredicate predicate)
```