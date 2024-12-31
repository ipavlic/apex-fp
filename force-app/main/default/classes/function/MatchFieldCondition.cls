public class MatchFieldCondition {

	public String fieldPath { get; set;}
	public BinaryOperation relation { get; set;}
	public Object value { get; set;}

	public MatchFieldCondition(String fieldPath, BinaryOperation relation, Object value) {
		this.fieldPath = fieldPath;
		this.relation = relation;
		this.value = value;
	}
}
