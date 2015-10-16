global class FieldFilterQuery extends FilterQuery {

	private List<TokenCriterium> queryCriteria = new List<TokenCriterium>();
	private PrimitiveComparer comparer = new PrimitiveComparer();

	public FieldFilterQuery addCriterium(Schema.SObjectField field, Comparison criterium, Object value) {
		this.queryCriteria.add(new TokenCriterium(field, criterium, value));
		return this;
	}

	global FieldFilterQueryElement field(Schema.SObjectField field) {
		return new FieldFilterQueryElement(this, field);
	}

	global FieldFilterQueryElement also(Schema.SObjectField field) {
		return this.field(field);
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
		}
		return isValid;
	}
}