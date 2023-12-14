public with sharing class WeatherHistoryController {
	public static Weather_History__c insertWeatherHistory(Weather_History__c history) {
		insert as user history;
		return history;
	}

    public static List<Weather_History__c> getAllWeatherHistoryByLocation(String location) {
        
    }
}