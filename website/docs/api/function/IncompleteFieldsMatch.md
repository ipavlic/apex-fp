# IncompleteFieldsMatch

`IncompleteFieldsMatch` starts the fluent interface for building a `FieldsMatch`. Adding a condition through methods on the `IncompleteFieldsMatch` yields a `FieldsMatch`, which is an `SObjectPredicate`. The process can be continued to add more field conditions.

## equals (alias eq)

Defines an equality comparison condition for the current field.

**Signature**
```apex
FieldsMatch equals(Object value)
```

**Signature**
```apex
FieldsMatch eq(Object value)
```
## notEquals (alias neq)

Defines an inequality comparison condition for the current field.

**Signature**
```apex
FieldsMatch notEquals(Object value)
```

## lessThan (alias lt)

Defines a less than comparison condition for the current field.

**Signature**
```apex
FieldsMatch lessThan(Object value)
```

## lessThanOrEquals (alias leq)

Defines a less than or equals condition for the current field.

**Signature**
```apex
FieldsMatch lessThanOrEquals(Object value)
```

## greaterThan (alias gt)

Defines a greater than condition for the current field.

**Signature**
```apex
FieldsMatch greaterThan(Object value)
```

## greaterThanOrEquals (alias geq)

Defines a greater than or equals condition for the current field.

**Signature**
```apex
FieldsMatch greaterThanOrEquals(Object value)
```

## hasValue

Defines a non-null condition for the current field.

**Signature**
```apex
FieldsMatch hasValue()
```

## isIn

Defines a set membership condition for the current field. `value` has to be a `Set<T>`, where `T` is a `Boolean`, `Date`, `Datetime`, `Decimal`, `Double`, `Id`, `Integer`, `Long` or `String`. **Other types are not supported and will throw an exception**.

**Signature**
```apex
FieldsMatch isIn(Object value)
```

## isNotIn (alias `ntIn)

**Signature**
```apex
FieldsMatch isNotIn(Object value)
```