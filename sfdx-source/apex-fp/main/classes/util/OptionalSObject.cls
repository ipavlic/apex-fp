public with sharing class OptionalSObject {
	private final SObject value;
	private static final OptionalSObject EMPTY = new OptionalSObject();

	public static OptionalSObject of(SObject value) {
		return new OptionalSObject(value);
	}

	public static OptionalSObject empty() {
		return EMPTY;
	}

	private OptionalSObject() {
		this.value = null;
	}
	
	private OptionalSObject(SObject value) {
		this.value = value;
	}

	public Boolean isPresent() {
		return value != null;
	}

	public SObject orElse(SObject other) {
		return value != null ? value : other; 
	}

	public SObject orElseThrow(Exception e) {
		if (value != null) {
			return value;
		} else {
			throw e;
		}
	}

	public SObject get() {
		if (value == null) {
			throw new NoSuchElementException('No value present');
		}
		return value;
	}
}
