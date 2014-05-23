public class FieldFilterQuery extends FilterQuery {
	
	List<Criterium> queryCriteria = new List<Criterium>();
	PrimitiveComparer comparer = new PrimitiveComparer();

	public FieldFilterQuery addCriterium(String field, Comparison criterium, Object value) {
		this.queryCriteria.add(new Criterium(field, criterium, value));
		return this;
	}

	public FieldFilterQueryElement field(String field) {
		return new FieldFilterQueryElement(this, field);
	}

	public FieldFilterQueryElement also(String field) {
		return this.field(field);
	}
	
	public override Boolean isValid (sObject obj) {
		Boolean isValid = true;
		for (Criterium c : queryCriteria) {
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