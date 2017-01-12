# Lambda

Functional programming on Salesforce!

Lambda consists of several classes which enable functional programming style list manipulations: `Filter`, `Pluck` and `GroupBy`.

## `Filter`

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

    List<Account> lowRevenue = (List<Account>) Filter.field(Account.AnnualRevenue).lessThanOrEquals(cutoff).apply(accounts);

> Due to a bug in Salesforce's type system, a cast is not even required! This compiles as well:

    List<Account> highRevenue = Filter.field(Account.AnnualRevenue).greaterThan(cutoff).apply(accounts);

We can also match fields on a "prototype" instance to target required objects.

    List<Account> fiftyMillions = Filter.match(new Account(AnnualRevenue = 50000000)).apply(accounts);
    List<Account> testFiftyMillions = Filter.match(new Account(Name = 'Test', AnnualRevenue = 50000000)).apply(accounts);


Available filters work on any provided list. A single list obtained from a SOQL query can be reused many times and looping code is replaced with a more functional construct. 

### Available filters

There are two available types of filters: **field matching** and **object matching** filter. Each has two possible *behaviours*:

1. `apply` selects matching elements from the list and returns them, with no modification of the original list.
2. `extract` selects matching elements from the list, extracts them out of the original list and returns them. The matching elements are removed from the original list.

#### Field matching filter

A field matching filter matches the objects in a list with using some of the available criteria. Example:

    List<Account> extracted = Filter.field(Account.Name).equals('Ok').apply(accounts);

Multiple criteria can be stringed together to form the full query:

    List<Account> filtered = Filter.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).greaterThan(100000).apply(accounts);

There are also shorter names for filtering criteria. Instead of `equals`, one can also write `eq`.

Currently available criteria are.

* `equals` (alias `eq`)
* `notEquals` (alias `neq`)
* `lessThan` (alias`lt`)
* `lessThanOrEquals` (alias`leq`)
* `greaterThan` (alias `gt`)
* `greaterThanOrEquals` (alias`geq`)


The queries are dynamic and therefore cannot be type-checked at compile-time. Field tokens only verify the existence of appropriate fields (but not their types) at compile-time. Fields chosen for filtering must be available on the list which is filtered, otherwise a `System.SObjectException: SObject row was retrieved via SOQL without querying the requested field` exception will be thrown.

#### Object matching filter

An object matching filter matches the objects in a list with the given *prototype* object instance. It's a strict equality filter — if all of the fields of the prototype object match the fields on the list object, the list object is matched.

The matching check is performed only on those fields that are set on the prototype object. Other fields are ignored. Fields that are present on the *prototype* object must also be available on the list which is filtered, otherwise a `System.SObjectException: SObject row was retrieved via SOQL without querying the requested field` exception will be thrown.

## `Pluck`

* `booleans`
* `decimals`
* `ids`
* `strings`

Pluck allows you to pluck values of a field from a list of sObjects into a new list. This pattern is used commonly when a field is used as a criteria for further programming logic. For example:

    List<Account> accounts = [Select Name,... from Account where ...];
    
    List<String> names = new List<String>();
    for (Account a : accounts) {
        names.add(a.Name);
    }

This pattern can be replaced by a functional call to the appropriate `Pluck` method:

    List<String> names = Pluck.strings(accounts, Account.Name);

## `GroupBy`

* `booleans`
* `decimals`
* `ids`
* `strings`

Another common pattern is grouping objects by some field on them values. If fact, it's so common that Apex provides some support for it out of the box, namely for grouping by `Id` fields on sObjects:

    List<Account> accounts = [Select Name,... from Account where ...];
    Map<Id, Account> accountsById = new Map<Id, Account>(accounts);

This doesn't work for any other field, and that's where `GroupBy` jumps in. Due to the limitations of Apex's type system, it has to be used in a specific way.

First, note that can't cast a `Map<String, List<SObject>>` to something ostensibly more specific, like `Map<String, List<Account>>`.

    Map<String, List<Account>> accountsByName = (Map<String, List<Account>>) GroupBy.strings(accounts, Account.Name); // this doesn't compile!!!

So you're forced to keep the general type:

    Map<String, List<sObject>> accountsByName = GroupBy.strings(accounts, Account.Name);

However, again due to the Apex's type system, you can skip the cast when you're retrieving the value of a group:

    List<Account> fooAccounts = accountsByName.get('Foo'); // this compiles

You however cannot use the group value directly in an iteration:

    for (Account acc : accountsByName.get('Foo')) {
        ...
    } // this doesn't compile!!!

to iterate, first get the values into a list (casting them implicitly) and then iterate the list.

    List<Account> fooAccounts = accountsByName.get('Foo');
    for (Account acc : fooAccounts) {
        ...
    } // this compiles