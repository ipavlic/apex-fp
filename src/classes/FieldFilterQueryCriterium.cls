public class FieldFilterQueryCriterium {
	public String fieldRelation {get; set;}
	public Comparison criterium {get; set;}
	public Object value {get; set;}

	public FieldFilterQueryCriterium(String fieldRelation, Comparison criterium, Object value) {
		this.fieldRelation = fieldRelation;
		this.criterium = criterium;
		this.value = value;
	}
}