public class FieldFilterQuery extends FilterQuery {
	private List<TokenCriterium> queryCriteria = new List<TokenCriterium>();
	private PrimitiveComparer comparer = new PrimitiveComparer();

	public FieldFilterQuery addCriterium(Schema.SObjectField field, Comparison criterium, Object value) {
		this.queryCriteria.add(new TokenCriterium(field, criterium, value));
		return this;
	}

	public FieldFilterQueryElement field(Schema.SObjectField field) {
		return new FieldFilterQueryElement(this, field);
	}

	public FieldFilterQueryElement also(Schema.SObjectField field) {
		return this.field(field);
	}

	private Boolean contains(Object valueSet, Object value) {
		if (valueSet instanceof Set<Boolean>) {
			Set<Boolean> booleans = (Set<Boolean>) valueSet;
			return booleans.contains((Boolean) value);
		} else if (valueSet instanceof Set<Decimal>) {
			Set<Decimal> decimals = (Set<Decimal>) valueSet;
			return decimals.contains((Decimal) value);
		} else if (valueSet instanceof Set<Id>) {
			Set<Id> ids = (Set<Id>) valueSet;
			return ids.contains((Id) value);
		} else if (valueSet instanceof Set<String>) {
			Set<String> strings = (Set<String>) valueSet;
			return strings.contains((String) value);
		}
		return false;
	}


	public override Boolean isValid (sObject obj) {
		Boolean isValid = true;
		for (TokenCriterium c : queryCriteria) {
			if (c.criterium == Comparison.EQUALS && comparer.compare(obj.get(c.field), c.value) != Comparison.EQUALS) {
	 			isValid = false;
				break;
			}
			if (c.criterium == Comparison.NOT_EQUALS && comparer.compare(obj.get(c.field), c.value) == Comparison.EQUALS) {
				isValid = false;
				break;
			}
			if (c.criterium == Comparison.LESS_THAN && comparer.compare(obj.get(c.field), c.value) != Comparison.LESS_THAN) {
				isValid = false;
				break;
			}
			if (c.criterium == Comparison.LESS_THAN_OR_EQUALS && (comparer.compare(obj.get(c.field), c.value) == Comparison.GREATER_THAN || comparer.compare(obj.get(c.field), c.value) == Comparison.NOT_EQUALS)) {
				isValid = false;
				break;
			}
			if (c.criterium == Comparison.GREATER_THAN && comparer.compare(obj.get(c.field), c.value) != Comparison.GREATER_THAN) {
				isValid = false;
				break;
			}
			if (c.criterium == Comparison.GREATER_THAN_OR_EQUALS && (comparer.compare(obj.get(c.field), c.value) == Comparison.LESS_THAN || comparer.compare(obj.get(c.field), c.value) == Comparison.NOT_EQUALS)) {
				isValid = false;
				break;
			}
			if (c.criterium == Comparison.IS_IN && (contains(c.value, obj.get(c.field)) == false)) {
				isValid = false;
				break;
			}
			if (c.criterium == Comparison.NOT_IN && (contains(c.value, obj.get(c.field)) == true)) {
				isValid = false;
				break;
			}
		}
		return isValid;
	}
}