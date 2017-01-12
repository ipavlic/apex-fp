public class TokenCriterium {
	
	public Schema.SObjectField field {get; set;}
	public Comparison criterium {get; set;}
	public Object value {get; set;}

	public TokenCriterium(Schema.SObjectField field, Comparison criterium, Object value) {
		this.field = field;
		this.criterium = criterium;
		this.value = value;
	}
}