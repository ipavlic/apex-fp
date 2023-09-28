public with sharing class OptionalDecimal {
	private final Decimal value;
	private static final OptionalDecimal EMPTY = new OptionalDecimal();

	public static OptionalDecimal of(Decimal value) {
		return new OptionalDecimal(value);
	}

	public static OptionalDecimal empty() {
		return EMPTY;
	}

	private OptionalDecimal() {
		this.value = null;
	}
	
	private OptionalDecimal(Decimal value) {
		this.value = value;
	}

	public Boolean isPresent() {
		return value != null;
	}

	public Decimal orElse(Decimal other) {
		return value != null ? value : other; 
	}

	public Decimal orElseThrow(Exception e) {
		if (value != null) {
			return value;
		} else {
			throw e;
		}
	}

	public Decimal get() {
		if (value == null) {
			throw new NoSuchElementException('No value present');
		}
		return value;
	}
}
