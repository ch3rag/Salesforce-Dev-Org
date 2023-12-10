// Visual Crossing Weather API Controller Class

public with sharing class WeatherAPI extends RestAPIController {

    private static final String API_URL = 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/';
    private static final String UNIT_GROUP = 'unitGroup';
    private static final String METRIC = 'metric';
    private static final String INCLUDE = 'include';
    private static final String CURRENT = 'current';
    private static final String KEY = 'key';
    /* cspell:disable-next-line */
    private static final String API_KEY = API_Key__mdt.getInstance('VisualCrossingWeatherAPIKey').Key__c;
    private static final String CONTENT_TYPE = 'contentType';
    private static final String JSON = 'json';
    
    // Public Queryable Data
    private static Map<String, String> dataMapping;
    private static Decimal currentTemperature;
    private static String resolvedAddress;

    // JSON Input Mapping Keys
    private static final String TEMP = 'temp';
    private static final String CURRENT_CONDITIONS = 'currentConditions';

    // JSON Output Mapping Keys
    private static final String CURRENT_TEMPERATURE = 'currentTemperature';
    private static final String RESOLVED_ADDRESS = 'resolvedAddress';

    public WeatherAPI() {
        this.setRequestURL(API_URL)
            .addOrSetRequestURLParam(UNIT_GROUP, METRIC)
            .addOrSetRequestURLParam(INCLUDE, CURRENT)
            .addOrSetRequestURLParam(KEY, API_KEY)
            .addOrSetRequestURLParam(CONTENT_TYPE, JSON);

        dataMapping = new Map<String, String>();
    }

    public WeatherAPI setLocation(String location) {
        this.addArgAfterURLBeforeParams(location);
        return this;
    }

    public WeatherAPI makeAPIRequest() {
        this.createHTTPRequest()
            .setMethodGET()
            .setContentJSON()
            .submitRequest();
        return this;
    }

    public WeatherAPI populateData() {
        Map<String, Object> data = getResponseBodyAsJSON();
        Map<String, Object> currentConditions = (Map<String, Object>) data.get(CURRENT_CONDITIONS);
        currentTemperature = (Decimal)currentConditions.get(TEMP);
        resolvedAddress = (String)data.get(RESOLVED_ADDRESS);
        return this;
    }

    public Map<String, String> getDataAsMap() {
        dataMapping.put(CURRENT_TEMPERATURE, String.valueOf(currentTemperature));
        dataMapping.put(RESOLVED_ADDRESS, resolvedAddress);
        return dataMapping;
    }
}