public class ApexString {

	String value;

	private ApexString(String str) {
		if (str != null) {
			this.value = str.toLowerCase();
		} else {
			this.value = null;
		}
	}

	public static ApexString of(String str) {
		return new ApexString(str);
	}

	public static List<ApexString> listOf(Iterable<String> strings) {
		Iterator<String> iter = strings.iterator();
		List<ApexString> l = new List<ApexString>();
		while (iter.hasNext()) {
			l.add(of(iter.next()));
		}
		return l;
	}

	public static List<ApexString> listOf(Set<String> strings) {
		List<ApexString> l = new List<ApexString>();
		for (String str : strings) {
			l.add(of(str));
		}
		return l;
	}

	public static Set<ApexString> setOf(Iterable<String> strings) {
		Iterator<String> iter = strings.iterator();
		Set<ApexString> s = new Set<ApexString>();
		while (iter.hasNext()) {
			s.add(of(iter.next()));
		}
		return s;
	}

	public static Set<ApexString> setOf(Set<String> strings) {
		Set<ApexString> s = new Set<ApexString>();
		for (String str : strings) {
			s.add(of(str));
		}
		return s;
	}

	public static String join(Iterable<ApexString> strings, String separator) {
		List<String> l = new List<String>();
		Iterator<ApexString> iter = strings.iterator();
		while (iter.hasNext()) {
			l.add(iter.next().toString());
		}
		return String.join(l, separator);
	}

	public static String join(Set<ApexString> strings, String separator) {
		List<String> l = new List<String>();
		for (ApexString str : strings) {
			l.add(str.toString());
		}
		return String.join(l, separator);
	}

	public override String toString() {
		return value;
	}

	public Boolean equals(Object obj) {
		if (obj instanceof ApexString) {
			return value == ((ApexString)obj).toString();
		} else if (obj instanceof String) {
			return value == (String) obj;
		} else {
			return false;
		}
	}

	public Integer hashCode() {
		return value.hashCode();
	}
}
