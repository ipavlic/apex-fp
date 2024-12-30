@IsTest(IsParallel=true)
private class ObjectCollectionTest {
	@IsTest
	private static void asListReturnsItems() {
		ObjectCollection c = ObjectCollection.of(new List<Integer>{1, 2, 3});
		List<Integer> items = (List<Integer>) c.asList(List<Integer>.class);
		System.Assert.areEqual(3, items.size());
		System.Assert.areEqual(1, items.get(0));
		System.Assert.areEqual(2, items.get(1));
		System.Assert.areEqual(3, items.get(2));
	}
}
