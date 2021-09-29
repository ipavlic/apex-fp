public with sharing class StringPredicates {

	public static StringPredicate longerThan(Integer length) {
		return new LongerThan(length);
	}

	public static StringPredicate shorterThan(Integer length) {
		return new ShorterThan(length);
	}

	private class LongerThan implements StringPredicate {
		Integer length;

		public LongerThan(Integer length) {
			this.length = length;
		}

		public Boolean apply(String str) {
			return str != null && str.length() > length;
		}
	}

	private class ShorterThan implements StringPredicate {
		Integer length;

		public ShorterThan(Integer length) {
			this.length = length;
		}

		public Boolean apply(String str) {
			return str != null && str.length() < length;
		}
	}
}
