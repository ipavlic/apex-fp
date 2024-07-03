public with sharing class DebugSObject {
	private System.LoggingLevel logLevel = System.LoggingLevel.DEBUG;

	public DebugSObject logLevel(LoggingLevel logLevel) {
		this.logLevel = logLevel;
		return this;
	}

	public void call(SObject record) {
		System.debug(logLevel, record);
	}
}
