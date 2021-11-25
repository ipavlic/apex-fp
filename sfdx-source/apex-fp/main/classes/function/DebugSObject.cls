public with sharing class DebugSObject {
	private LoggingLevel logLevel = LoggingLevel.DEBUG;

	public DebugSObject logLevel(LoggingLevel logLevel) {
		this.logLevel = logLevel;
		return this;
	}

	public void call(SObject record) {
		System.debug(logLevel, record);
	}
}
