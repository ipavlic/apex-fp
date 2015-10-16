# filtering

## Introduction

LINQ-like queries for lists of Salesforce objects.

Once the list is already selected, saves you from:
- standard iteration matching
- new queries

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

    List<Account> lowRevenue = Filter.field('AnnualRevenue').lessThanOrEquals(cutoff).apply(accounts);
    List<Account> highRevenue = Filter.field('AnnualRevenue').greaterThan(cutoff).apply(accounts);

This uses just the original SOQL query, and replaces the usual looping code.

## Available filters

There are two available types of filters: object matching and field matching filter. Each has two possible behaviours:

1. `apply` selects matching elements from the list and returns them, with no modification from the original list.
2. `extract` selects matching elements from the list, extracts them out of the original list and returns them. The matching elements are removed from the original list.

### Object matching filter

An object matching filter matches the objects in a list with the given *prototype* object. It is a strict equality filter — if all of the fields of the prototype object match the fields on the list object, the list object is matched.

The matching check is performed only on those fields that are set on the prototype object. Other fields are ignored.

### Field matching filter

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

The queries are dynamic and therefore cannot be type-checked at compile-time. Field tokens only verify the existence of appropriate fields (but not their types) at compile-time.
