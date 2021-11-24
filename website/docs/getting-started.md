---
sidebar_position: 1
slug: '/'
---

# Getting started

## Installation

<a href="https://githubsfdeploy.herokuapp.com?owner=ipavlic&repo=apex-fp&ref=master">
	<img alt="Deploy to Salesforce" src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png"></img>
</a>

**Project status**

![CI workflow](https://github.com/ipavlic/apex-fp/actions/workflows/ci.yml/badge.svg)
[![codecov](https://codecov.io/gh/ipavlic/apex-fp/branch/master/graph/badge.svg)](https://codecov.io/gh/ipavlic/apex-fp)

## Basic concepts

With Apex, we have to write imperative code in loops to transform data.

```apex title="Apex imperative style filtering"
List<Opportunity> opportunities = [SELECT ...];
List<Opportunity> largeOpportunities = new List<Opportunity>();
for (Opportunity opp : opportunities) {
	if (opp.Amount > 10000) {
		largeOpportunities.add(opp);
	}
}
```

**Apex FP** implements common operations on `SObject` instances, and allows functional (declarative) transformation of data. Here’s how filtering looks like with Apex FP:

```apex title="Apex FP declarative style filtering"
List<Opportunity> opportunities = [SELECT ...];
List<Opportunity> largeOpportunities = SObjectCollection.of(opportunities).filter(Fn.Match.field(Opportunity.Amount).greaterThan(10000)).asList();
```

To enable functional programming, Apex FP provides three things:
1. **Function interfaces**
2. **Function factories**
3. **Higher order functions**

### Function interfaces

First, Apex FP defines a reasonable set of **Function interfaces** for functions. Unlike most modern languages, Apex does not support functions as "first class citizens". Apex FP therefore provides interfaces for common classes of functions out of the box, like "functions that take an `SObject` and return a `Boolean`":

```apex title="apex-fp/main/classes/function/SObjectPredicate.cls"
public interface SObjectPredicate {
	Boolean call(SObject record);
}
```
or "functions that take an `SObject` and return an `SObject`":

```apex title="apex-fp/main/classes/function/SObjectToSObjectFunction.cls"
public interface SObjectToSObjectFunction {
	SObject call(SObject record);
}
```

### Function factories

Second, because we cannot define anonymous classes or functions in Apex, Apex FP provides **function factories** that can create common functions which respect Apex FP’s Function interfaces. For example, `Match` can be used to build a function which tests if a record matches some criteria.

```
SObjectPredicate isNameFoo = Fn.Match.field(Opportunity.Name).equals('Foo');
```

### Higher order functions

Finally, Apex FP provides classes with **higher order functions** as methods. Higher order functions are functions that take functions as arguments and use them to transform data.

The majority of higher order functions are provided by two main classes [`SObjectCollection`](api/collection/SObjectCollection), and [`SObjectStream`](api/stream/SObjectStream).

For example, they both have a `filter` method. It accepts a `SObjectPredicate` function instance and uses it to test whether records satisfy the predicate, and keeps just the ones that do. `filter` is therefore a higher order function.

```apex title="main/classes/collection/SObjectCollection.cls"
public class SObjectCollection {
	public SObjectCollection filter(SObjectPredicate predicate)
}
```
Another example is `mapAll` which accepts an `SObjectToSObjectFunction` instance and applies it to records in a collection to get new records.

```apex title="main/classes/collection/SObjectCollection.cls"
public class SObjectCollection {
	public SObjectCollection mapAll(SObjectToSObjectFunction fn)
}
```

You can use Apex FP’s function factories, write your own functions or mix and match.

:::info

`SObjectCollection` transforms data **eagerly**, while `SObjectStream` does so **lazily**. What’s the difference?

Imagine we’re looking for a first opportunity that has a large amount. We could use `filter` to filter those opportunities that have a large amount and then take the first one.

`SObjectCollection` would first check the entire list of opportunities to find all opportunties that are larger than a certain amount, and then take the first one out of them. `SObjectCollection` is more convenient to use, but it might not be as performant for large datasets if we are looking for one or a couple of elements from the filtered collection. We can also use it as many times as we like.

With `SObjectStream`, we iterate through the stream to check one opportunity at a time, and as soon as we find a large opportunity, we can stop checking. `SObjectStream` requires some additional effort to iterate through records. We can also only use it once. After it’s consumed, we have to recreate it.
:::

### Putting it all together

With **Function interfaces**, **function factories** and a nice set of classes for working with `SObject` collections with **higher order functions** , we finally get to data transformation expressions like:

```
List<Opportunity> largeOpportunities = SObjectCollection.of(opportunities).filter(Fn.Match.field(Opportunity.Amount).greaterThan(10000)).asList();
```