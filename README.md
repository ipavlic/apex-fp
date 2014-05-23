filtering
=========

LINQ-like queries for lists of Salesforce objects. 

There are two available types of filters: object matching and field matching filter. Each has two possible behaviours: 

1. `apply` selects matching elements from the list and returns them, with no modification from the original list.
2. `extract` selects matching elements from the list, extracts them out of the original list and returns them. The matching elements are removed from the original list.

Object matching filter
----------------------

An object matching filter matches the objects in a list with the given *prototype* object. It is a strict equality filter — if all of the fields of the prototype object match the fields on the list object, the list object is matched.

The matching check is performed only on those fields that are set on the prototype object. Other fields are ignored.

Field matching filter
---------------------

A field matching filter matches the objects in a list with using some of the available criteria. Example:

    List<Account> extracted = (List<Account>) Filter.field('Name').equals('Ok').apply(accounts);

Multiple criteria can be stringed together to form the full query:

    List<Account> filtered = (List<Account>) Filter.field('Name').equals('Ok').also('AnnualRevenue').apply(accounts);

There are also shorter names for filtering criteria. Instead of `equals`, one can also write `eq`.

Currently available criteria are.

* `equals` (alias `eq`)
* `notEquals` (alias `neq`)
* `lessThan` (alias`lt`)
* `lessThanOrEquals` (alias`leq`)
* `greaterThan` (alias `gt`)
* `greaterThanOrEquals` (alias`geq`)

The queries are dynamic and therefore cannot be type-checked at compile-time. There is an alternative form that uses field tokens instead of strings for fields in a query. That way at least the existence of the field can be checked at compile-time. 

In that form, the query `List<Account> filtered = (List<Account>) Filter.field('Name').equals('Ok').also('AnnualRevenue').apply(accounts);` can also be rewritten as:

    List<Account> filtered = (List<Account>) Filter.field(Account.Name).equals('Ok').also(Account.AnnualRevenue).apply(accounts);