# ModifySObject

`ModifySObject` implements [`SObjectFunction`](SObjectFunction) and modifies records by setting field values. Field values can be defined through a fluent interface.

Typically used with `forEach()` on [`SObjectCollection`](../collection/SObjectCollection) and [`SObjectStream`](../stream/SObjectStream).

## setField

Defines the value of a field. Returns `this` for method chaining.

**Signature**
```apex
ModifySObject setField(String targetFieldName, Object value)
ModifySObject setField(Schema.SObjectField field, Object value)
```

**Example**
```apex
// Using field token
ModifySObject modifier = Fn.Modify
    .setField(Account.Status__c, 'Active')
    .setField(Account.Rating, 'Hot');

// Using string field name
ModifySObject modifier2 = Fn.Modify.setField('Industry', 'Technology');

// Apply to collection
accounts.forEach(modifier);
```

## setFields

Defines the value of multiple fields at once. Returns `this` for method chaining.

**Signature**
```apex
ModifySObject setFields(Map<Schema.SObjectField, Object> fieldValues)
ModifySObject setFields(SObject prototype)
```

**Example**
```apex
// Using Map
Map<Schema.SObjectField, Object> updates = new Map<Schema.SObjectField, Object>{
    Account.Status__c => 'Active',
    Account.Rating => 'Hot'
};
ModifySObject modifier = Fn.Modify.setFields(updates);

// Using prototype SObject
Account prototype = new Account(Status__c = 'Active', Rating = 'Hot');
ModifySObject modifier2 = Fn.Modify.setFields(prototype);
```