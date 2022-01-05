# OptionalDouble

A container object which may or may not contain a non-null `Double` value. If a value is present, `isPresent()` will return true and `get()` will return the value. Additional methods that depend on the presence or absence of a contained value are provided, such as `orElse()` (return a default value if value not present) or `orElseThrow` (throw an exception if a value is not present).

## of

Builds an `OptionalDouble`.

## isPresent

Returns `true` if a value is present.

**Signature**
```
Boolean isPresent()
```

## get

Returns the value when it is present. Throws a `System.NoSuchElementException` when it is not.

**Signature**
```
Double get()
```

## orElse

Returns a value when it is present, or `other` when it is not.
**Signature**
```
Double orElse(Double other)
```

## orElseThrow

Returns a value when it is present, or throws `e` when it is not.

**Signature**
```
Double orElseThrow(Exception e)
```


