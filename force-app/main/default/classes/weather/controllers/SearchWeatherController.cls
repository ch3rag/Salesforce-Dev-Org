public with sharing class SearchWeatherController {
    private static WeatherAPI weatherAPI = new WeatherAPI();
    private static string savedLocation;
    private static WeatherInformation information;

    @AuraEnabled
    public static WeatherInformation queryAPI(String location) {
        if (savedLocation != location) {
            weatherAPI
                .setLocation(location)
                .submitWeatherAPIRequest()
                .populateData();

            if (weatherAPI.getStatusCode() == HttpConstants.HTTP_SUCCESS_STATUS_CODE) {
                savedLocation = location;
                information = new WeatherInformation();
                information.currentTemperature = weatherAPI.currentTemperature;
                information.resolvedAddress  = weatherAPI.resolvedAddress;
            }
        }
        return information;
    }

    @AuraEnabled
    public static List<Weather_History__c> getAllWeatherHistoryByLocationForToday(String location) {
        return WeatherHistoryRepository.getAllWeatherHistoryByLocationForToday(location);
    }

    public class WeatherInformation {
        @AuraEnabled
        public String resolvedAddress;
        @AuraEnabled
        public Decimal currentTemperature;
    }
}
