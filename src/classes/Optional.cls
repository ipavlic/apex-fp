public class Optional {
	private final Object value;

	private static final Optional EMPTY = new Optional();

	private Optional() {
		this.value = null;
	}

	private Optional(Object value) {
		if (value == null) {
			throw new LambdaException('Optional value cannot be null');
		}
		this.value = value;
	}

	/**
	 * Returns the wrapped value
	 */
	public Object get() {
		if (value == null) {
			throw new LambdaException('No value present');
		}
		return value;
	}

	/**
	 * Returns whether the wrapped value is non-null.
	 */
	public Boolean isPresent() {
		return this.value != null;
	}

	/**
	 * Returns the wrapped value if it is present, and the other value if it is not.
	 */
	public Object orElse(Object other) {
		return value != null ? value : other;
	}

	/**
	 * Returns an empty Optional, which is a single instance in a transaction.
	 */
	public static Optional empty() {
		return EMPTY;
	}

	/**
	 * Returns an Optional that wraps the provided value if it's non-null.
	 * Throws a LambdaException otherwise.
	 */
	public static Optional of(Object value) {
		return new Optional(value);
	}

	/**
	 * Returns an Optional that wraps the provided value.
	 * @type {[type]}
	 */
	public static Optional ofNullable(Object value) {
		return value == null ? empty() : of(value);
	}
}
