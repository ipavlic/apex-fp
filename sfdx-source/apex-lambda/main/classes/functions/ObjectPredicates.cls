public class ObjectPredicates {

	public static ObjectPredicate AlwaysTrue = new AlwaysTrue();
	public static ObjectPredicate NotNull = new NotNull();

	private class NotNull implements ObjectPredicate {
		public Boolean apply(Object obj) {
			return obj != null;
		}
	}

	private class AlwaysTrue implements ObjectPredicate {
		public Boolean apply(Object obj) {
			return true;
		}
	}
}
