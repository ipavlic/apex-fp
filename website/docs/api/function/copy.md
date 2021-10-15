# `Copy`

`Copy` is a mapping factory.

## `recordFields`

**Signature**

Builds a mapping that copies all defined fields from the `prototype` record to the currently iterated record.  

```apex
CopyRecordFields recordFields(SObject record)
```

**Example**
```apex
// Id parentId = ... 
SObjectCollection.of(accounts).mapAll(Copy.recordFields(new Account(ParentId = parentId)));
SObjectStream.of(accounts).mapAll(Copy.recordFields(new Account(ParentId = parentId)));
```

## `mapFields`

Builds a mapping that copies all defined fields from the `fieldMap` to the currently iterated record.  

**Signature**

```apex
CopyMapFields mapFields(Map<Schema.SObjectField, Object> fieldMap)
```
**Example**
```apex
// Id parentId = ... 
SObjectCollection.of(accounts).mapAll(Copy.mapFields(new Map<Schema.SObjectField, Object>{Account.ParentId => parentId}));
SObjectStream.of(accounts).mapAll(Copy.mapFields(new Map<Schema.SObjectField, Object>{Account.ParentId => parentId}));
```