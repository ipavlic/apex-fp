---
sidebar_position: 2
---

# DoubleCollection

## sum

**Signature**
```
OptionalDouble sum()
```

Sums non-null `Double` values if they exist. Returns an empty optional if no such values exist.

**Example**
```
OptionalDouble total = new DoubleCollection(new List<Double>){1, 2, 3}).sum(); // 6
```

## max

**Signature**
```
OptionalDouble max()
```

Returns greatest non-null `Double` value if it exists. Returns an empty optional if no such values exist.

**Example**
```
OptionalDouble max = new DoubleCollection(new List<Double>){1, 2, 3}).max(); // 3
```

## min

**Signature**
```
OptionalDouble min()
```

Returns smallest non-null `Double` value if it exists. Returns an empty optional if no such values exist.

**Example**
```
OptionalDouble min = new DoubleCollection(new List<Double>){1, 2, 3}).min(); // 1
```

## average

Averages non-null `Double` values if they exist. Returns an empty optional if no such values exist.

**Signature**
```
OptionalDouble average()
```

**Example**
```
OptionalDouble average = new DoubleCollection(new List<Double>){1, 2, 3}).average(); // 2
```

## filter

Filters all values satisfying the `predicate` into a new `DoubleCollection` view

**Signature**

```
DoubleCollection filter(ObjectPredicate predicate)
```