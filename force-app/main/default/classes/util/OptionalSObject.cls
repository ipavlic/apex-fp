public with sharing class OptionalSObject {
	private final SObject value;

	private static final OptionalSObject EMPTY {
		get {
			EMPTY = EMPTY ?? new OptionalSObject();
			return EMPTY;
		}
		set;
	}

	public static OptionalSObject of(SObject value) {
		return new OptionalSObject(value);
	}

	public static OptionalSObject empty() {
		return EMPTY;
	}

	private OptionalSObject() {
		this(null);
	}

	private OptionalSObject(SObject value) {
		this.value = value;
	}

	public Boolean isPresent() {
		return this.value != null;
	}

	public SObject orElse(SObject other) {
		return this.value ?? other;
	}

	public SObject orElseThrow(Exception e) {
		if (this.value != null) {
			return this.value;
		} else {
			throw e;
		}
	}

	public SObject get() {
		return this.orElseThrow(new NoSuchElementException('No value present'));
	}
}
