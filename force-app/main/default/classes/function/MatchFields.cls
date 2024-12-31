public class MatchFields implements SObjectPredicate {

	private final List<MatchFieldCondition> conditions;

	public MatchFields() {
		this.conditions = new List<MatchFieldCondition>();
	}

	public MatchFields addCondition(MatchFieldCondition condition) {
		conditions.add(condition);
		return this;
	}

	public IncompleteMatchFields also(Schema.SObjectField field) {
		return field(field);
	}

	public IncompleteMatchFields also(String fieldPath) {
		return field(fieldPath);
	}

	public IncompleteMatchFields field(Schema.SObjectField field) {
		return new IncompleteMatchFields(this, field);
	}

	public IncompleteMatchFields field(String fieldPath) {
		return new IncompleteMatchFields(this, fieldPath);
	}

	public Boolean call(SObject record) {
		for (MatchFieldCondition condition : conditions) {
			if (!condition.isSatisfied(record)) {
				return false;
			}
		}
		return true;
	}
}