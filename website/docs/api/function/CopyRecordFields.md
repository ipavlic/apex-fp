# CopyRecordFields

Implements [`SObjectToSObjectFunction`](SObjectToSObjectFunction). To be used through the [`Copy`](Copy) function factory, instead of directly.

## CopyRecordFields

Constructor.

**Signature**
```apex
CopyRecordFields(SObject prototype)
```

## apply

Copies all defined fields on the `prototype` record to the currently iterated record.

**Signature**
```apex
SObject apply(SObject record)
```