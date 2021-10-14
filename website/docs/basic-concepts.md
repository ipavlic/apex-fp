---
sidebar_position: 1
slug: '/'
---

# Basic concepts

Apex is a very static language. There is a very small surface of the language where something dynamic can happen and it’s mostly related to the `SObject` class which is a syntactic sugar over a `Map<String, Object>`. With Apex, we have to write imperative code in loops to transform data.

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
List<Opportunity> largeOpportunities = SObjectCollection.of(opportunities).filter(Match.field(Opportunity.Amount).greaterThan(10000));
```

To enable functional programming, Apex FP provides three things:
1. **Functional interfaces** 
2. **Function factories**
3. **Higher order functions**

## Functional interfaces

First, Apex FP defines a reasonable set of **functional interfaces** for functions. Unlike most modern languages, Apex does not support functions as "first class citizens". Apex FP therefore provides interfaces for common classes of functions out of the box, like "functions that take an `SObject` and return a `Boolean`":

```apex title="apex-fp/main/classes/function/SObjectPredicate.cls"
public interface SObjectPredicate {
	Boolean apply(SObject record);
}
```
or "functions that take an `SObject` and return an `SObject`":

```apex title="apex-fp/main/classes/function/SObjectToSObjectFunction.cls"
public interface SObjectToSObjectFunction {
	SObject apply(SObject record);
}
```

## Function factories

Second, because we cannot define anonymous classes or functions in Apex, Apex FP provides **function factories** that can create common functions which respect Apex FP’s functional interfaces. For example, `Match` can be used to build a function which tests if a record matches some criteria.

```apex
SObjectPredicate isNameFoo = Match.field(Opportunity.Name).equals('Foo');
```

## Higher order functions

Finally, Apex FP provides classes with **higher order functions** as methods. Higher order functions are functions that take functions as arguments and use them to transform data. For example, `SObjectCollection` and `SObjectStream` both have a `filter` method. It accepts a `SObjectPredicate` function instance and uses it to test whether records satisfy the predicate, and keeps just the ones that do. `filter` is therefore a higher order function.

```apex title="main/classes/collection/SObjectCollection.cls"
public class SObjectCollection {
	public SObjectCollection filter(SObjectPredicate predicate)
}
```

You can use Apex FP’s function factories, write your own functions or mix and match.

## Putting it all together

With **functional interfaces**, **function factories** and a nice set of classes for working with `SObject` collections with **higher order functions** , we finally get to data transformation expressions like:

```apex
List<Opportunity> largeOpportunities = SObjectCollection.of(opportunities).filter(Match.field(Opportunity.Amount).greaterThan(10000)).asList();
``` 