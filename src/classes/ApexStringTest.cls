@IsTest
public class ApexStringTest {
	@IsTest
	public static void testEquality() {
		ApexString str = ApexString.of('test');
		System.assert(str.equals('TEST'));
		System.assert(str.equals('test'));
		System.assert(str.equals('tEsT'));
		System.assert(str.equals(ApexString.of('TEST')));
		System.assert(str.equals(ApexString.of('test')));
		System.assert(str.equals(ApexString.of('tEsT')));
		System.assert(str.equals(str));
	}

	@IsTest
	public static void testHashCode() {
		ApexString str = ApexString.of('test');
		System.assertEquals(str.hashCode(), ApexString.of('TEST').hashCode());
		System.assertEquals(str.hashCode(), ApexString.of('test').hashCode());
		System.assertEquals(str.hashCode(), ApexString.of('tEsT').hashCode());
	}

	@IsTest
	public static void testListOf() {
		List<ApexString> strings = ApexString.listOf(new List<String>{'foo', 'bar', 'baz', 'FOO', 'fOO'});
		System.assertEquals(5, strings.size());
		for (ApexString s : strings) {
			Boolean isOk = ApexString.of('foo').equals(s) || ApexString.of('bar').equals(s) || ApexString.of('baz').equals(s);
			System.assert(isOk, 'Unexpected element found in the list');
		}
	}

	@IsTest
	public static void testListOfSet() {
		List<ApexString> strings = ApexString.listOf(new List<String>{'foo', 'bar', 'baz', 'FOO', 'fOO'});
		System.assertEquals(5, strings.size());
		for (ApexString s : strings) {
			Boolean isOk = ApexString.of('foo').equals(s) || ApexString.of('bar').equals(s) || ApexString.of('baz').equals(s);
			System.assert(isOk, 'Unexpected element found in the list');
		}
	}

	@IsTest
	public static void testSetOf() {
		Set<ApexString> strings = ApexString.setOf(new List<String>{'foo', 'bar', 'baz', 'FOO', 'fOO'});
		System.assertEquals(3, strings.size());
		for (ApexString s : strings) {
			Boolean isOk = ApexString.of('foo').equals(s) || ApexString.of('bar').equals(s) || ApexString.of('baz').equals(s);
			System.assert(isOk, 'Unexpected element found in the list');
		}
	}

	@IsTest
	public static void testSetOfSet() {
		Set<ApexString> strings = ApexString.setOf(new Set<String>{'foo', 'bar', 'baz', 'FOO', 'fOO'});
		System.assertEquals(3, strings.size());
		for (ApexString s : strings) {
			Boolean isOk = ApexString.of('foo').equals(s) || ApexString.of('bar').equals(s) || ApexString.of('baz').equals(s);
			System.assert(isOk, 'Unexpected element found in the list');
		}
	}

	@IsTest
	public static void testJoin() {
		List<ApexString> strings = ApexString.listOf(new List<String>{'foo', 'bar', 'baz'});
		List<String> l = new List<String>();
		for (ApexString str : strings) {
			l.add(str.toString());
		}
		System.assertEquals(String.join(l, ','), ApexString.join(strings, ','));

		ApexString foo = ApexString.of('foo');
		ApexString bar = ApexString.of('bar');
		Set<String> expectedJoins = new Set<String>{
			foo.toString() + ',' + bar.toString(),
			bar.toString() + ',' + foo.toString()
		};
		Set<ApexString> stringSet = ApexString.setOf(new Set<String>{'foo', 'bar'});
		System.assert(expectedJoins.contains(ApexString.join(stringSet, ',')));
	}

	@IsTest
	public static void testSetBehaviour() {
		Set<ApexString> s = new Set<ApexString>();
		s.add(ApexString.of('test'));
		s.add(ApexString.of('TEST'));
		s.add(ApexString.of('tEsT'));
		System.assertEquals(1, s.size());
		System.assert(s.contains(ApexString.of('test')));
		System.assert(s.contains(ApexString.of('TEST')));
		System.assert(s.contains(ApexString.of('tEsT')));
	}
}
