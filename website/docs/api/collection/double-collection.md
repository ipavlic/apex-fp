---
sidebar_position: 2
---

# `DoubleCollection`

## `sum`

**Signature**
```apex
Double sum()
```

Sums non-null `Double` values. Returns `null` if no such values exist in the collection.

**Example**
```apex
Double total = new DoubleCollection(new List<Double>){1, 2, 3}).sum(); // 6
```

## `average`

Averages non-null Double values. Returns `null` if no such values exist in the collection.

**Signature**
```apex
Double average()
```

**Example**
```apex
Double average = new DoubleCollection(new List<Double>){1, 2, 3}).average(); // 2
```

## `filter`

Filters all values satisfying the `predicate` into a new `DoubleCollection` view

**Signature**

```apex
DoubleCollection filter(ObjectPredicate predicate)
```