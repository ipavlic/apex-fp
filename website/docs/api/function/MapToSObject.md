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
Task task = (Task) new MapToSObject(Task.SObjectType) // Record will be mapped into a Task
	.mapField(Task.WhatId, Opportunity.Id) // Task will have WhatId set to Opportunity Id
	.call(opp);
```
## mapFields
Defines `target field ← source field` mappings for the function. The values of target fields are set to values of source fields when source record is mapped to target.

```
MapToSObject mapFields(Map<Schema.SObjectField, Schema.SObjectField> fieldMappings)
```

## setField

Defines field values for the target record.

```
MapToSObject setField(String fieldName, Object value)
MapToSObject setField(Schema.SObjectField field, Object value)
```

**Example**
```
//Opportunity opp = ...
Task task = (Task) new MapToSObject(Task.SObjectType) // Record will be mapped into a Task
	.setField(Task.Subject, 'Follow up') // Task will have Subject set to 'Follow up'
	.mapField(Task.WhatId, Opportunity.Id) // Task will have WhatId set to Opportunity Id
	.call(opp);
```

## setFields

Defines field values on the target record either through a map, or through a `prototype` record.

```
MapToSObject setFields(Map<Schema.SObjectField, Object> fieldValues)
MapToSObject setFields(SObject prototype)
```

**Example**
```
//Opportunity opp = ...
Task task = (Task) new MapToSObject(Task.SObjectType) // Record will be mapped into a Task
	.setFields(
		new Task(
			Subject = 'Follow up', 
			ActivityDate = Date.today().addDays(1)
		)
	) // Task will have Subject set to 'Follow up', and Activity Date set to tomorrow
	.mapField(Task.WhatId, Opportunity.Id) // Task will have WhatId set to Opportunity Id
	.call(opp);
```

## call
```
SObject call(SObject record)
```

Create a new `SObject` of defined `type`, sets field values on it to defined ones, and then sets maps field values from source record to target record.