# MatchRecordFields

`MatchRecordFields` implements [`SObjectPredicate`](SObjectPredicate) and returns `true` when a record matches all populated fields on a prototype SObject.

Fields that are not populated on the `prototype` are not checked for equality, allowing partial matching.

## Constructor

Constructs a `MatchRecordFields` for a given `prototype`.

**Signature**
```apex
public MatchRecordFields(SObject prototype)
```

**Example**
```apex
// Create matcher from prototype
MatchRecordFields matcher = new MatchRecordFields(new Account{
    Name = 'Acme Corp',
    Industry = 'Technology'
});

// Or use via Fn.Match
MatchRecordFields matcher2 = Fn.Match.recordFields(new Account{Status__c = 'Active'});

// Test records
matcher.call(new Account{Name = 'Acme Corp', Industry = 'Technology'}); // true
matcher.call(new Account{Name = 'Acme Corp', Industry = 'Technology', AnnualRevenue = 1000000}); // true (extra fields ignored)
matcher.call(new Account{Name = 'Other Corp', Industry = 'Technology'}); // false
```