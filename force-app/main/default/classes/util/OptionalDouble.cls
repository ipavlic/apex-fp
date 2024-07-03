public with sharing class OptionalDouble {
	private static final OptionalDouble EMPTY {
		get {
			EMPTY = EMPTY ?? new OptionalDouble(null);
			return EMPTY;
		}
		set;
	}

	private final Double value;

	public static OptionalDouble of(Double value) {
		if (value == null) {
			return EMPTY;
		}
		return new OptionalDouble(value);
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
		if (this.value == null) {
			throw new NoSuchElementException('No value present');
		}
		return value;
	}
}
