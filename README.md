# Lambda

Functional programming on Salesforce

## Introduction

Lambda consists of two main classes which provide a way to perform common tasks on lists of sObjects in a functional style, `Filter` and `Lists`.

### `Filter`

Filter saves you from having to manually implement filtering list of sObject records by some criteria.

As an example, let's say you have to split the list into two lists, one containing those Accounts that have an annual revenue greater than some number, and the other without them. Our first option is to first select our accounts:

    List<Account> accounts = [Select ..., AnnualRevenue from Account where ...];
    Integer cutoff = ...;

After that we can iterate through the list to get our lists:

    List<Account> lowRevenue = new List<Account>();
    List<Account> highRevenue = new List<Account>();

    for (Account acc : accounts) {
        if (acc.AnnualRevenue > cutoff) {
            highRevenue.add(acc);
        } else {
            lowRevenue.add(acc);
        }
    }

If we need additional splits, we have to nest inside the loop (or write a new method).

Another option is to just use SOQL to select our lists:

    List<Account> lowRevenue = [Select ..., AnnualRevenue from Account where ... and AnnualRevenue <= :cutoff]
    List<Account> lowRevenue = [Select ..., AnnualRevenue from Account where ... and AnnualRevenue > :cutoff]

This spends 1 additional SOQL query for each new selection.

With filtering, we can write:

    List<Account> lowRevenue = Filter.field(Account.AnnualRevenue).lessThanOrEquals(cutoff).apply(accounts);
    List<Account> highRevenue = Filter.field(Account.AnnualRevenue).greaterThan(cutoff).apply(accounts);

We can also match fields on a "prototype" instance to target required objects.

    List<Account> fiftyMillions = (List<Account>) Filter.match(new Account(AnnualRevenue = 50000000)).apply(accounts);
    List<Account> testFiftyMillions = (List<Account>) Filter.match(new Account(Name = 'Test', AnnualRevenue = 50000000)).apply(accounts);


Available filters work on any provided list. A single list obtained from a SOQL query can be reused many times and looping code is replaced with a more functional construct. 

#### Available filters

There are two available types of filters: **field matching** and **object matching** filter. Each has two possible *behaviours*:

1. `apply` selects matching elements from the list and returns them, with no modification of the original list.
2. `extract` selects matching elements from the list, extracts them out of the original list and returns them. The matching elements are removed from the original list.

##### Field matching filter

A field matching filter matches the objects in a list with using some of the available criteria. Example:

    List<Account> extracted = (List<Account>) Filter.field(Account.Name).equals('Ok').apply(accounts);

Multiple criteria can be stringed together to form the full query:

    List<Account> filtered = (List<Account>) Filter.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).greaterThan(100000).apply(accounts);

There are also shorter names for filtering criteria. Instead of `equals`, one can also write `eq`.

Currently available criteria are.

* `equals` (alias `eq`)
* `notEquals` (alias `neq`)
* `lessThan` (alias`lt`)
* `lessThanOrEquals` (alias`leq`)
* `greaterThan` (alias `gt`)
* `greaterThanOrEquals` (alias`geq`)


The queries are dynamic and therefore cannot be type-checked at compile-time. Field tokens only verify the existence of appropriate fields (but not their types) at compile-time. Fields chosen for filtering must be available on the list which is filtered, otherwise a `System.SObjectException: SObject row was retrieved via SOQL without querying the requested field` exception will be thrown.

##### Object matching filter

An object matching filter matches the objects in a list with the given *prototype* object instance. It's a strict equality filter — if all of the fields of the prototype object match the fields on the list object, the list object is matched.

The matching check is performed only on those fields that are set on the prototype object. Other fields are ignored. Fields that are present on the *prototype* object must also be available on the list which is filtered, otherwise a `System.SObjectException: SObject row was retrieved via SOQL without querying the requested field` exception will be thrown.

## `Lists`

Lists provides list transformation utilities: plucking some fields into a new list and grouping by some field.

### Pluck

* `pluckNumerical`
* `pluckStringy`
* `pluckTruthy`

Pluck methods enable easy extraction of just one field from the list. This pattern is used commonly when a field is used as a criteria for further programming logic. For example, code snippet

    List<Account> accounts = [Select Name,... from Account where ...];
    
    List<String> names = new List<String>();
    for (Account a : accounts) {
        names.add(a.Name);
    }

This `pluck` operation of extracting a field from each object in a list into a new list is a very common one in functional languages. 

Since there is just a limited number of SOQL result field types (all text fields are mapped to `String`, numerical values are mapped to `Decimal`, truthy values are mapped to `Boolean` and so on), so even though Apex doesn't support generic types, the three provided methods cover most use cases and require no casting:

    List<Account> accounts = [Select Name,... from Account where ...];
    List<String> names = Lists.pluckStringy(accounts, Account.Name); // look, no type casting here!