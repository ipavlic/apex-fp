public class Criterium {
	
	public String field {get; set;}
	public Comparison criterium {get; set;}
	public Object value {get; set;}

	public Criterium(String field, Comparison criterium, Object value) {
		this.field = field;
		this.criterium = criterium;
		this.value = value;
	}
}