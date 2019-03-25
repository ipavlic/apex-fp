public with sharing class Collection {

	private List<SObject> records;

	public static Collection of(Iterable<SObject> records) {
		return new Collection(records);
	}

	public static Collection of(Set<SObject> records) {
		return new Collection(new List<SObject>(records));
	}

	private Collection(Iterable<SObject> records) {
		this.records = new List<SObject>();
		Iterator<SObject> iter = records.iterator();
		while (iter.hasNext()) {
			this.records.add(iter.next());
		}
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

	public Collection difference(Collection other, Set<Schema.SObjectField> comparisonFields) {
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
		return Collection.of(different);
	}

	public Boolean isEmpty() {
		return records.isEmpty();
	}

	public Collection filter(SObjectPredicate predicate) {
		List<SObject> filtered = new List<SObject>();
		for (SObject record : records) {
			if (predicate.apply(record)) {
				filtered.add(record);
			}
		}
		return Collection.of(filtered);
	}

	public Collection remove(SObjectPredicate predicate) {
		List<SObject> remaining = new List<SObject>();
		for (SObject record : records) {
			if (!predicate.apply(record)) {
				remaining.add(record);
			}
		}
		return Collection.of(remaining);
	}

	public List<Boolean> pluckBooleans(Schema.SObjectField field) {
		List<Boolean> results = new List<Boolean>();
		for (SObject rec : records) {
			results.add((Boolean)rec.get(field));
		}
		return results;
	}

	public List<Boolean> pluckBooleans(String relation) {
		List<Boolean> results = new List<Boolean>();
		SObjectFieldReader reader = new SObjectFieldReader();
		for (SObject rec : records) {
			results.add((Boolean)reader.read(rec, relation));
		}
		return results;
	}

	public List<Date> pluckDates(Schema.SObjectField field) {
		List<Date> results = new List<Date>();
		for (SObject rec : records) {
			results.add((Date)rec.get(field));
		}
		return results;
	}

	public List<Date> pluckDates(String relation) {
		List<Date> results = new List<Date>();
		SObjectFieldReader reader = new SObjectFieldReader();
		for (SObject rec : records) {
			results.add((Date)reader.read(rec, relation));
		}
		return results;
	}

	public List<Datetime> pluckDatetimes(Schema.SObjectField field) {
		List<Datetime> results = new List<Datetime>();
		for (SObject rec : records) {
			results.add((Datetime)rec.get(field));
		}
		return results;
	}

	public List<Datetime> pluckDatetimes(String relation) {
		List<Datetime> results = new List<Datetime>();
		SObjectFieldReader reader = new SObjectFieldReader();
		for (SObject rec : records) {
			results.add((Datetime)reader.read(rec, relation));
		}
		return results;
	}

	public List<Decimal> pluckDecimals(Schema.SObjectField field) {
		List<Decimal> results = new List<Decimal>();
		for (SObject rec : records) {
			results.add((Decimal)rec.get(field));
		}
		return results;
	}

	public List<Decimal> pluckDecimals(String relation) {
		List<Decimal> results = new List<Decimal>();
		SObjectFieldReader reader = new SObjectFieldReader();
		for (SObject rec : records) {
			results.add((Decimal)reader.read(rec, relation));
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
			results.add((Id)rec.get(field));
		}
		return results;
	}

	public List<Id> pluckIds(String relation) {
		List<Id> results = new List<Id>();
		SObjectFieldReader reader = new SObjectFieldReader();
		for (SObject rec : records) {
			results.add((Id)reader.read(rec, relation));
		}
		return results;
	}

	public List<String> pluckStrings(Schema.SObjectField field) {
		List<String> results = new List<String>();
		for (SObject rec : records) {
			results.add((String)rec.get(field));
		}
		return results;
	}

	public List<String> pluckStrings(String relation) {
		List<String> results = new List<String>();
		SObjectFieldReader reader = new SObjectFieldReader();
		for (SObject rec : records) {
			results.add((String) reader.read(rec, relation));
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

	public Collection pick(List<Schema.SObjectField> fields) {
		return pick(new Set<Schema.SObjectField>(fields));
	}

	public Collection pick(Set<Schema.SObjectField> fields) {
		Set<String> fieldNames = new Set<String>();
		for (Schema.SObjectField field : fields) {
			Schema.DescribeFieldResult describe = field.getDescribe();
			fieldNames.add(describe.getName());
		}
		return pick(fieldNames);
	}

	public Collection pick(Set<String> apiFieldNames) {
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
		return Collection.of(picked);
	}

	public Collection pick(List<String> apiFieldNames) {
		return pick(new Set<String>(apiFieldNames));
	}

	public Collection mapAll(SObjectToSObjectFunction fn) {
		List<SObject> mapped = new List<SObject>();
		for (SObject record : records) {
			mapped.add(fn.apply(record));
		}
		return Collection.of(mapped);
	}

	public Collection mapSome(SObjectPredicate predicate, SObjectToSObjectFunction fn) {
		List<SObject> transformed = new List<SObject>();
		for (SObject record : records) {
			if (predicate.apply(record)) {
				transformed.add(fn.apply(record));
			} else {
				transformed.add(record);
			}
		}
		return Collection.of(transformed);
	}

	public DecimalCollection mapToDecimal(Schema.SObjectField field) {
		return mapToDecimal(field.getDescribe().getName());
	}

	public DecimalCollection mapToDecimal(String relation) {
		SObjectFieldReader reader = new SObjectFieldReader();
		List<Decimal> decimals = new List<Decimal>();
		for (SObject record : records) {
			decimals.add((Decimal) reader.read(record, relation));
		}
		return new DecimalCollection(decimals);
	}

	public DoubleCollection mapToDouble(Schema.SObjectField field) {
		return mapToDouble(field.getDescribe().getName());
	}

	public DoubleCollection mapToDouble(String relation) {
		SObjectFieldReader reader = new SObjectFieldReader();
		List<Double> doubles = new List<Double>();
		for (SObject record : records) {
			doubles.add((Double) reader.read(record, relation));
		}
		return new DoubleCollection(doubles);
	}
    
    public static void Sort(List<sObject> items, sObjectField field)
    {
        integer min_index;
        integer listSize = items.size();
        
        Schema.DisplayType dt = field.getDescribe().getType();
        
        for (integer index = 0; index < listSize - 1; index++) 
        { 
            min_index = index; 
            
            for (integer nextIndex = index + 1; nextIndex < listSize; nextIndex++) 
            {
                if(dt == Schema.DisplayType.CURRENCY)
                {
                    if ((double)items[nextIndex].get(field) < (double)items[min_index].get(field)) 
                    {
                        min_index = nextIndex; 
                    }
                }
                else if(dt == Schema.DisplayType.DATE)
                {
                    if ((date)items[nextIndex].get(field) < (date)items[min_index].get(field)) 
                    {
                        min_index = nextIndex; 
                    }
                }
                else if(dt == Schema.DisplayType.DATETIME)
                {
                    if ((datetime)items[nextIndex].get(field) < (datetime)items[min_index].get(field)) 
                    {
                        min_index = nextIndex; 
                    }
                }
                else if(dt == Schema.DisplayType.DOUBLE)
                {
                    if ((double)items[nextIndex].get(field) < (double)items[min_index].get(field)) 
                    {
                        min_index = nextIndex; 
                    }
                }
                else if(dt == Schema.DisplayType.INTEGER)
                {
                    if ((integer)items[nextIndex].get(field) < (integer)items[min_index].get(field)) 
                    {
                        min_index = nextIndex; 
                    }
                }
                else if(dt == Schema.DisplayType.LONG)
                {
                    if ((long)items[nextIndex].get(field) < (long)items[min_index].get(field)) 
                    {
                        min_index = nextIndex; 
                    }
                }
                else if(dt == Schema.DisplayType.STRING)
                {
                    if ((string)items[nextIndex].get(field) < (string)items[min_index].get(field)) 
                    {
                        min_index = nextIndex; 
                    }
                }
                else
                {
                    // we can catch the rest as STRING, will not get the best result but better than no sorting
                    // can be implemented as types are discovered
                    if ((string)items[nextIndex].get(field) < (string)items[min_index].get(field)) 
                    {
                        min_index = nextIndex; 
                    }
                }
            }

            swap(items, min_index, index); 
        } 
    }
    
    private static List<object> Swap(List<object> items, integer x, integer y)
    {
        object tmp = items[x];
        items[x] = items[y];
        items[y] = tmp;
        
        return items;
    }
}