# `Copy`

`Copy` is a factory for [`SObjectToSObjectFunction`](sobject-to-sobject-function) mapping functions.

## `recordFields`

**Signature**

Builds a mapping function that copies all defined fields from the `prototype` record to the currently iterated record.  

```apex
CopyRecordFields recordFields(SObject record)
```

**Example**
```apex
// Id parentId = ... 
SObjectCollection.of(accounts).mapAll(Copy.recordFields(new Account(ParentId = parentId)));
SObjectStream.of(accounts).mapAll(Copy.recordFields(new Account(ParentId = parentId)));
```