# Lambda

Lambda brings functional programming to Salesforce!

The library consists of several classes which enable functional programming style list manipulations: `Filter`, `Pluck` and `GroupBy`.

# Documentation

- [Filter](#filter)
- [Pluck](#pluck)
- [GroupBy](#group-by)
- [Important notes on the type system in Apex](#type-system)

## `Filter`
<a name="filter"></a>

Filter saves you from having to implement filtering lists of sObject records by some criteria. There are two available *types* of filters: 

1. **field matching** and 
2. **object matching** filter. 

Each type has three possible *behaviours*:

1. `apply` selects matching elements from the list and returns them, with no modification of the original list.
2. `applyLazy` does the same as apply but returns an `Iterable<sObject>` instead.
3. `extract` selects matching elements from the list, extracts them out of the original list and returns them. The matching elements are removed from the original list.

### Field matching filter

A field matching filter matches the objects in a list with using some of the available **criteria**. Example:

    List<Account> lowRevenue = Filter.field(Account.AnnualRevenue).lessThanOrEquals(100000).apply(accounts);

There are also shorthand names for filtering criteria. Instead of `greaterThanOrEquals`, one can also write `geq`.

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

### Object matching filter

If we don't require inequality comparisons, and we're just looking for equality filtering, there is an additional filter which allows us to define a "prototype" object and find all objects that match it. 

Object matching is a strict equality filter — if all of the fields of the prototype object match the fields on the list object, the list object is matched.

For example, to find all accounts which have `AnnualRevenue` of exactly 50,000,000, we can use a single account with `AnnualRevenue` set to 50,000,000 and use it match other accounts. This account serves as a "prototype" object to match against.

    Account fiftyMillionAccount = new Account(AnnualRevenue = 50000000);
    List<Account> fiftyMillions = Filter.match(fiftyMillionAccount).apply(accounts);

If we're looking for accounts that have `AnnualRevenue` of 50,000,000 **and** are named 'Test', we can use a "prototype" that has such properties:

    Account prototype = new Account(
        Name = 'Test',
        AnnualRevenue = 50000000,
        Description = 'Test description'
    );
    List<Account> matchingAccounts = Filter.match(prototype).apply(accounts);

Using the object matching filter can be easier to read when there are multiple equality criteria then an equivalent field matching filter:

    List<Account> matchingAccounts = Filter.field(Account.Name).equals('Test').also(Account.AnnualRevenue).equals('50000000').also(Account.Description).equals('Test description').apply(accounts);

The matching check is performed only on those fields that are set on the prototype object. Other fields are ignored. Fields that are present on the *prototype* object must also be available on the list which is filtered, otherwise a `System.SObjectException: SObject row was retrieved via SOQL without querying the requested field` exception will be thrown.

### Motivation

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

If we need additional splits, we have to nest inside the loop or write new methods. It would be great if we could **describe** *what* we want, but not spend additional queries on it. `Filter` methods allow us to do that.

## `Pluck`
<a name="pluck"></a>

* `booleans(List<SObject>, Schema.SObjectField)`
* `decimals(List<SObject>, Schema.SObjectField)`
* `ids(List<SObject>)`
* `ids(List<SObject>, Schema.SObjectField)`
* `strings(List<SObject>, Schema.SObjectField)`

Pluck allows you to pluck values of a field from a list of sObjects into a new list. This pattern is used commonly when a field is used as a criteria for further programming logic. For example:

    List<Account> accounts = [Select Name,... from Account where ...];

    List<String> names = new List<String>();
    for (Account a : accounts) {
        names.add(a.Name);
    }
    // do something with names

Plucking code can be replaced with a declarative call to the appropriate `Pluck` method:

    List<String> names = Pluck.strings(accounts, Account.Name);

The `ids` method is returns a set instead of a list for convenience, because `Id` values are rarely required in order. If they are, `strings` can be used on `Id` fields as well.

    Set<Id> ownerIds = Pluck.ids(accounts, Account.OwnerId);

There is a shorthand version which doesn’t require a `Schema.SObjectField` parameter. Instead, it defaults to the system `Id` field:

    Set<Id> accountIds = Pluck.ids(accounts);
    // equivalent to Set<Id> accountIds = Pluck.ids(accounts, Account.Id);

## `GroupBy`
<a name="group-by"></a>

* `booleans`
* `decimals`
* `ids`
* `strings`

Another common pattern is grouping objects by some field on them values. If fact, it's so common that Apex provides some support for it out of the box, namely for grouping by `Id` fields on sObjects:

    List<Account> accounts = [Select Name,... from Account where ...];
    Map<Id, Account> accountsById = new Map<Id, Account>(accounts);

This doesn't work for any other field, and that's where `GroupBy` jumps in.

    Map<String, List<Account>> accountsByName = GroupBy.strings(accounts, Account.Name);

**Be extra careful, the type system will NOT warn you if you use the wrong subtype of `sObject`!**

     // this compiles
    Map<String, List<Account>> accountsByName = GroupBy.strings(accounts, Account.Name);
    // this compiles as well!!!???
    Map<String, List<User>> accountsByName = GroupBy.strings(accounts, Account.Name);
    Map<String, List<Opportunity>> accountsByName = GroupBy.strings(accounts, Account.Name);

## Important notes on the type system in Apex
<a name="type-system"></a>

Type system in Apex does not work as one would would naturally expect with `SObject` types. `SObject` and types which should be considered its subclasses do not behave like other objects in collections, likely because an `SObject` is a leaky facade.

Apex allows assignment of `SObject` collection to its “subclass”, and the other way around:

    List<SObject> objects = new List<SObject>();
	List<Account> accounts = objects; // compiles!

    List<Account> accounts = new List<Account>();
    List<SObject> objects = accounts; // compiles as well! 

An `SObject` list is an instance of any `SObject` “subclass” list!

    List<SObject> objects = new List<SObject>();
    System.debug(objects instanceof List<Account>); // true
    System.debug(objects instanceof List<Opportunity>); // true
    System.debug(objects instanceof List<Custom_Object__c>); // true 

As a result, in Apex we are able to sneak an `Opportunity` and a `Contact` into a list of `Account` objects, which only blows in runtime!

    List<SObject> objects = new List<SObject>();
    objects.add(new Opportunity());
    objects.add(new Contact());
    List<Account> accounts = objects;

    for (Account a : accounts) {
        // Dynamic query yields incompatible SObject type Opportunity for loop variable of type Account exception
    }

Now let's say we have an function which returns whether a `List<SObject>` is a list of a specific “subclass” of `SObject`.

    Boolean isOpportunityList(List<SObject> objects) {
        return objects instanceof List<Opportunity>;
    }

Here’s how it will behave with various parameters passed into it:

| Parameter       | `isOpportunityList` result |
| --------------- | ------------- |
| `List<SObject>` pointing to a `List<SObject>` | **`true`** |
| `List<SObject>` pointing to a `List<Opportunity>` | `true` |
| `List<SObject>` pointing to other subclasses | `false` |
| `List<Account>` | `false` |
| `List<Account>` pointing to a `List<SObject>` | **`true`** (regardless of what’s in a list) |

Lambda classes usually return a collection of `SObject`, which can be assigned a list of specific `SObject` “subclass”, like `Account`. While this works fine most of the time, above table shows that there are edge cases when it doesn’t behave expectedly. 

For example, if the list obtained from filtering is passed to a method that takes a list of `SObject` as a parameter, `instanceof` will provide unexpected answers in that method:

    List<Account> accounts = Filter...
    // accounts points to a List<SObject> returned from Filter

    Boolean isOpportunities = isOpportunityList(accounts);
    // returns true!!!

When you want to be sure that your `List<SomeObject>` will behave like `List<SomeObject>` in all situations, you could to explicitly cast to that. Example:

    List<SomeObject> someList = (List<SomeObject>) Filter. ...

However, you cannot cast from `Map<String, List<SObject>>` to `Map<String, List<Account>>`.

     // this doesn't compile!!!
    Map<String, List<Account>> accountsByName = (Map<String, List<Account>>) GroupBy.strings(accounts, Account.Name);

`Filter` and `GroupBy` therefore provide overloaded methods in which the concrete type of the list can be passed. This ensures that the returned `List` or `Map` are of the correct concrete type.