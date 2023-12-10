public with sharing class SearchWeatherController {
    private static WeatherAPI weatherAPI;
    private static string savedLocation;
    
    static {
        weatherAPI = new WeatherAPI();
    }

    @AuraEnabled
    public static Map<String, String> queryAPI(String location) {
        makeAPICallout(location);
        return WeatherAPI.getDataAsMap();
    }

    private static void makeAPICallout(String location) {
        if (savedLocation != location) {
            weatherAPI.setLocation(location).makeAPIRequest().populateData();
            savedLocation = location;
        }
    }
}