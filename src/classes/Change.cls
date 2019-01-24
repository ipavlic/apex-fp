public class Change {

	public static ChangeMatch of(Map<Id, SObject> other) {
		return new ChangeMatch(other);
	}


	public static ChangeMatch of(List<SObject> other) {
		return new ChangeMatch(new Map<Id, SObject>(other));
	}
}