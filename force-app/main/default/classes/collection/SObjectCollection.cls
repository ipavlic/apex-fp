public with sharing class SObjectCollection {

	private final List<SObject> records;
	private final SObjectFieldReader fieldReader;

	public static SObjectCollection of(Iterable<SObject> records) {
		return new SObjectCollection(records);
	}

	private SObjectCollection(Iterable<SObject> records) {
		this.records = new List<SObject>();
		this.fieldReader = new SObjectFieldReader();
		for (SObject record : records) {
			this.records.add(record);
		}
	}

	public Integer size() {
		return this.records.size();
	}

	public List<SObject> asList() {
		return new List<SObject>(this.records);
	}

	public List<SObject> asList(Type listType) {
		List<SObject> typedList = (List<SObject>) listType.newInstance();
		typedList.addAll(this.records);
		return typedList;
	}

	public Map<Id, SObject> asMap() {
		return new Map<Id, SObject>(this.records);
	}

	public Map<Id, SObject> asMap(Type mapType) {
		Map<Id, SObject> typedMap = (Map<Id, SObject>) mapType.newInstance();
		typedMap.putAll(this.records);
		return typedMap;
	}

	public SObjectCollection difference(SObjectCollection other, Set<Schema.SObjectField> comparisonFields) {
		List<SObject> different = new List<SObject>();
		if (other != null && !other.isEmpty() && !this.isEmpty()) {
			Map<Id, SObject> otherMap = new Map<Id, SObject>(other.records);
			for (SObject record : this.records) {
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
		return this.records.isEmpty();
	}

	public SObjectCollection filter(SObjectPredicate predicate) {
		List<SObject> filtered = new List<SObject>();
		for (SObject record : this.records) {
			if (predicate.call(record)) {
				filtered.add(record);
			}
		}
		return SObjectCollection.of(filtered);
	}

	public SObjectCollection remove(SObjectPredicate predicate) {
		List<SObject> remaining = new List<SObject>();
		for (SObject record : this.records) {
			if (!predicate.call(record)) {
				remaining.add(record);
			}
		}
		return SObjectCollection.of(remaining);
	}

	public List<Boolean> pluckBooleans(Schema.SObjectField field) {
		List<Boolean> results = new List<Boolean>();
		for (SObject rec : this.records) {
			results.add((Boolean) rec.get(field));
		}
		return results;
	}

	public List<Boolean> pluckBooleans(String relation) {
		List<Boolean> results = new List<Boolean>();
		for (SObject rec : this.records) {
			results.add((Boolean) this.fieldReader.read(rec, relation));
		}
		return results;
	}

	public List<Date> pluckDates(Schema.SObjectField field) {
		List<Date> results = new List<Date>();
		for (SObject rec : this.records) {
			results.add((Date) rec.get(field));
		}
		return results;
	}

	public List<Date> pluckDates(String relation) {
		List<Date> results = new List<Date>();
		for (SObject rec : this.records) {
			results.add((Date) this.fieldReader.read(rec, relation));
		}
		return results;
	}

	public List<Datetime> pluckDatetimes(Schema.SObjectField field) {
		List<Datetime> results = new List<Datetime>();
		for (SObject rec : this.records) {
			results.add((Datetime) rec.get(field));
		}
		return results;
	}

	public List<Datetime> pluckDatetimes(String relation) {
		List<Datetime> results = new List<Datetime>();
		for (SObject rec : this.records) {
			results.add((Datetime) this.fieldReader.read(rec, relation));
		}
		return results;
	}

	public List<Decimal> pluckDecimals(Schema.SObjectField field) {
		List<Decimal> results = new List<Decimal>();
		for (SObject rec : this.records) {
			results.add((Decimal) rec.get(field));
		}
		return results;
	}

	public List<Decimal> pluckDecimals(String relation) {
		List<Decimal> results = new List<Decimal>();
		for (SObject rec : this.records) {
			results.add((Decimal) this.fieldReader.read(rec, relation));
		}
		return results;
	}

	public List<Id> pluckIds() {
		List<Id> results = new List<Id>();
		for (SObject rec : this.records) {
			results.add(rec.Id);
		}
		return results;
	}

	public List<Id> pluckIds(Schema.SObjectField field) {
		List<Id> results = new List<Id>();
		for (SObject rec : this.records) {
			results.add((Id) rec.get(field));
		}
		return results;
	}

	public List<Id> pluckIds(String relation) {
		List<Id> results = new List<Id>();
		for (SObject rec : this.records) {
			results.add((Id) this.fieldReader.read(rec, relation));
		}
		return results;
	}

	public List<String> pluckStrings(Schema.SObjectField field) {
		List<String> results = new List<String>();
		for (SObject rec : this.records) {
			results.add((String) rec.get(field));
		}
		return results;
	}

	public List<String> pluckStrings(String relation) {
		List<String> results = new List<String>();
		for (SObject rec : this.records) {
			results.add((String) this.fieldReader.read(rec, relation));
		}
		return results;
	}

	public Map<Boolean, List<SObject>> groupByBooleans(String apiFieldName) {
		Map<Boolean, List<SObject>> grouped = new Map<Boolean, List<SObject>>();
		for (SObject rec : this.records) {
			Boolean key = (Boolean) rec.get(apiFieldName);
			if (!grouped.containsKey(key)) {
				grouped.put(key, new List<SObject>());
			}
			grouped.get(key).add(rec);
		}
		return grouped;
	}

	public Map<Boolean, List<SObject>> groupByBooleans(Schema.SObjectField field) {
		return groupByBooleans(field.getDescribe().getName());
	}

	public Map<Date, List<SObject>> groupByDates(String apiFieldName) {
		Map<Date, List<SObject>> grouped = new Map<Date, List<SObject>>();
		for (SObject rec : this.records) {
			Date key = (Date) rec.get(apiFieldName);
			if (!grouped.containsKey(key)) {
				grouped.put(key, new List<SObject>());
			}
			grouped.get(key).add(rec);
		}
		return grouped;
	}

	public Map<Date, List<SObject>> groupByDates(Schema.SObjectField field) {
		return groupByDates(field.getDescribe().getName());
	}

	public Map<Datetime, List<SObject>> groupByDatetimes(String apiFieldName) {
		Map<Datetime, List<SObject>> grouped = new Map<Datetime, List<SObject>>();
		for (SObject rec : this.records) {
			Datetime key = (Datetime) rec.get(apiFieldName);
			if (!grouped.containsKey(key)) {
				grouped.put(key, new List<SObject>());
			}
			grouped.get(key).add(rec);
		}
		return grouped;
	}

	public Map<Datetime, List<SObject>> groupByDatetimes(Schema.SObjectField field) {
		return groupByDatetimes(field.getDescribe().getName());
	}

	public Map<Decimal, List<SObject>> groupByDecimals(String apiFieldName) {
		Map<Decimal, List<SObject>> grouped = new Map<Decimal, List<SObject>>();
		for (SObject rec : this.records) {
			Decimal key = (Decimal) rec.get(apiFieldName);
			if (!grouped.containsKey(key)) {
				grouped.put(key, new List<SObject>());
			}
			grouped.get(key).add(rec);
		}
		return grouped;
	}

	public Map<Decimal, List<SObject>> groupByDecimals(Schema.SObjectField field) {
		return groupByDecimals(field.getDescribe().getName());
	}

	public Map<Id, List<SObject>> groupByIds(String apiFieldName) {
		Map<Id, List<SObject>> grouped = new Map<Id, List<SObject>>();
		for (SObject rec : this.records) {
			Id key = (Id) rec.get(apiFieldName);
			if (!grouped.containsKey(key)) {
				grouped.put(key, new List<SObject>());
			}
			grouped.get(key).add(rec);
		}
		return grouped;
	}

	public Map<Id, List<SObject>> groupByIds(Schema.SObjectField field) {
		return groupByIds(field.getDescribe().getName());
	}

	public Map<String, List<SObject>> groupByStrings(String apiFieldName) {
		Map<String, List<SObject>> grouped = new Map<String, List<SObject>>();
		for (SObject rec : this.records) {
			String key = (String) rec.get(apiFieldName);
			if (!grouped.containsKey(key)) {
				grouped.put(key, new List<SObject>());
			}
			grouped.get(key).add(rec);
		}
		return grouped;
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
		for (SObject record : this.records) {
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
		for (SObject record : this.records) {
			mapped.add(fn.call(record));
		}
		return SObjectCollection.of(mapped);
	}

	public ObjectCollection mapAll(SObjectToObjectFunction fn) {
		List<Object> mapped = new List<Object>();
		for (SObject record : this.records) {
			mapped.add(fn.call(record));
		}
		return ObjectCollection.of(mapped);
	}

	public SObjectCollection mapSome(SObjectPredicate predicate, SObjectToSObjectFunction fn) {
		List<SObject> transformed = new List<SObject>();
		for (SObject record : this.records) {
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
		for (SObject record : this.records) {
			decimals.add((Decimal) this.fieldReader.read(record, relation));
		}
		return DecimalCollection.of(decimals);
	}

	public DoubleCollection mapToDouble(Schema.SObjectField field) {
		return mapToDouble(field.getDescribe().getName());
	}

	public DoubleCollection mapToDouble(String relation) {
		List<Double> doubles = new List<Double>();
		for (SObject record : this.records) {
			doubles.add((Double) this.fieldReader.read(record, relation));
		}
		return DoubleCollection.of(doubles);
	}

	public OptionalSObject find(SObjectPredicate predicate) {
		for (SObject record : this.records) {
			if (predicate.call(record)) {
				return OptionalSObject.of(record);
			}
		}
		return OptionalSObject.empty();
	}

	public SObjectCollection forEach(SObjectFunction fn) {
		for (SObject record : this.records) {
			fn.call(record);
		}
		return this;
	}
}