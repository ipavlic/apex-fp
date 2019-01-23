public with sharing class Collection {

	private List<SObject> records;


	// CONSTRUCT

	public static Collection of(Iterable<SObject> records) {
		return new Collection(records);
	}


	public static Collection of(Set<SObject> records) {
		return new Collection(new List<SObject>(records));
	}


	private Collection(Iterable<SObject> records) {
		this.records = new List<SObject>();

		Iterator<SObject> iter = records.iterator();

		while(iter.hasNext()) {
			this.records.add(iter.next());
		}
	}


	// CONVERT

	public List<SObject> asList() {
		return new List<SObject>(records);
	}


	public List<SObject> asList(Type listType) {
		List<SObject> typedList =(List<SObject>) listType.newInstance();
		typedList.addAll(records);
		return typedList;
	}


	public Set<SObject> asSet() {
		return new Set<SObject>(records);
	}


	public Set<SObject> asSet(Type setType) {
		Set<SObject> typedSet =(Set<SObject>) setType.newInstance();
		typedSet.addAll(records);
		return typedSet;
	}


	public Map<Id, SObject> asMap() {
		return new Map<Id, SObject>(records);
	}


	public Map<Id, SObject> asMap(Type mapType) {
		Map<Id, SObject> typedMap =(Map<Id, SObject>) mapType.newInstance();
		typedMap.putAll(records);
		return typedMap;
	}


	// FILTER

	public Collection filter(SObjectPredicate predicate) {
		List<SObject> result = new List<SObject>();

		for(SObject record : records) {
			if(predicate.apply(record)) {
				result.add(record);
			}
		}

		return Collection.of(result);
	}


	public Collection remove(SObjectPredicate predicate) {
		List<SObject> result = new List<SObject>();

		for(SObject record : records) {
			if(!predicate.apply(record)) {
				result.add(record);
			}
		}

		return Collection.of(result);
	}


	// EXTRACT

	public List<Boolean> booleans(String fieldPath) {
		List<Boolean> result = new List<Boolean>();

		SObjectFieldReader reader = new SObjectFieldReader();

		for(SObject record : records) {
			result.add((Boolean)reader.read(record, fieldPath));
		}

		return result;
	}


	public List<Boolean> booleans(SObjectField field) {
		return booleans(''+field);
	}


	public Set<Boolean> booleanSet(SObjectField field) {
		return new Set<Boolean>( booleans(field) );
	}


	public Set<Boolean> booleanSet(String fieldPath) {
		return booleanSet('' + fieldPath);
	}


	public List<Date> dates(String fieldPath) {
		List<Date> result = new List<Date>();

		SObjectFieldReader reader = new SObjectFieldReader();

		for(SObject record : records) {
			result.add((Date)reader.read(record, fieldPath));
		}

		return result;
	}


	public List<Date> dates(SObjectField field) {
		return dates(''+field);
	}


	public Set<Date> dateSet(String field) {
		return new Set<Date>(dates(field));
	}


	public Set<Date> dateSet(SObjectField field) {
		return dateSet('' + field);
	}


	public List<Datetime> datetimes(String fieldPath) {
		List<Datetime> result = new List<Datetime>();

		SObjectFieldReader reader = new SObjectFieldReader();

		for(SObject record : records) {
			result.add((Datetime)reader.read(record, fieldPath));
		}

		return result;
	}


	public List<Datetime> datetimes(SObjectField field) {
		return datetimes('' + field);
	}


	public Set<Datetime> datetimeSet(String field) {
		return new Set<Datetime>(datetimes(field));
	}


	public Set<Datetime> datetimeSet(SObjectField field) {
		return datetimeSet('' + field);
	}


	public List<Decimal> decimals(String fieldPath) {
		List<Decimal> result = new List<Decimal>();

		SObjectFieldReader reader = new SObjectFieldReader();

		for(SObject record : records) {
			result.add((Decimal)reader.read(record, fieldPath));
		}

		return result;
	}


	public List<Decimal> decimals(SObjectField field) {
		return decimals(''+field);
	}


	public Set<Decimal> decimalSet(String field) {
		return new Set<Decimal>(decimals(field));
	}


	public Set<Decimal> decimalSet(SObjectField field) {
		return decimalSet(''+field);
	}


	public List<Id> ids(String fieldPath) {
		List<Id> result = new List<Id>();

		SObjectFieldReader reader = new SObjectFieldReader();

		for(SObject record : records) {
			result.add((Id) reader.read(record, fieldPath));
		}

		return result;
	}

	public List<Id> ids() {
		return ids('Id');
	}


	public List<Id> ids(SObjectField field) {
		return ids(''+field);
	}


	public Set<Id> idSet() {
		return idSet('Id');
	}


	public Set<Id> idSet(String field) {
		return new Set<Id>(ids(field));
	}


	public Set<Id> idSet(SObjectField field) {
		return idSet(''+field);
	}


	public List<String> strings(SObjectField field) {
		return strings(''+field);
	}


	public List<String> strings(String fieldPath) {
		List<String> result = new List<String>();

		SObjectFieldReader reader = new SObjectFieldReader();

		for(SObject record : records) {
			result.add((String) reader.read(record, fieldPath));
		}

		return result;
	}


	public Set<String> stringSet(String field) {
		return new Set<String>(strings(field));
	}


	public Set<String> stringSet(SObjectField field) {
		return stringSet(''+field);
	}


	// GROUP

	public Map<Boolean, List<SObject>> groupByBooleans(SObjectField field) {
		return groupByBooleans(''+field);
	}


	public Map<Boolean, List<SObject>> groupByBooleans(String field) {
		return groupByBooleans(field, List<SObject>.class);
	}


	public Map<Boolean, List<SObject>> groupByBooleans(SObjectField field, Type listType) {
		return groupByBooleans(''+field, listType);
	}


	public Map<Boolean, List<SObject>> groupByBooleans(String field, Type listType) {
		Map<Object, List<SObject>> result = groupByObjects(field, Boolean.class, listType);
		return (Map<Boolean, List<SObject>>) JSON.deserialize(JSON.serialize(result), Map<Boolean, List<SObject>>.class);
	}


	public Map<Datetime, List<SObject>> groupByDatetimes(SObjectField field) {
		return groupByDatetimes(''+field);
	}


	public Map<Datetime, List<SObject>> groupByDatetimes(String field) {
		return groupByDatetimes(field, List<SObject>.class);
	}


	public Map<Datetime, List<SObject>> groupByDatetimes(SObjectField field, Type listType) {
		return groupByDatetimes(''+field, listType);
	}


	public Map<Datetime, List<SObject>> groupByDatetimes(String field, Type listType) {
		Map<Object, List<SObject>> result = groupByObjects(field, Datetime.class, listType);
		return (Map<Datetime, List<SObject>>) JSON.deserialize(JSON.serialize(result), Map<Datetime, List<SObject>>.class);
	}


	public Map<Date, List<SObject>> groupByDates(SObject field) {
		return groupByDates(''+field);
	}


	public Map<Date, List<SObject>> groupByDates(String field) {
		return groupByDates(field, List<SObject>.class);
	}


	public Map<Date, List<SObject>> groupByDates(SObjectField field, Type listType) {
		return groupByDates(''+field, listType);
	}


	public Map<Date, List<SObject>> groupByDates(String field, Type listType) {
		Map<Object, List<SObject>> result = groupByObjects(field, Date.class, listType);
		return (Map<Date, List<SObject>>) JSON.deserialize(JSON.serialize(result), Map<Date, List<SObject>>.class);
	}


	public Map<Decimal, List<SObject>> groupByDecimals(SObjectField field) {
		return groupByDecimals(''+field);
	}


	public Map<Decimal, List<SObject>> groupByDecimals(String field) {
		return groupByDecimals(field, List<SObject>.class);
	}


	public Map<Decimal, List<SObject>> groupByDecimals(SObjectField field, Type listType) {
		return groupByDecimals(''+field, listType);
	}


	public Map<Decimal, List<SObject>> groupByDecimals(String field, Type listType) {
		Map<Object, List<SObject>> result = groupByObjects(field, Decimal.class, listType);
		return (Map<Decimal, List<SObject>>) JSON.deserialize(JSON.serialize(result), Map<Decimal, List<SObject>>.class);
	}


	public Map<Id, List<SObject>> groupByIds(SObjectField field) {
		return groupByIds(''+field);
	}


	public Map<Id, List<SObject>> groupByIds(String field) {
		return groupByIds(field, List<SObject>.class);
	}


	public Map<Id, List<SObject>> groupByIds(SObjectField field, Type listType) {
		return groupByIds(''+field, listType);
	}


	public Map<Id, List<SObject>> groupByIds(String field, Type listType) {
		Map<Object, List<SObject>> result = groupByObjects(field, Id.class, listType);
		return (Map<Id, List<SObject>>) JSON.deserialize(JSON.serialize(result), Map<Id, List<SObject>>.class);
	}


	public Map<String, List<SObject>> groupByStrings(SObjectField field) {
		return groupByStrings(''+field);
	}


	public Map<String, List<SObject>> groupByStrings(String field) {
		return groupByStrings(field, List<SObject>.class);
	}


	public Map<String, List<SObject>> groupByStrings(SObjectField field, Type listType) {
		return groupByStrings(''+field, listType);
	}


	public Map<String, List<SObject>> groupByStrings(String field, Type listType) {
		Map<Object, List<SObject>> result = groupByObjects(field, String.class, listType);
		return (Map<String, List<SObject>>) JSON.deserialize(JSON.serialize(result), Map<String, List<SObject>>.class);
	}


	public Map<Object, List<SObject>> groupByObjects(String field, Type objectType, Type listType) {
		Map<Object, List<SObject>> result = new Map<Object, List<SObject>>();

		for(SObject record : records) {
			Object key = JSON.deserialize(JSON.serialize(record.get(field)), objectType);

			if(!result.containsKey(key)) {
				result.put(key,(List<SObject>) listType.newInstance());
			}

			result.get(key).add(record);
		}

		return result;
	}


	// PICK

	public Collection pick(List<SObjectField> fields) {
		return pick(stringList(fields));
	}


	public Collection pick(Set<SObjectField> fields) {
		return pick(new List<SObjectField>(fields));
	}

	public Collection pick(Set<String> fields) {
		List<SObject> picked = new List<SObject>();

		for(SObject record : records) {
			SObject result = record.getSObjectType().newSObject();
			Map<String, Object> fieldMap = record.getPopulatedFieldsAsMap();

			for(String fieldName : fields) {
				if(fieldMap.containsKey(fieldName)) {
					result.put(fieldName, record.get(fieldName));
				}
			}

			picked.add(result);
		}

		return Collection.of(picked);
	}


	public Collection pick(List<String> fields) {
		return pick(new Set<String>(fields));
	}


	// MAP

	public Collection mapAll(SObjectToSObjectFunction fn) {
		List<SObject> result = new List<SObject>();

		for(SObject record : records) {
			result.add(fn.apply(record));
		}

		return Collection.of(result);
	}


	public Collection mapSome(SObjectPredicate predicate, SObjectToSObjectFunction fn) {
		List<SObject> result = new List<SObject>();

		for(SObject record : records) {
			if(predicate.apply(record)) {
				result.add(fn.apply(record));
			}
			else {
				result.add(record);
			}
		}

		return Collection.of(result);
	}


	// PRIVATE

	private List<String> stringList(List<SObjectField> fields) {
		List<String> result = new List<String>();

		for(SObjectField f : fields) {
			result.add(''+f);
		}

		return result;
	}
}