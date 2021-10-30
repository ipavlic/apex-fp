# ObjectCollection

## asList

Returns objects in the collection as a list.

**Signature**

```
List<Object> asList(Type listType)
```

**Example**
```apex title="Mapping to objects with MapTo function factory"
List<OpportunityAction> actions = (List<OpportunityAction>) SObjectCollection.of(opps)
    .mapAll(
        Fn.MapTo(OpportunityAction.class)
            .mapField('oppId', Opportunity.Id)
            .setField('action', 'follow up')
            .setField('createdAt', Datetime.now())
    ).asList(List<OpportunityAction>.class);
```

## asSet

Returns objects in the collection as a set.

**Signature**

```
Set<Object> asSet(Type listType)
```