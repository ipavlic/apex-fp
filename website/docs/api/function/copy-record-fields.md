# `CopyRecordFields`

Implements [`SObjectToSObjectFunction`](sobject-to-sobject-function). To be used through the [`Copy`](copy) function factory, instead of directly.

## `CopyRecordFields`

Constructor.

**Signature**
```apex
CopyRecordFields(SObject prototype)
```

## `apply`

Copies all defined fields on the `prototype` record to the currently iterated record.

**Signature**
```apex
SObject apply(SObject record)
```