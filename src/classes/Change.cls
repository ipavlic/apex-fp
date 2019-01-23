public class Change {

	public static ChangeMatch of(Map<Id, SObject> other) {
		return new ChangeMatch(other);
	}
}