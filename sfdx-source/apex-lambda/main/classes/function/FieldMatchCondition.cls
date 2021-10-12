public class FieldMatchCondition {

	public String fieldPath { get; set;}
	public BinaryRelation relation { get; set;}
	public Object value { get; set;}

	public FieldMatchCondition(String fieldPath, BinaryRelation relation, Object value) {
		this.fieldPath = fieldPath;
		this.relation = relation;
		this.value = value;
	}
}
