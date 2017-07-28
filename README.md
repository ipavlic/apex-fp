# Lambda

Lambda brings functional programming to Salesforce! The library consists of several classes which enable declarative list manipulations: 
- [`Filter`](#filter)
- [`Pluck`](#pluck)
- [`GroupBy`](#group-by)

Potential pitfalls are explained in:
- [Important notes on the type system in Apex](#type-system) 

## `Filter`
<a name="filter"></a>

`Filter` enables filtering lists of sObject records by declaring *criteria* that records have to match. There are two available types of filters:

1. **field matching filter** matches against any number of field criteria 
2. **object matching filter** matches against a *prototype* record

Once criteria are defined, there are three possible *behaviours* of the filter against a list:

1. `apply` returns matching elements as a new list, without modifying the original list.
2. `applyLazy` does the same as `apply` but returns an `Iterable<sObject>` instead.
3. `extract` returns matching elements as a new list, and also removes them from the original list.

### Field matching filter

* `equals(Object value)` (alias `eq`)
* `notEquals(Object value)` (alias `neq`)
* `lessThan(Object value)` (alias`lt`)
* `lessThanOrEquals(Object value)` (alias`leq`)
* `greaterThan(Object value)` (alias `gt`)
* `greaterThanOrEquals(Object value)` (alias`geq`)
* `isIn(Object setValue)`
* `isNotIn(Object setValue)` (alias `notIn`)
* `hasValue` (alias `notNull`)

Matches against field criteria.

```java
// Accounts with annual revenue under 100,000 are matched
List<Account> lowRevenue = Filter.field(Account.AnnualRevenue).lessThanOrEquals(100000).apply(accounts);
```

Multiple criteria can be stringed together with `also` to form the full query. Records have to match *all* criteria.

```java
// Accounts named 'Test' with annual revenue under 100,000 are matched
List<Account> filtered = Filter.field(Account.AnnualRevenue).lessThanOrEquals(100000)
                               .also(Account.Name).equals('Test')
                               .apply(accounts);
```

### Object matching filter

Matches list records against a “prototype” object. A list record is a match if all the fields which are defined on the prototype object are equal to those on the list record.

```java
// Accounts named 'Test' with an AnnualRevenue of **exactly** 50,000,000 are matched
Account prototype = new Account(
    Name = 'Test',
    AnnualRevenue = 50000000
);
List<Account> filtered = Filter.match(prototype).apply(accounts);
```
### :warning: Warning

Most criteria expect a primitive value to compare against. `isIn` and `isNotIn` instead expect a `Set` of one of the following types: `Boolean`, `Date`, `Decimal`, `Double`, `Id`, `Integer` or `String`. **Other types are not supported and will throw an exception**.

Fields used in field criteria must be available on the list which is filtered, otherwise a `System.SObjectException: SObject row was retrieved via SOQL without querying the requested field` exception can be thrown. 

Fields that are present on the *prototype* object must also be available on the list which is filtered, otherwise a `System.SObjectException: SObject row was retrieved via SOQL without querying the requested field` exception will be thrown.

Filtering query is dynamic and cannot be type-checked at compile-time.

## `Pluck`
<a name="pluck"></a>

* `booleans(List<SObject>, Schema.SObjectField)`
* `dates(List<SObject>, Schema.SObjectField)`
* `decimals(List<SObject>, Schema.SObjectField)`
* `ids(List<SObject>)` (shorthand version which defaults to the system `Id` field)
* `ids(List<SObject>, Schema.SObjectField)` 
* `strings(List<SObject>, Schema.SObjectField)`

Plucks field values from a list of sObjects into a new list.

```java
List<Account> accounts = [Select Name,... from Account where ...];
// Pluck names into a new list
List<String> names = Pluck.strings(accounts, Account.Name);
```

### :warning: Warning

The `ids` method returns a set instead of a list because `Id` values are rarely required in order. If they are, `strings` can be used on `Id` fields instead:

```java
Set<Id> ownerIds = Pluck.ids(accounts, Account.OwnerId);
// equivalent data in list form
List<String> ownerIds = Pluck.strings(accounts, Account.OwnerId);
```

## `GroupBy`
<a name="group-by"></a>

* `booleans(List<SObject>, Schema.SObjectField)`
* `dates(List<SObject>, Schema.SObjectField)`
* `decimals(List<SObject>, Schema.SObjectField)`
* `ids(List<SObject>, Schema.SObjectField)`
* `strings(List<SObject>, Schema.SObjectField)`

Groups objects by values on a specified field.

```java
Map<String, List<Account>> accountsByName = GroupBy.strings(accounts, Account.Name);
```

### :warning: Warning

**The type system will NOT warn you if you use the wrong subtype of `sObject`!** [Important notes on the type system in Apex](#type-system) section explains why.

```java
// this compiles
Map<String, List<Account>> accountsByName = GroupBy.strings(accounts, Account.Name);
// this compiles as well!!!???
Map<String, List<Opportunity>> accountsByName = GroupBy.strings(accounts, Account.Name);
```

## Important notes on the type system in Apex
<a name="type-system"></a>

Apex allows assignment of `SObject` collection to its “subclass”, and the other way around:

```java
List<SObject> objects = new List<SObject>();
List<Account> accounts = objects; // compiles!

List<Account> accounts = new List<Account>();
List<SObject> objects = accounts; // compiles as well!
```

An `SObject` list is an instance of any `SObject` “subclass” list!

```java
List<SObject> objects = new List<SObject>();
System.debug(objects instanceof List<Account>); // true
System.debug(objects instanceof List<Opportunity>); // true
```

Lambda classes usually return an `SObject` list, which can be then assigned to a specific `SObject` “subclass” list, like `Account`. This is more convenient, but `instanceof` can provide unexpected results:

```java
List<Account> accounts = Filter...
// accounts points to a List<SObject> returned from Filter

Boolean isOpportunities = accounts instanceof List<Opportunity>;
// isOpportunities is true!!!???
```

When you want to be sure that your `List<SomeObject>` will behave like `List<SomeObject>` in all situations, you could explicitly cast to that. Example:

```java
List<SomeObject> someList = (List<SomeObject>) Filter. ...
```

However, Apex does not allow you to cast from `Map<String, List<SObject>>` to a `Map<String, List<Account>>`.

```java
// this doesn't compile!!!
Map<String, List<Account>> accountsByName = (Map<String, List<Account>>) GroupBy.strings(accounts, Account.Name);
```

`Filter` and `GroupBy` therefore provide overloaded methods in which the concrete type of the list can be passed in as well. When this is done, the returned `List` or `Map` are of the correct concrete type instead of generic `SObject` collection type:

```java
List<Account> filteredAccounts = Filter.field(...).apply(allAccounts, List<Account>.class);
// List<Account> returned!

Map<String, List<Account>> accountsByName = GroupBy.strings(allAccounts, Account.Name, List<Account>.class);
// Map<String, List<Account>> returned!
```