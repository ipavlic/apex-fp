# IncompleteMatchFields

`IncompleteMatchFields` starts the fluent interface for building a [`MatchFields`](MatchFields). Adding a condition through methods on the `IncompleteMatchFields` yields a `MatchFields`, which is an [`SObjectPredicate`](SObjectPredicate). The process can be continued to add more field conditions.

## equals (alias eq)

Defines an equality comparison condition for the current field.

**Signature**
```
MatchFields equals(Object value)
```

**Signature**
```
MatchFields eq(Object value)
```
## notEquals (alias neq)

Defines an inequality comparison condition for the current field.

**Signature**
```
MatchFields notEquals(Object value)
```

## lessThan (alias lt)

Defines a less than comparison condition for the current field.

**Signature**
```
MatchFields lessThan(Object value)
```

## lessThanOrEquals (alias leq)

Defines a less than or equals condition for the current field.

**Signature**
```
MatchFields lessThanOrEquals(Object value)
```

## greaterThan (alias gt)

Defines a greater than condition for the current field.

**Signature**
```
MatchFields greaterThan(Object value)
```

## greaterThanOrEquals (alias geq)

Defines a greater than or equals condition for the current field.

**Signature**
```
MatchFields greaterThanOrEquals(Object value)
```

## hasValue

Defines a non-null condition for the current field.

**Signature**
```
MatchFields hasValue()
```

## isIn

Defines a set membership condition for the current field. `value` has to be a `Set<T>`, where `T` is a `Boolean`, `Date`, `Datetime`, `Decimal`, `Double`, `Id`, `Integer`, `Long` or `String`. **Other types are not supported and will throw an exception**.

**Signature**
```
MatchFields isIn(Object value)
```

## isNotIn (alias `ntIn)

**Signature**
```
MatchFields isNotIn(Object value)
```