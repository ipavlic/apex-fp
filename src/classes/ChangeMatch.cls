public class ChangeMatch implements SObjectPredicate {

	private Map<Id, SObject> other;
	private Set<String> fields = new Set<String>();


	// CONSTRUCTOR

	public ChangeMatch(Map<Id, SObject> other) {
		this.other = other;
	}


	// PUBLIC

	public ChangeMatch at(SObjectField field) {
		return at(''+field);
	}


	public ChangeMatch at(List<SObjectField> fields) {
		return at(nameList(fields));
	}


	public ChangeMatch at(String field) {
		fields.add(field);
		return this;
	}


	public ChangeMatch at(List<String> fields) {
		this.fields.addAll(fields);
		return this;
	}


	public Boolean apply(SObject record) {
		for (String field : fields) {
			if (record.get(field) != other.get(record.Id).get(field)) {
				return false;
			}
		}
		return true;
	}


	// PRIVATE

	private List<String> nameList(List<SObjectField> fields) {
		List<String> result = new List<String>();

		for(SObjectField f : fields) {
			result.add(''+f);
		}

		return result;
	}
}