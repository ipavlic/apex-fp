# MapToSobject

`MapToSObject` is an [`SObjectToSObjectFunction`](SObjectToSObject) with a fluent interface. It is meant to be used in `mapAll` and `mapSome` functions of [`SObjectCollection`](../collection/SObjectCollection) and [`SObjectStream`](../collection/SObjectStream).


## MapToSObject

Constructor. `type` defines the type of the `SObject` the function will map to.

**Signature**
```apex
MapToSObject(Schema.SObjectType type)
```

**Example**
```apex
MapToSObject mapToTask = new MapToSObject(Task.SObjectType);
```

## mapField

Defines a `target field ← source field` mapping for the function. The value of target field is set to value of source field when source record is mapped to target.

**Signature**
```apex
MapToSObject mapField(String targetFieldName, String sourceFieldRelation)
MapToSObject mapField(Schema.SObjectField targetField, String sourceFieldRelation)
MapToSObject mapField(Schema.SObjectField targetField, Schema.SObjectField sourceField)
```
**Example**
```apex
//Opportunity opp = ...
Task task = (Task) new MapToSObject(Task.SObjectType).mapField(Task.WhatId, Opportunity.Id).apply(opp);
System.assertEquals(oppId, task.WhatId);
```
## mapFields
Defines `target field ← source field` mappings for the function. The values of target fields are set to values of source fields when source record is mapped to target.

```apex
MapToSObject mapFields(Map<Schema.SObjectField, Schema.SObjectField> fieldMappings)
```

Define a field value on the target record.

## setField

Defines field values for the target record.

```apex
MapToSObject setField(String fieldName, Object value)
MapToSObject setField(Schema.SObjectField field, Object value)
```

## setFields

Defines field values on the target record either through a map, or through a `prototype` record.

```apex
MapToSObject setFields(Map<Schema.SObjectField, Object> fieldValues)
MapToSObject setFields(SObject prototype)
```

## apply
```apex
SObject apply(SObject record)
```

Create a new `SObject` of defined `type`, sets field values on it to defined ones, and then sets maps field values from source record to target record.