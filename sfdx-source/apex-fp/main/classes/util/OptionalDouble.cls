public with sharing class OptionalDouble {
	private final Double value;
	private static final OptionalDouble EMPTY = new OptionalDouble();

	public static OptionalDouble of(Double value) {
		return new OptionalDouble(value);
	}

	public static OptionalDouble empty() {
		return EMPTY;
	}

	private OptionalDouble() {
		this.value = null;
	}
	
	private OptionalDouble(Double value) {
		this.value = value;
	}

	public Boolean isPresent() {
		return value != null;
	}

	public Double orElse(Double other) {
		return value != null ? value : other; 
	}

	public Double orElseThrow(Exception e) {
		if (value != null) {
			return value;
		} else {
			throw e;
		}
	}

	public Double get() {
		if (value == null) {
			throw new NoSuchElementException('No value present');
		}
		return value;
	}
}
