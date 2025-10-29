# MatchRecordFields

Implements [`SObjectPredicate`](SObjectPredicate).

## MatchRecordFields

Constructs a `MatchRecordFields` for a given `prototype`.

**Signature**
```
public MatchRecordFields(sObject prototype)
```

## call

Returns `true` when applied to a record which matches all fields defined on the `prototype` record. Fields that are not defined on the `prototype` are not checked for equality.

**Signature**

```
Boolean call(SObject record)
```