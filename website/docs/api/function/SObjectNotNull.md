# SObjectNotNull

`SObjectNotNull` implements [`SObjectPredicate`](SObjectPredicate) and returns `true` when the given SObject is not null.

## Usage

`SObjectNotNull` is available as a static instance on [`Fn`](Fn) and can be used directly:

```apex
// Filter out null records
List<Account> accounts = new List<Account>{acc1, null, acc2};
SObjectCollection nonNull = SObjectCollection.of(accounts).filter(Fn.NotNull);

// Use in conditional logic
if (Fn.NotNull.call(myAccount)) {
    // Process account
}
```

## call()

Returns `true` if the provided SObject is not null.

**Signature**
```apex
Boolean call(SObject record)
```

**Example**
```apex
SObject acc = new Account(Name = 'Test');
Fn.NotNull.call(acc); // true
Fn.NotNull.call(null); // false
```
