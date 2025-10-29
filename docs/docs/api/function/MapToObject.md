# MapToObject

Implements [`SObjectToObjectFunction`](SObjectToObjectFunction) and maps values from a source record to an output object. Mappings and values of the output record can be defined with a a fluent interface. It is meant to be used in `mapAll` of [`SObjectCollection`](../collection/SObjectCollection).

## MapToObject

Constructor. Defines the `type` of the `Object` the function will map to.

**Signature**
```
MapToObject(Type type)
```

**Example**
```
MapToObject mapToMappingTarget = new MapToObject(MappingTarget.class);
```

## mapField

Defines a `target field ← source field` mapping for the function. The value of target field is set to value of source field when source record is mapped to target object.

**Signature**
```
MapToObject mapField(String targetFieldPath, String sourceFieldRelation)
MapToObject mapField(String targetFieldPath, Schema.SObjectField sourceField)
```
**Example**
```apex title="Field relation"
// Opportunity opp = ...
MappingTarget mapped = (MappingTarget) new MapToObject(MappingTarget.class) // Record will be mapped into a MappingTarget
	.mapField('parent.name', 'Account.Name') // be mapped to parent name
	.mapField('description', 'Description') // MappingTarget will have description property set to opportunity description
	.call(opp);
```

```apex title="Field"
MappingTarget mapped = (MappingTarget) new MapToObject(MappingTarget.class) // Record will be mapped into a MappingTarget
	.mapField('child.field', Opportunity.Description) // Opportunity Description will be mapped into child.field on object
	.call(opp);
```
## mapFields
Defines multiple field mappings with a map. The values of target fields are set to values of source fields when source record is mapped to target. Source fields can be provided as relation paths or fields.

```
MapToObject mapFields(Map<String, String> fieldMappings)
MapToObject mapFields(Map<String, Schema.SObjectField> fieldMappings)
```

**Example**
```apex title="Field relations"
// Opportunity opp = ...
MappingTarget mapped = (MappingTarget) new MapToObject(MappingTarget.class) // Record will be mapped into a MappingTarget
	.mapFields(new Map<String, String>{
		'description', 'Description', // Description on Opportunity will be mapped into description on object
		'parent.accountName', 'Account.Name' // Account.Name on Opportunity will be mapped into parent.accountName on object
	})
	.call(opp);
```

```apex title="Fields"
// Opportunity opp = ...
MappingTarget mapped = (MappingTarget) new MapToObject(MappingTarget.class) // Record will be mapped into a MappingTarget
	.mapFields(new Map<String, Schema.SObjectField>{
		'description', Opportunity.Description, // Description on Opportunity will be mapped into description on object
		'name', Opportunity.Name // Name on Opportunity will be mapped into parent.accountName on object
	})
	.call(opp);
```

## setField

Defines field values for the target record.

```
MapToObject setField(String targetFieldPath, Object value)
```

**Example**
```
MappingTarget mapped = (MappingTarget) new MapToObject(MappingTarget.class) // Record will be mapped into a MappingTarget
	.setField('examplefield', 'apex-fp') // object will have examplefield property set to 'apex-fp'
	.call(opp);
```

## setFields

Defines field values on the target record with a map.

```
MapToObject setFields(Map<Schema.SObjectField, Object> fieldValues)
```

**Example**
```
//Opportunity opp = ...
Task task = (Task) new MapToObject(Task.SObjectType) // Record will be mapped into a Task
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
Object call(SObject record)
```

Create a new `Object` of defined `type`, sets field values on it to defined ones, and then sets maps field values from source record to target object.