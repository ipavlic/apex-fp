@IsTest(isParallel=true)
private class MapToObjectTest {
	
	private class MappingTarget {
		public String name;
		public MappingTarget child;
	}

	@IsTest
	private static void setFieldSetsFieldValue() {
		MapToObject m = new MapToObject(MappingTarget.class).setField('name', 'foo');
		MappingTarget mapped = (MappingTarget) m.call(new Account());
		System.Assert.areEqual('foo', mapped.name);
	}

	@IsTest
	private static void setFieldSetsNestedFieldValue() {
		MapToObject m = new MapToObject(MappingTarget.class).setField('child.name', 'foo');
		MappingTarget mapped = (MappingTarget) m.call(new Account());
		System.Assert.areEqual('foo', mapped.child.name);
	}

	@IsTest
	private static void fieldValuesCanBeProvidedAsAMap() {
		MapToObject m = new MapToObject(MappingTarget.class).setFields(
			new Map<String, Object>{
				'name' => 'foo',
				'child.name' => 'bar' 
			});
		MappingTarget mapped = (MappingTarget) m.call(new Account(Name = 'foo'));
		System.Assert.areEqual('foo', mapped.name);
		System.Assert.areEqual('bar', mapped.child.name);
	}

	@IsTest
	private static void fieldRelationsCanBeMappedToFieldPaths() {
		MapToObject m = new MapToObject(MappingTarget.class).mapField('name', 'Name');
		MappingTarget mapped = (MappingTarget) m.call(new Account(Name = 'foo'));
		System.Assert.areEqual('foo', mapped.name);
	}


	@IsTest
	private static void fieldRelationsCanBeMappedToNestedFieldPaths() {
		MapToObject m = new MapToObject(MappingTarget.class).mapField('child.name', 'Name');
		MappingTarget mapped = (MappingTarget) m.call(new Account(Name = 'foo'));
		System.Assert.areEqual('foo', mapped.child.name);
	}

	@IsTest
	private static void nestedFieldRelationsCanBeMappedToNestedFieldPaths() {
		MapToObject m = new MapToObject(MappingTarget.class).mapField('child.name', 'Account.Name');
		MappingTarget mapped = (MappingTarget) m.call(new Opportunity(Account = new Account(Name = 'foo')));
		System.Assert.areEqual('foo', mapped.child.name);
	}

	@IsTest
	private static void fieldRelationsMappingsCanBeProvidedAsAMap() {
		MapToObject m = new MapToObject(MappingTarget.class).mapFields(
			new Map<String, String>{
				'name' => 'Name',
				'child.name' => 'Name' 
			});
		MappingTarget mapped = (MappingTarget) m.call(new Account(Name = 'foo'));
		System.Assert.areEqual('foo', mapped.name);
		System.Assert.areEqual('foo', mapped.child.name);
	}

	@IsTest
	private static void fieldMappingsCanBeProvidedAsAMap() {
		MapToObject m = new MapToObject(MappingTarget.class).mapFields(
			new Map<String, Schema.SObjectField>{
				'name' => Account.Name,
				'child.name' => Account.Name 
			});
		MappingTarget mapped = (MappingTarget) m.call(new Account(Name = 'foo'));
		System.Assert.areEqual('foo', mapped.name);
		System.Assert.areEqual('foo', mapped.child.name);
	}
}
