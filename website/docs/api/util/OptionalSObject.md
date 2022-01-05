# OptionalSObject

A container object which may or may not contain a non-null `SObject` record. If a record is present, `isPresent()` will return true and `get()` will return the record. Additional methods that depend on the presence or absence of a contained record are provided, such as `orElse()` (return a default record if record not present) or `orElseThrow` (throw an exception if a record is not present).

## of

Builds an `OptionalSObject`.

## isPresent

Returns `true` if a record is present.

**Signature**
```
Boolean isPresent()
```

## get

Returns the record when it is present. Throws a `System.NoSuchElementException` when it is not.

**Signature**
```
SObject get()
```

## orElse

Returns a record when it is present, or `other` when it is not.
**Signature**
```
SObject orElse(SObject other)
```

## orElseThrow

Returns a record when it is present, or throws `e` when it is not.

**Signature**
```
SObject orElseThrow(Exception e)
```


