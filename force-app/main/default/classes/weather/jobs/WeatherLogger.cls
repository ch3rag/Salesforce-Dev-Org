public with sharing class WeatherLogger implements Schedulable {
    public void execute(SchedulableContext context) {
        WeatherAPIFutureCaller.calloutAPI();
    }
}
