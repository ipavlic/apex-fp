# MatchSObject

`MatchSObject` is a factory class for building SObject matching predicates. It provides methods to create field-based and record-based matching functions.

## Usage

`MatchSObject` is available as a static instance on [`Fn`](Fn):

```apex
// Field-based matching
MatchFields highValue = Fn.Match.field(Opportunity.Amount).greaterThan(100000);

// Record-based matching
MatchRecordFields prototype = Fn.Match.recordFields(new Account{Status__c = 'Active'});
```

## recordFields()

Creates a [`MatchRecordFields`](MatchRecordFields) predicate that matches SObjects based on a prototype record. Only fields that are set on the prototype are compared.

**Signature**
```apex
MatchRecordFields recordFields(SObject prototype)
```

**Example**
```apex
// Match accounts with specific name
MatchRecordFields matcher = Fn.Match.recordFields(new Account{Name = 'Acme Corp'});
matcher.call(new Account{Name = 'Acme Corp', Industry = 'Tech'}); // true
matcher.call(new Account{Name = 'Other Corp'}); // false
```

## field()

Starts building a field criteria matching predicate. Returns an [`IncompleteMatchFields`](IncompleteMatchFields) that must be completed by specifying a comparison operation.

**Signature**
```apex
IncompleteMatchFields field(Schema.SObjectField field)
IncompleteMatchFields field(String fieldPath)
```

**Parameters**
- `field`: Schema field token (e.g., `Account.Name`)
- `fieldPath`: String field path, supports relationships (e.g., `'Parent.Name'`)

**Example**
```apex
// Using Schema.SObjectField
MatchFields largeDeals = Fn.Match.field(Opportunity.Amount).greaterThan(50000);

// Using string field path with relationships
MatchFields accountCheck = Fn.Match.field('Account.Industry').equals('Technology');

// Chaining multiple conditions
MatchFields complex = Fn.Match.field(Opportunity.Amount).greaterThan(10000)
    .also(Opportunity.StageName).equals('Closed Won');
```
