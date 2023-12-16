public with sharing class WeatherDataCleanupSchedule implements Schedulable {

    public static final String CRON = '00 55 23 * * ?';
    private static final String LOCATION = 'Lucknow, UP, India';
    private static final Date TODAY = Date.today();

    public void execute(SchedulableContext sc) {
        saveMinMaxAvgTemperatures();
        WeatherDataCleanupBatch batch = new WeatherDataCleanupBatch();
        Database.executeBatch(batch, 2000);
    }


    private void saveMinMaxAvgTemperatures() {
        Weather_History__c maxTemperature = WeatherHistoryRepository.getMaxTemperatureByLocationForDate(LOCATION, TODAY);
        Weather_History__c minTemperature = WeatherHistoryRepository.getMinTemperatureByLocationForDate(LOCATION, TODAY);
        maxTemperature.Data_Type__c = WeatherHistoryRepository.DATA_TYPE_MAX_TEMPERATURE;
        minTemperature.Data_Type__c = WeatherHistoryRepository.DATA_TYPE_MIN_TEMPERATURE;

        Weather_History__c avgTemperature = new Weather_History__c();
        avgTemperature.Location__c = maxTemperature.Location__c;
        avgTemperature.Temperature__c = WeatherHistoryRepository.getAvgTemperatureByLocationForDate(location, TODAY);
        avgTemperature.Data_Type__c = WeatherHistoryRepository.DATA_TYPE_AVG_TEMPERATURE;

        WeatherHistoryRepository.insertWeatherHistory(avgTemperature);
        WeatherHistoryRepository.updateWeatherHistory(maxTemperature);
        WeatherHistoryRepository.updateWeatherHistory(minTemperature);
    }
}
