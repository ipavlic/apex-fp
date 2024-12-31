public with sharing class OptionalDecimal {
	private static final OptionalDecimal EMPTY = new OptionalDecimal(null);
	private final Decimal value;

	public static OptionalDecimal of(Decimal value) {
		return value == null ? EMPTY : new OptionalDecimal(value);
	}

	public static OptionalDecimal empty() {
		return EMPTY;
	}

	private OptionalDecimal(Decimal value) {
		this.value = value;
	}

	public Boolean isPresent() {
		return this.value != null;
	}

	public Decimal orElse(Decimal other) {
		return this.value ?? other;
	}

	public Decimal orElseThrow(Exception e) {
		if (this.value != null) {
			return value;
		} else {
			throw e;
		}
	}

	public Decimal get() {
		return this.orElseThrow(new NoSuchElementException('No value present'));
	}
}