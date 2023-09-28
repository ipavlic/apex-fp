public with sharing class SObjectCollection {

	private List<SObject> records;
	private SObjectFieldReader fieldReader;

	public static SObjectCollection of(Iterable<SObject> records) {
		return new SObjectCollection(records);
	}

	private SObjectCollection(Iterable<SObject> records) {
		this.records = new List<SObject>();
		this.fieldReader = new SObjectFieldReader();
		Iterator<SObject> iter = records.iterator();
		while (iter.hasNext()) {
			this.records.add(iter.next());
		}
	}

	public Integer size() {
		return records.size();
	}

	public List<SObject> asList() {
		return new List<SObject>(records);
	}

	public List<SObject> asList(Type listType) {
		List<SObject> typedList = (List<SObject>) listType.newInstance();
		typedList.addAll(records);
		return typedList;
	}

	public Set<SObject> asSet() {
		return new Set<SObject>(records);
	}

	public Set<SObject> asSet(Type setType) {
		Set<SObject> typedSet = (Set<SObject>) setType.newInstance();
		typedSet.addAll(records);
		return typedSet;
	}

	public Map<Id, SObject> asMap() {
		return new Map<Id, SObject>(records);
	}

	public Map<Id, SObject> asMap(Type mapType) {
		Map<Id, SObject> typedMap = (Map<Id, SObject>) mapType.newInstance();
		typedMap.putAll(records);
		return typedMap;
	}

	public SObjectCollection difference(SObjectCollection other, Set<Schema.SObjectField> comparisonFields) {
		List<SObject> different = new List<SObject>();
		if (other != null && !other.isEmpty() && !this.isEmpty()) {
			Map<Id, SObject> otherMap = new Map<Id, SObject>(other.records);
			for (SObject record : records) {
				SObject counterpart = otherMap.get(record.Id);
				if (counterpart == null) {
					different.add(record);
				} else {
					for (Schema.SObjectField field : comparisonFields) {
						if (record.get(field) != counterpart.get(field)) {
							different.add(record);
							break;
						}
					}
				}
			}
		}
		return SObjectCollection.of(different);
	}

	public Boolean isEmpty() {
		return records.isEmpty();
	}

	public SObjectCollection filter(SObjectPredicate predicate) {
		List<SObject> filtered = new List<SObject>();
		for (SObject record : records) {
			if (predicate.call(record)) {
				filtered.add(record);
			}
		}
		return SObjectCollection.of(filtered);
	}

	public SObjectCollection remove(SObjectPredicate predicate) {
		List<SObject> remaining = new List<SObject>();
		for (SObject record : records) {
			if (!predicate.call(record)) {
				remaining.add(record);
			}
		}
		return SObjectCollection.of(remaining);
	}

	public List<Boolean> pluckBooleans(Schema.SObjectField field) {
		List<Boolean> results = new List<Boolean>();
		for (SObject rec : records) {
			results.add((Boolean) rec.get(field));
		}
		return results;
	}

	public List<Boolean> pluckBooleans(String relation) {
		List<Boolean> results = new List<Boolean>();
		for (SObject rec : records) {
			results.add((Boolean) fieldReader.read(rec, relation));
		}
		return results;
	}

	public List<Date> pluckDates(Schema.SObjectField field) {
		List<Date> results = new List<Date>();
		for (SObject rec : records) {
			results.add((Date) rec.get(field));
		}
		return results;
	}

	public List<Date> pluckDates(String relation) {
		List<Date> results = new List<Date>();
		for (SObject rec : records) {
			results.add((Date) fieldReader.read(rec, relation));
		}
		return results;
	}

	public List<Datetime> pluckDatetimes(Schema.SObjectField field) {
		List<Datetime> results = new List<Datetime>();
		for (SObject rec : records) {
			results.add((Datetime) rec.get(field));
		}
		return results;
	}

	public List<Datetime> pluckDatetimes(String relation) {
		List<Datetime> results = new List<Datetime>();
		for (SObject rec : records) {
			results.add((Datetime) fieldReader.read(rec, relation));
		}
		return results;
	}

	public List<Decimal> pluckDecimals(Schema.SObjectField field) {
		List<Decimal> results = new List<Decimal>();
		for (SObject rec : records) {
			results.add((Decimal) rec.get(field));
		}
		return results;
	}

	public List<Decimal> pluckDecimals(String relation) {
		List<Decimal> results = new List<Decimal>();
		for (SObject rec : records) {
			results.add((Decimal) fieldReader.read(rec, relation));
		}
		return results;
	}

	public List<Id> pluckIds() {
		List<Id> results = new List<Id>();
		for (SObject rec : records) {
			results.add(rec.Id);
		}
		return results;
	}

	public List<Id> pluckIds(Schema.SObjectField field) {
		List<Id> results = new List<Id>();
		for (SObject rec : records) {
			results.add((Id) rec.get(field));
		}
		return results;
	}

	public List<Id> pluckIds(String relation) {
		List<Id> results = new List<Id>();
		for (SObject rec : records) {
			results.add((Id) fieldReader.read(rec, relation));
		}
		return results;
	}

	public List<String> pluckStrings(Schema.SObjectField field) {
		List<String> results = new List<String>();
		for (SObject rec : records) {
			results.add((String) rec.get(field));
		}
		return results;
	}

	public List<String> pluckStrings(String relation) {
		List<String> results = new List<String>();
		for (SObject rec : records) {
			results.add((String) fieldReader.read(rec, relation));
		}
		return results;
	}

	public Map<Boolean, List<SObject>> groupByBooleans(String apiFieldName, Type listType) {
		Map<Boolean, List<SObject>> grouped = new Map<Boolean, List<SObject>>();
		for (SObject rec : records) {
			Boolean key = (Boolean) rec.get(apiFieldName);
			if (!grouped.containsKey(key)) {
				grouped.put(key, (List<SObject>) listType.newInstance());
			}
			grouped.get(key).add(rec);
		}
		return grouped;
	}

	public Map<Boolean, List<SObject>> groupByBooleans(String apiFieldName) {
		return groupByBooleans(apiFieldName, List<SObject>.class);
	}

	public Map<Boolean, List<SObject>> groupByBooleans(Schema.SObjectField field, Type listType) {
		return groupByBooleans(field.getDescribe().getName(), listType);
	}

	public Map<Boolean, List<SObject>> groupByBooleans(Schema.SObjectField field) {
		return groupByBooleans(field.getDescribe().getName());
	}

	public Map<Date, List<SObject>> groupByDates(String apiFieldName, Type listType) {
		Map<Date, List<SObject>> grouped = new Map<Date, List<SObject>>();
		for (SObject rec : records) {
			Date key = (Date) rec.get(apiFieldName);
			if (!grouped.containsKey(key)) {
				grouped.put(key, (List<SObject>) listType.newInstance());
			}
			grouped.get(key).add(rec);
		}
		return grouped;
	}

	public Map<Date, List<SObject>> groupByDates(String apiFieldName) {
		return groupByDates(apiFieldName, List<SObject>.class);
	}

	public Map<Date, List<SObject>> groupByDates(Schema.SObjectField field, Type listType) {
		return groupByDates(field.getDescribe().getName(), listType);
	}

	public Map<Date, List<SObject>> groupByDates(Schema.SObjectField field) {
		return groupByDates(field.getDescribe().getName());
	}

	public Map<Datetime, List<SObject>> groupByDatetimes(String apiFieldName, Type listType) {
		Map<Datetime, List<SObject>> grouped = new Map<Datetime, List<SObject>>();
		for (SObject rec : records) {
			Datetime key = (Datetime) rec.get(apiFieldName);
			if (!grouped.containsKey(key)) {
				grouped.put(key, (List<SObject>) listType.newInstance());
			}
			grouped.get(key).add(rec);
		}
		return grouped;
	}

	public Map<Datetime, List<SObject>> groupByDatetimes(String apiFieldName) {
		return groupByDatetimes(apiFieldName, List<SObject>.class);
	}

	public Map<Datetime, List<SObject>> groupByDatetimes(Schema.SObjectField field, Type listType) {
		return groupByDatetimes(field.getDescribe().getName(), listType);
	}

	public Map<Datetime, List<SObject>> groupByDatetimes(Schema.SObjectField field) {
		return groupByDatetimes(field.getDescribe().getName());
	}

	public Map<Decimal, List<SObject>> groupByDecimals(String apiFieldName, Type listType) {
		Map<Decimal, List<SObject>> grouped = new Map<Decimal, List<SObject>>();
		for (SObject rec : records) {
			Decimal key = (Decimal) rec.get(apiFieldName);
			if (!grouped.containsKey(key)) {
				grouped.put(key, (List<SObject>) listType.newInstance());
			}
			grouped.get(key).add(rec);
		}
		return grouped;
	}

	public Map<Decimal, List<SObject>> groupByDecimals(String apiFieldName) {
		return groupByDecimals(apiFieldName, List<SObject>.class);
	}

	public Map<Decimal, List<SObject>> groupByDecimals(Schema.SObjectField field, Type listType) {
		return groupByDecimals(field.getDescribe().getName(), listType);
	}

	public Map<Decimal, List<SObject>> groupByDecimals(Schema.SObjectField field) {
		return groupByDecimals(field.getDescribe().getName());
	}

	public Map<Id, List<SObject>> groupByIds(String apiFieldName, Type listType) {
		Map<Id, List<SObject>> grouped = new Map<Id, List<SObject>>();
		for (SObject rec : records) {
			Id key = (Id) rec.get(apiFieldName);
			if (!grouped.containsKey(key)) {
				grouped.put(key, (List<SObject>) listType.newInstance());
			}
			grouped.get(key).add(rec);
		}
		return grouped;
	}

	public Map<Id, List<SObject>> groupByIds(String apiFieldName) {
		return groupByIds(apiFieldName, List<SObject>.class);
	}

	public Map<Id, List<SObject>> groupByIds(Schema.SObjectField field, Type listType) {
		return groupByIds(field.getDescribe().getName(), listType);
	}

	public Map<Id, List<SObject>> groupByIds(Schema.SObjectField field) {
		return groupByIds(field.getDescribe().getName());
	}

	public Map<String, List<SObject>> groupByStrings(String apiFieldName, Type listType) {
		Map<String, List<SObject>> grouped = new Map<String, List<SObject>>();
		for (SObject rec : records) {
			String key = (String) rec.get(apiFieldName);
			if (!grouped.containsKey(key)) {
				grouped.put(key, (List<SObject>) listType.newInstance());
			}
			grouped.get(key).add(rec);
		}
		return grouped;
	}

	public Map<String, List<SObject>> groupByStrings(String apiFieldName) {
		return groupByStrings(apiFieldName, List<SObject>.class);
	}

	public Map<String, List<SObject>> groupByStrings(Schema.SObjectField field, Type listType) {
		return groupByStrings(field.getDescribe().getName(), listType);
	}

	public Map<String, List<SObject>> groupByStrings(Schema.SObjectField field) {
		return groupByStrings(field.getDescribe().getName());
	}

	public SObjectCollection pick(List<Schema.SObjectField> fields) {
		return pick(new Set<Schema.SObjectField>(fields));
	}

	public SObjectCollection pick(Set<Schema.SObjectField> fields) {
		Set<String> fieldNames = new Set<String>();
		for (Schema.SObjectField field : fields) {
			Schema.DescribeFieldResult describe = field.getDescribe();
			fieldNames.add(describe.getName());
		}
		return pick(fieldNames);
	}

	public SObjectCollection pick(Set<String> apiFieldNames) {
		List<SObject> picked = new List<SObject>();
		for (SObject record : records) {
			SObject result = record.getSObjectType().newSObject();
			Map<String, Object> fieldMap = record.getPopulatedFieldsAsMap();
			for (String fieldName : apiFieldNames) {
				if (fieldMap.containsKey(fieldName)) {
					result.put(fieldName, record.get(fieldName));
				}
			}
			picked.add(result);
		}
		return SObjectCollection.of(picked);
	}

	public SObjectCollection pick(List<String> apiFieldNames) {
		return pick(new Set<String>(apiFieldNames));
	}

	public SObjectCollection mapAll(SObjectToSObjectFunction fn) {
		List<SObject> mapped = new List<SObject>();
		for (SObject record : records) {
			mapped.add(fn.call(record));
		}
		return SObjectCollection.of(mapped);
	}

	public ObjectCollection mapAll(SObjectToObjectFunction fn) {
		List<Object> mapped = new List<Object>();
		for (SObject record : records) {
			mapped.add(fn.call(record));
		}
		return ObjectCollection.of(mapped);
	}

	public SObjectCollection mapSome(SObjectPredicate predicate, SObjectToSObjectFunction fn) {
		List<SObject> transformed = new List<SObject>();
		for (SObject record : records) {
			if (predicate.call(record)) {
				transformed.add(fn.call(record));
			} else {
				transformed.add(record);
			}
		}
		return SObjectCollection.of(transformed);
	}

	public DecimalCollection mapToDecimal(Schema.SObjectField field) {
		return mapToDecimal(field.getDescribe().getName());
	}

	public DecimalCollection mapToDecimal(String relation) {
		List<Decimal> decimals = new List<Decimal>();
		for (SObject record : records) {
			decimals.add((Decimal) fieldReader.read(record, relation));
		}
		return DecimalCollection.of(decimals);
	}

	public DoubleCollection mapToDouble(Schema.SObjectField field) {
		return mapToDouble(field.getDescribe().getName());
	}

	public DoubleCollection mapToDouble(String relation) {
		List<Double> doubles = new List<Double>();
		for (SObject record : records) {
			doubles.add((Double) fieldReader.read(record, relation));
		}
		return DoubleCollection.of(doubles);
	}

	public OptionalSObject find(SObjectPredicate predicate) {
		for (SObject record : records) {
			if (predicate.call(record)) {
				return OptionalSObject.of(record);
			}
		}
		return OptionalSObject.empty();
	}

	public SObjectCollection forEach(SObjectFunction fn) {
		for (SObject record : records) {
			fn.call(record);
		}
		return this;
	}
}