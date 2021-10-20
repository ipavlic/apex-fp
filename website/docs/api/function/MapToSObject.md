# MapToSobject

Implements [`SObjectToSObjectFunction`](SObjectToSObjectFunction) and maps values from a source record to an output record. Mappings and values of the output record can be defined through a a fluent interface. It is meant to be used in `mapAll` and `mapSome` functions of [`SObjectCollection`](../collection/SObjectCollection) and [`SObjectStream`](../stream/SObjectStream).

## MapToSObject

Constructor. `type` defines the type of the `SObject` the function will map to.

**Signature**
```
MapToSObject(Schema.SObjectType type)
```

**Example**
```
MapToSObject mapToTask = new MapToSObject(Task.SObjectType);
```

## mapField

Defines a `target field ← source field` mapping for the function. The value of target field is set to value of source field when source record is mapped to target.

**Signature**
```
MapToSObject mapField(String targetFieldName, String sourceFieldRelation)
MapToSObject mapField(Schema.SObjectField targetField, String sourceFieldRelation)
MapToSObject mapField(Schema.SObjectField targetField, Schema.SObjectField sourceField)
```
**Example**
```
//Opportunity opp = ...
Task task = (Task) new MapToSObject(Task.SObjectType).mapField(Task.WhatId, Opportunity.Id).call(opp);
System.assertEquals(oppId, task.WhatId);
```
## mapFields
Defines `target field ← source field` mappings for the function. The values of target fields are set to values of source fields when source record is mapped to target.

```
MapToSObject mapFields(Map<Schema.SObjectField, Schema.SObjectField> fieldMappings)
```

Define a field value on the target record.

## setField

Defines field values for the target record.

```
MapToSObject setField(String fieldName, Object value)
MapToSObject setField(Schema.SObjectField field, Object value)
```

## setFields

Defines field values on the target record either through a map, or through a `prototype` record.

```
MapToSObject setFields(Map<Schema.SObjectField, Object> fieldValues)
MapToSObject setFields(SObject prototype)
```

## call
```
SObject call(SObject record)
```

Create a new `SObject` of defined `type`, sets field values on it to defined ones, and then sets maps field values from source record to target record.