<p align="center">
  <h1 align="center"><img src="images/lambda.png" height="32"></h1>
</p>

Lambda provides functional constructs for `SObject` collections!

```apex
List<Account> accounts = new List<Account>{
    new Account(Name = 'Foo', AnnualRevenue = 50000),
    new Account(Name = 'Bar', AnnualRevenue = 30000)
}

Collection accountCollection = Collection.of(accounts);

Collection filtered = accountCollection.filter(Match.field(Account.AnnualRevenue).greaterThan(40000));
Collection mapped = filtered.mapAll(Transform.record(new Account(High_Value__c = true)));
Collection remaining = mapped.remove(Match.record(new Account(Name = 'Bar')));
```

<a href="https://githubsfdeploy.herokuapp.com?owner=ipavlic&repo=apex-lambda&ref=master">
  <img alt="Deploy to Salesforce" src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## `Collection` functions

- [`filter`](#filter)
- [`remove`](#remove)
- [`groupBy`](#group-by)
- [`pick`](#pick)
- [`pluck`](#pluck)
- [`mapAll`](#map-all)
- [`mapSome`](#map-some)

### `filter`
<a name="filter"></a>

| Modifier and type | Method | Description |
|-------------------|--------|-------------|
| `Collection` 		| `filter(SObjectPredicate predicate)` 			| Returns a `Collection` view of records that satisfied predicate |

Three predicates are provided out of the box, `FieldsMatch`, `RecordMatch` and `ChangeMatch`. They are instantiated through factory methods on `Match`:

```apex
Collection accountCollection = Collection.of(accounts);

Account prototype = new Account(Name = 'Foo');
Collection recordMatched = accountCollection.filter(Match.record(prototype));

Collection fieldMatched = accountCollection.filter(Match.field(Account.Name).equals('Foo'));
```

#### `FieldsMatch`

`FieldsMatch` returns `true` if a record satisfies all field matching conditions.

`FieldsMatch` is constructed with a fluent interface. `Match` factory method `field` returns an `IncompleteFieldsMatch`. 
`FieldsMatch` is obtained from the `IncompleteFieldsMatch` by providing a matching condition on the field. `FieldsMatch`
can be expanded with a new matching condition to get another `IncompleteFieldsMatch`. The process is continued until all 
desired matching conditions are defined.

```apex
FieldsMatch m = Match.field(Account.Name).equals('Foo').also(Account.AnnualRevenue).greaterThan(100000);
```

`FieldsMatch` can be provided directly to `filter` method:

```apex
Collection filtered = Collection.of(accounts).filter(Match.field(Account.Name).equals('Foo').also(Account.AnnualRevenue).greaterThan(100000));
```

##### `IncompleteFieldsMatch`

| Modifier and type | Method | Alias | Description |
|-------------------|--------|-------|-------------|
| `FieldsMatch` | `equals(Object value)`				| `eq` | Defines an equality comparison condition for the current field |
| `FieldsMatch` | `notEquals(Object value)`			| `neq` | Defines an inequality comparison condition for the current field |
| `FieldsMatch` | `lessThan(Object value)`				| `lt` | Defines a less than comparison condition for the current field |
| `FieldsMatch` | `lessThanOrEquals(Object value)` 	| `leq` | Defines a less than or equals condition for the current field |
| `FieldsMatch` | `greaterThan(Object value)`			| `gt` | Defines a greater than condition for the current field |
| `FieldsMatch` | `greaterThanOrEquals(Object value)`	| `geq` | Defines a greaterThanOrEquals condition for the current field |
| `FieldsMatch` | `isIn(Object value)` 				| 		| Defines a set membership condition for the current field |
| `FieldsMatch` | `isNotIn(Object value)` 				| `notIn` | Defines a set non-membership condition for the current field |
| `FieldsMatch` | `hasValue()` 						| `notNull` | Defines a non-null condition for the current field |

##### `FieldsMatch`

Additional conditions can be defined with `also`, or its alias, `field`:

| Modifier and type | Method | Alias | Description |
|-------------------|--------|-------|-------------|
| `IncompleteFieldsMatch` | `also(Schema.SObjectField field)` | `field` | Defines another condition to match |
| `IncompleteFieldsMatch` | `also(String fieldPath)` | `field` | Defines another condition to match |

##### Warning :warning:

`isIn` and `isNotIn` support a `Set` of one of the following types:

- `Boolean`
- `Date`
- `Datetime`
- `Decimal`
- `Double`
- `Id`
- `Integer`
- `Long`
- `String`

**Other types are not supported and will throw an exception**.

Fields used in field conditions must be available on the collection which is filtered, otherwise a `System.SObjectException: SObject row was retrieved via SOQL without querying the requested field` exception can be thrown.

#### `RecordMatch`

`RecordMatch` returns `true` if record fields are equal to those defined on a “prototype” record. Fields that are not
defined on a prototype record do not have to match.

```apex
Account prototype = new Account(
    Name = 'Test',
    AnnualRevenue = 50000000
);
// Accounts named 'Test' with an AnnualRevenue of **exactly** 50,000,000 are matched
Collection filtered = accountCollection.filter(Match.record(prototype));
```

##### Warning :warning:

Fields that are present on the *prototype* object must also be available on the collection which is filtered, otherwise a `System.SObjectException: SObject row was retrieved via SOQL without querying the requested field` exception will be thrown.

#### `ChangeMatch`

`ChangeMatch` compares two record lists and returns `true` if fields defined using the `at()` method have different values.
This can be used to detect changes in Triggers.

```apex
List<Account> old = Trigger.old;
List<Account> accounts = Trigger.new;

Collection.of(accounts).filter(Change.of(old).at(Account.Name));
Collection.of(accounts).filter(Change.of(old).at('RecordType'));
Collection.of(accounts).filter(Change.of(old).at(new List<SObjectField>{ Account.Name, Account.Phone }));

```

### `remove`
<a name="remove"></a>

`remove` works just like `filter`, but records which match a predicate are removed from the `Collection` view instead of kept.

### `pluck`
<a name="pluck"></a>

Plucks field values from a `Collection` view of records into a `List` of appropriate type.

```apex
List<Account> accounts = new List<Account>{
	new Account(Name = 'Foo'),
	new Account(Name = 'Bar')
}
// Names are plucked into a new list, ['Foo', 'Bar']
List<String> names = Collection.of(accounts).pluckStrings(Account.Name);
```

Pluck can also be used for deeper relations by using `String` field paths instead of `Schema.SObjectField` parameters.

```apex
List<Opportunity> opportunities = new List<Opportunity>{
	new Opportunity(Account = new Account(Name = 'Foo')),
	new Opportunity(Account = new Account(Name = 'Bar'))
};

// Names are plucked into a new list ['Foo', 'Bar']
List<String> accountNames = Collection.of(opportunities).pluckStrings('Account.Name');
```

| Modifier and type | Method | Description |
|-------------------|--------|-------------|
| `List<Boolean>` | `pluckBooleans(Schema.SObjectField)` | Plucks Boolean `field` values |
| `List<Boolean>` | `pluckBooleans(String relation)` | Plucks Boolean `relation` values |
| `List<Date>` | `pluckDates(Schema.SObjectField field)` | Plucks Date `field` values |
| `List<Date>` | `pluckDates(String relation)` | Plucks Date `relation` values |
| `List<Date>` | `pluckDatetimes(Schema.SObjectField field)` | Plucks Datetime `field` values |
| `List<Date>` | `pluckDatetimes(String relation)` | Plucks Datetime `relation` values |
| `List<Decimal>` | `pluckDecimals(Schema.SObjectField field)` | Plucks numerical `field` values |
| `List<Decimal>` | `pluckDecimals(Schema.SObjectField field)` | Plucks numerical `relation` values |
| `List<Id>` | `pluckIds(Schema.SObjectField field)` | Plucks Id `field` values |
| `List<Id>` | `pluckIds(String relation)` | Plucks Id `relation` values |
| `List<Id>` | `pluckIds()` | Plucks values of `Id` field |
| `List<String>` | `strings(Schema.SObjectField field)` | Plucks String or Id `field` values |
| `List<String>` | `strings(Schema.SObjectField relation)` | Plucks String or Ids `relation` values |

### `groupBy`
<a name="group-by"></a>

Groups records by values of a specified field.

```apex
Map<Date, List<Opportunity>> opportunitiesByCloseDate = Collection.of(opportunities).groupByDates(Opportunity.CloseDate, opportunities);
```

| Modifier and type | Method | Description |
|-------------------|--------|-------------|
| `Map<Boolean, List<SObject>>` | `groupByBooleans(Schema.SObjectField field)` | Groups records by Boolean `field` values |
| `Map<Boolean, List<SObject>>` | `groupByBooleans(Schema.SObjectField field, Type listType)` | Groups records by Boolean `field` values, with specified list type |
| `Map<Date, List<SObject>>` | `groupByDates(Schema.SObjectField field)` | Groups records by Date `field` values |
| `Map<Date, List<SObject>>` | `groupByDates(Schema.SObjectField field, Type listType)` | Groups records by Date `field` values, with specified list type |
| `Map<Date, List<SObject>>` | `groupByDatetimes(Schema.SObjectField field)` | Groups records by Datetime `field` values |
| `Map<Date, List<SObject>>` | `groupByDatetimes(Schema.SObjectField field, Type listType)` | Groups records by Datetime `field` values, with specified list type |
| `Map<Decimal, List<SObject>>` | `groupByDecimals(Schema.SObjectField field)` | Groups records by numeric `field` values |
| `Map<Decimal, List<SObject>>` | `groupByDecimals(Schema.SObjectField field, Type listType)` | Groups records by numeric `field` values, with specified list type |
| `Map<Id, List<SObject>>` | `groupByIds(Schema.SObjectField field)` | Groups records by Id `field` values |
| `Map<Id, List<SObject>>` | `groupByIds(Schema.SObjectField field, Type listType)` | Groups records by Id `field` values, with specified list type |
| `Map<String, List<SObject>>` | `groupByStrings(Schema.SObjectField field)` | Groups records by String `field` values |
| `Map<String, List<SObject>>` | `groupByStrings(Schema.SObjectField field, Type listType)` | Groups records by String `field` values, with specified list type |

### `pick`
<a name="pick"></a>

Returns a new `Collection` view of the collection which keeps just the specified fields, discarding others. Helps reduce overwriting potential for concurrent updates when locking is not an option.

```apex
List<Opportunity> opportunities = new List<Opportunity>{
	new Opportunity(Name = 'Foo', Amount = 10000, Description = 'Bar')
}
// Picked contains just Name and Amount fields. Description is not present.
Collection picked = Collection.of(opportunities).pick(new Set<String>{'Name', 'Amount'});
```

| Modifier and type | Method | Description |
|-------------------|--------|-------------|
| `Collection` | `pick(List<Schema.SObjectField> fields)` | Picks fields into a new `Collection` view |
| `Collection` | `pick(Set<Schema.SObjectField> fields)` | Picks fields into a new `Collection` view |
| `Collection` | `pick(List<String> apiFieldNames)` | Picks fields into a new `Collection` view |
| `Collection` | `pick(Set<String> apiFieldNames)` | Picks fields into a new `Collection` view |

### `mapAll`
<a name="map-all"></a>

Maps all elements of `Collection` view into another `Collection` view with the provided `SObjectToSObjectFunction` mapping function.

| Modifier and type | Method | Description |
|-------------------|--------|-------------|
| `Collection` | `mapAll(SObjectToSObjectFunction fn)` | Returns a new `Collection` view formed by mapping all current view elements with `fn` |


```apex
private class DoubleAmount implements SObjectToSObjectFunction {
    public SObject apply(SObject record) {
        record.put('Amount', 2 * (Decimal) record.get('Amount'));
        return record;
    }
}

List<Opportunity> opps = new List<Opportunity>{
    new Opportunity(Amount = 100),
    new Opportunity(Amount = 150)
};

Collection.of(opps).mapAll(new DoubleAmount()); // amounts have been doubled
```

One `SObjectToSObjectFunction` is provided out of the box, `RecordTransform`. It is instantiated through a factory method on `Transform`:

#### `RecordTransform`

`RecordTransform` copies all defined fields from `prototype` record to the record it is applied to. Values of fields defined for `prototype` are overwritten on
target records. Other fields on target record are not modified.

```apex
Collection.of(opps).mapAll(Transform.record(new Opportunity(Name = 'Test'))); // Name field has been overwritten with 'Test'
```

### `mapSome`
<a name="map-some"></a>

Returns a new `Collection` view formed by mapping those view elements that satisfy `predicate`, and keeping those that do not unchanged.

```apex
private class DoubleAmount implements SObjectToSObjectFunction {
    public SObject apply(SObject record) {
        record.put('Amount', 2 * (Decimal) record.get('Amount'));
        return record;
    }
}

List<Opportunity> opps = new List<Opportunity>{
    new Opportunity(Amount = 100),
    new Opportunity(Amount = 150)
};

Collection.of(opps).mapSome(Match.field('Amount').gt(120), new DoubleAmount()); // 100 remains, but 150 has been doubled to 300
```

| Modifier and type | Method | Description |
|-------------------|--------|-------------|
| `Collection` | `mapAll(SObjectToSObjectFunction fn)` | Returns a new `Collection` view formed by mapping current view elements that satisfy `predicate` with `fn`, and keeping those that do not satisfy `predicate` unchanged. |

## Important notes on the type system in Apex
<a name="type-system"></a>

Apex allows assignment of `SObject` collection to its “subclass”, and the other way around:

```apex
List<SObject> objects = new List<SObject>();
List<Account> accounts = objects; // compiles!

List<Account> accounts = new List<Account>();
List<SObject> objects = accounts; // compiles as well!
```

An `SObject` list is an instance of any `SObject` “subclass” list!

```apex
List<SObject> objects = new List<SObject>();
System.debug(objects instanceof List<Account>); // true
System.debug(objects instanceof List<Opportunity>); // true
```

Collection’s `asList()` and `asSet()` return a raw `List<SObject>` and `Set<SObject>`. This is more convenient, but `instanceof` can provide unexpected results.
A concrete type of the list can be passed in as well. When this is done, the returned `List` or `Set` are of the correct concrete type instead of generic `SObject` collection type:

```apex
List<Account> filteredAccounts = accountCollection.asList();
// List<SObject> returned!

List<Account> filteredAccounts = accountCollection.asList(List<Account>.class);
// List<Account> returned!
```
