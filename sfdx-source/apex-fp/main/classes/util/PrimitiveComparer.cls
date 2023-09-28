public class PrimitiveComparer {
	public Integer compareBooleans(Boolean a, Boolean b) {
		return (a == b) ? 0 : (a ? 1 : -1);
	}

	public Integer compareDates(Date a, Date b) {
		return (a == b) ? 0 : (a > b ? 1 : -1);
	}

	public Integer compareTimes(Time a, Time b) {
		return (a == b) ? 0 : (a > b ? 1 : -1);
	}

	public Integer compareDatetimes(Datetime a, Datetime b) {
		return (a == b) ? 0 : (a > b ? 1 : -1);
	}

	public Integer compareDecimals(Decimal a, Decimal b) {
		return (a == b) ? 0 : (a > b ? 1 : -1);
	}

	public Integer compareDoubles(Double a, Double b) {
		return (a == b) ? 0 : (a > b ? 1 : -1);
	}

	public Integer compareIds(Id a, Id b) {
		return (a == b) ? 0 : (a > b ? 1 : -1);
	}

	public Integer compareIntegers(Integer a, Integer b) {
		return (a == b) ? 0 : (a > b ? 1 : -1);
	}

	public Integer compareLongs(Long a, Long b) {
		return (a == b) ? 0 : (a > b ? 1 : -1);
	}

	public Integer compareStrings(String a, String b) {
		return (a == b) ? 0 : (a > b ? 1 : -1);
	}

	/**
	 * A comparison for primitive data types
	 */
	public Integer compare(Object first, Object second) {
		if (first == null && second != null) {
			return -1;
		}
		else if (first != null && second == null) {
			return 1;
		}
		else if (first == null && second == null) {
			return 0;
		}
		else if (first instanceof Boolean && second instanceof Boolean) {
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
		}
		throw new LambdaException('Comparison for provided types is not supported');
	}
}
