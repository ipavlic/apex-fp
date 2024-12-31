public with sharing class OptionalDouble {
	private static final OptionalDouble EMPTY = new OptionalDouble(null);
	private final Double value;

	public static OptionalDouble of(Double value) {
		return value == null ? EMPTY : new OptionalDouble(value);
	}

	public static OptionalDouble empty() {
		return EMPTY;
	}

	private OptionalDouble(Double value) {
		this.value = value;
	}

	public Boolean isPresent() {
		return this.value != null;
	}

	public Double orElse(Double other) {
		return this.value ?? other;
	}

	public Double orElseThrow(Exception e) {
		if (this.value != null) {
			return value;
		} else {
			throw e;
		}
	}

	public Double get() {
		return this.orElseThrow(new NoSuchElementException('No value present'));
	}
}