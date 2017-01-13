# Lambda

Functional programming on Salesforce! 

Lambda consists of several classes which enable functional programming style list manipulations: `Filter`, `Pluck` and `GroupBy`.

## `Filter`

Filter saves you from having to manually implement filtering lists of sObject records by some criteria.

### Introduction

Let's say you have to split records into two lists, one containing those accounts that have an annual revenue greater than some cutoff number, and the other those that do not. Having or not having the revenue greater than the cutoff is a *criterium* for filtering. We can use SOQL queries to **describe** *what* we want:

    List<Account> lowRevenue = [Select ..., AnnualRevenue from Account where ... and AnnualRevenue <= :cutoff]
    List<Account> lowRevenue = [Select ..., AnnualRevenue from Account where ... and AnnualRevenue > :cutoff]

However, there's a steep cost to filtering through SOQL:
- 1 additional SOQL query is required for each new selection
- text area fields cannot be filtered 

To avoid that, we have to select all accounts we're interested in:

    List<Account> accounts = [Select ..., AnnualRevenue from Account where ...];
    Integer cutoff = ...;

Then, we iterate through the accounts to filter the accounts according to the appropriate criteria. We do this by providing **instructions** *how* each account in a loop should be filtered.

    List<Account> lowRevenue = new List<Account>();
    List<Account> highRevenue = new List<Account>();

    for (Account acc : accounts) {
         // "filtering" the accounts
        if (acc.AnnualRevenue > cutoff) {
            highRevenue.add(acc);
        } else {
            lowRevenue.add(acc);
        }
    }

If we need additional splits, we have to nest inside the loop or write new methods. Since filtering through iteration is one of the most common patterns to avoid multiple SOQL queries, it would be great if we could have a generic way of doing it.  

### Functional filtering

It would be great if we could **describe** *what* we want, but not spend additional queries on it. `Filter` allows us to do that.

#### Available filters

There are two available types of filters: **field matching** and **object matching** filter. Each has two possible *behaviours*:

1. `apply` selects matching elements from the list and returns them, with no modification of the original list.
2. `extract` selects matching elements from the list, extracts them out of the original list and returns them. The matching elements are removed from the original list.

##### Field matching filter

A field matching filter matches the objects in a list with using some of the available **criteria**. Example:

    List<Account> lowRevenue = (List<Account>) Filter.field(Account.AnnualRevenue).lessThanOrEquals(cutoff).apply(accounts);

> Due to a bug in Salesforce's type system, a cast is not even required! This compiles as well:

    List<Account> highRevenue = Filter.field(Account.AnnualRevenue).greaterThan(cutoff).apply(accounts);

There are also shorter names for filtering criteria. Instead of `greaterThanOrEquals`, one can also write `geq`. We can further shorten our filtering to:

    List<Account> highRevenue = Filter.field(Account.AnnualRevenue).geq(cutoff).apply(accounts);

Multiple criteria can be stringed together with `also` to form the full query:

    List<Account> filtered = Filter.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).greaterThan(100000).apply(accounts);

Any number of criteria can be added with `also`. Only those records that match *all* criteria are then returned.

Currently available criteria are:

* `equals` (alias `eq`)
* `notEquals` (alias `neq`)
* `lessThan` (alias`lt`)
* `lessThanOrEquals` (alias`leq`)
* `greaterThan` (alias `gt`)
* `greaterThanOrEquals` (alias`geq`)

The queries are dynamic and therefore cannot be type-checked at compile-time. Field tokens only verify the existence of appropriate fields (but not their types) at compile-time. Fields chosen for filtering must be available on the list which is filtered, otherwise a `System.SObjectException: SObject row was retrieved via SOQL without querying the requested field` exception will be thrown.

##### Object matching filter

If we don't require inequality comparisons, and we're just looking for equality filtering, there is an additional filter which allows us to define a "prototype" object and find all objects that match it.

For example, to find all accounts which have `AnnualRevenue` of 50,000,000, we can use a single account with `AnnualRevenue` set to 50,000,000 and use it match other accounts. This account serves as a "prototype" object to match against.

    Account fiftyMillionAccount = new Account(AnnualRevenue = 50000000);
    List<Account> fiftyMillions = Filter.match(fiftyMillionAccount).apply(accounts);

If we're looking for accounts that have `AnnualRevenue` of 50,000,000 **and** are named 'Test', we can use a "prototype" that has such properties:

    Account prototype = new Account(
        Name = 'Test',
        AnnualRevenue = 50000000,
        Description = 'Test description'
    );
    List<Account> matchingAccounts = Filter.match(prototype).apply(accounts);

Using the object matching filter can easier to read then an equivalent field matching filter when there are multiple equality criteria:

    List<Account> matchingAccounts = Filter.field(Account.Name).equals('Test').also(Account.AnnualRevenue).equals('50000000').also(Account.Description).equals('Test description').apply(accounts);

An object matching is a strict equality filter — if all of the fields of the prototype object match the fields on the list object, the list object is matched.

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
    // do something with names

Plucking code can be replaced with a declarative call to the appropriate `Pluck` method:

    List<String> names = Pluck.strings(accounts, Account.Name);

## `GroupBy`

* `booleans`
* `decimals`
* `ids`
* `strings`

Another common pattern is grouping objects by some field on them values. If fact, it's so common that Apex provides some support for it out of the box, namely for grouping by `Id` fields on sObjects:

    List<Account> accounts = [Select Name,... from Account where ...];
    Map<Id, Account> accountsById = new Map<Id, Account>(accounts);

This doesn't work for any other field, and that's where `GroupBy` jumps in. Due to the limitations of Apex's type system, you cannot cast from `Map<String, List<SObject>>` to `Map<String, List<Account>>`. 

     // this doesn't compile!!!
    Map<String, List<Account>> accountsByName = (Map<String, List<Account>>) GroupBy.strings(accounts, Account.Name);

However, due to a bug in Salesforce's type system, you are free to just skip the cast! 

    // this compiles
    Map<String, List<Account>> accountsByName = GroupBy.strings(accounts, Account.Name);

**Be extra careful, the type system will NOT warn you if you use the wrong subtype of `sObject`!**

     // this compiles
    Map<String, List<Account>> accountsByName = GroupBy.strings(accounts, Account.Name);
    // this compiles as well!!!???
    Map<String, List<User>> accountsByName = GroupBy.strings(accounts, Account.Name);
    Map<String, List<Opportunity>> accountsByName = GroupBy.strings(accounts, Account.Name);