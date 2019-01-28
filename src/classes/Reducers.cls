public class Reducers {
	public static SObjectDecimalToDecimalFunction sumDecimals(String relation, Decimal accumulator) {
		return new SumDecimalsReducer(relation, accumulator);
	}

	public static SObjectDecimalToDecimalFunction sumDecimals(String relation) {
		return sumDecimals(relation, 0);
	}

	public static SObjectDecimalToDecimalFunction sumDecimals(Schema.SObjectField field) {
		return sumDecimals(field.getDescribe().getName(), 0);
	}

	public static SObjectDecimalToDecimalFunction sumDecimals(Schema.SObjectField field, Decimal accumulator) {
		return sumDecimals(field.getDescribe().getName(), accumulator);
	}
}
