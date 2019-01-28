public with sharing class SumDecimalsReducer implements SObjectDecimalToDecimalFunction {
	private SObjectFieldReader fieldReader = new SObjectFieldReader();
	private String relation;
	private Decimal accumulator;

	public SumDecimalsReducer(String relation) {
		this(relation, 0);
	}

	public SumDecimalsReducer(String relation, Decimal accumulator) {
		this.relation = relation;
		this.accumulator = accumulator;
	}

	public Decimal apply(SObject record, Decimal accumulator) {
		return (Decimal) fieldReader.read(record, relation) + accumulator;
	}
}
