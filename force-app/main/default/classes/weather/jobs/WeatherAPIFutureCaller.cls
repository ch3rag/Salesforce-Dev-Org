public with sharing class WeatherAPIFutureCaller {
    @Future(Callout = true)
    public static void calloutAPI() {
        WeatherAPI api = new WeatherAPI();
        api.setLocation('Lucknow').submitWeatherAPIRequest().populateData();
        Weather_History__c history = new Weather_History__c();
        history.Location__c = api.resolvedAddress;
        history.Temperature__c = api.currentTemperature;
        history.Timestamp__c = DateTime.now();
        WeatherHistoryRepository.insertWeatherHistory(history);
    }
}
