# ModifySObject

Implements [`SObjectFunction`](SObjectFunction), and modifies the record it is applied to. Field values can be defined through a fluent interface. It is meant to be used in `forEach` of [`SObjectCollection`](../collection/SObjectCollection) and [`SObjectStream`](../stream/SObjectStream).

## setField

Defines the value of a field. 

**Signature**
```
ModifySObject setField(String targetFieldName, Object value)
ModifySObject setField(Schema.SObjectField field, Object value)
```

## setFields

Defines the value of multiple fields.

**Signature**
```
ModifySObject setFields(Map<Schema.SObjectField, Object> fieldValues)
ModifySObject setFields(SObject prototype)
```

## call

Assigns the defined values to `record`.

**Signature**
```
void call(SObject record)
```