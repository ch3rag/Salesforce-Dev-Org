public with sharing class TestClass {
	public static void main() {
		Map<String, Integer> mapping = CTLocationController.getStatusCount();

		for (String healthStatus : mapping.keySet()) {
			Integer count = mapping.get(healthStatus);
			System.debug('Health Status: ' + healthStatus + ', Count = ' + count);
		}
	}
}