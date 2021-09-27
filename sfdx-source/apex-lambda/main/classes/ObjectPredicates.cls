public class ObjectPredicates {

	public static ObjectPredicate NotNull = new NotNull();

	private class NotNull implements ObjectPredicate {
		public Boolean apply(Object obj) {
			return obj != null;
		}
	}
}
