public class PrimitiveComparer {
	public ComparisonResult compareBooleans(Boolean a, Boolean b) {
		if (a == b) {
			return ComparisonResult.EQUALS;
		} else {
			return ComparisonResult.NOT_EQUALS;
		}
	}

	public ComparisonResult compareDates(Date a, Date b) {
		if (a < b) {
			return ComparisonResult.LESS_THAN;
		} else if (a == b) {
			return ComparisonResult.EQUALS;
		} else {
			return ComparisonResult.GREATER_THAN;
		}
	}

	public ComparisonResult compareTimes(Time a, Time b) {
		if (a < b) {
			return ComparisonResult.LESS_THAN;
		} else if (a == b) {
			return ComparisonResult.EQUALS;
		} else {
			return ComparisonResult.GREATER_THAN;
		}
	}

	public ComparisonResult compareDatetimes(Datetime a, Datetime b) {
		if (a < b) {
			return ComparisonResult.LESS_THAN;
		} else if (a == b) {
			return ComparisonResult.EQUALS;
		} else {
			return ComparisonResult.GREATER_THAN;
		}
	}

	public ComparisonResult compareDecimals(Decimal a, Decimal b) {
		if (a < b) {
			return ComparisonResult.LESS_THAN;
		} else if (a == b) {
			return ComparisonResult.EQUALS;
		} else {
			return ComparisonResult.GREATER_THAN;
		}
	}

	public ComparisonResult compareDoubles(Double a, Double b) {
		if (a < b) {
			return ComparisonResult.LESS_THAN;
		} else if (a == b) {
			return ComparisonResult.EQUALS;
		} else {
			return ComparisonResult.GREATER_THAN;
		}
	}

	public ComparisonResult compareIds(Id a, Id b) {
		if (a == b) {
			return ComparisonResult.EQUALS;
		} else {
			return ComparisonResult.NOT_EQUALS;
		}
	}

	public ComparisonResult compareIntegers(Integer a, Integer b) {
		if (a < b) {
			return ComparisonResult.LESS_THAN;
		} else if (a == b) {
			return ComparisonResult.EQUALS;
		} else {
			return ComparisonResult.GREATER_THAN;
		}
	}

	public ComparisonResult compareLongs(Long a, Long b) {
		if (a < b) {
			return ComparisonResult.LESS_THAN;
		} else if (a == b) {
			return ComparisonResult.EQUALS;
		} else {
			return ComparisonResult.GREATER_THAN;
		}
	}

	public ComparisonResult compareStrings(String a, String b) {
		if (a != b && (a == null || b == null)) {
			return ComparisonResult.NOT_EQUALS;
		} else if (a < b) {
			return ComparisonResult.LESS_THAN;
		} else if (a == b) {
			return ComparisonResult.EQUALS;
		} else {
			return ComparisonResult.GREATER_THAN;
		}
	}

	/**
	 * A comparison for primitive data types
	 */
	public ComparisonResult compare(Object first, Object second) {
		if (first instanceof Boolean && second instanceof Boolean) {
			return this.compareBooleans((Boolean)first, (Boolean)second);
		}
		else if (first instanceof Date && second instanceof Date) {
			return this.compareDates((Date)first, (Date)second);
		}
		else if (first instanceof Datetime && second instanceof Datetime) {
			return this.compareDatetimes((Datetime)first, (Datetime)second);
		}
		else if (first instanceof Decimal && second instanceof Decimal) {
			return this.compareDecimals((Decimal)first, (Decimal)second);
		}
		else if (first instanceof Double && second instanceof Double) {
			return this.compareDoubles((Double)first, (Double)second);
		}
		else if (first instanceof Id && second instanceof Id) {
			return this.compareIds((Id)first, (Id)second);
		}
		else if (first instanceof Integer && second instanceof Integer) {
			return this.compareIntegers((Integer)first, (Integer)second);
		}
		else if (first instanceof Long && second instanceof Long) {
			return this.compareLongs((Long)first, (Long)second);
		}
		else if (first instanceof String && second instanceof String) {
			return this.compareStrings((String)first, (String)second);
		}
		else if (first instanceof Time && second instanceof Time) {
			return this.compareTimes((Time)first, (Time)second);
		} else {
			return ComparisonResult.NOT_EQUALS;
		}
	}
}
