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
OptionalDecimal total = new DecimalCollection(new List<Decimal>){1, 2, 3}).sum(); // 6
```

## max

**Signature**
```
OptionalDecimal max()
```

Returns greatest non-null `Decimal` value if it exists. Returns an empty optional if no such values exist.

**Example**
```
OptionalDecimal max = new DecimalCollection(new List<Decimal>){1, 2, 3}).max(); // 3
```

## min

**Signature**
```
OptionalDecimal min()
```

Returns smallest non-null `Decimal` value if it exists. Returns an empty optional if no such values exist.

**Example**
```
OptionalDecimal min = new DecimalCollection(new List<Decimal>){1, 2, 3}).min(); // 1
```

## average

Averages non-null `Decimal` values if they exist. Returns an empty optional if no such values exist.

**Signature**
```
OptionalDecimal average()
```

**Example**
```
OptionalDecimal average = new DecimalCollection(new List<Decimal>){1, 2, 3}).average(); // 2
```

## filter

Filters all values satisfying the `predicate` into a new `DecimalCollection` view

**Signature**

```
DecimalCollection filter(ObjectPredicate predicate)
```