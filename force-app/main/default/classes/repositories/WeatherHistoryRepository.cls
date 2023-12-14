public with sharing class WeatherHistoryRepository {

    private static final String WEATHER_HISTORY_OBJECT_NAME = SObjectType.Weather_History__c.getName();
    private static final String NAME_FIELD = SObjectType.Weather_History__c.fields.Name.getName();
    private static final String TEMPERATURE_FIELD = SObjectType.Weather_History__c.fields.Temperature__c.getName();
    private static final String LOCATION_FIELD = SObjectType.Weather_History__c.fields.Location__c.getName();
    private static final String TIMESTAMP_FIELD = SObjectType.Weather_History__c.fields.Timestamp__c.getName();

    private static final List<String> FIELDS_TO_QUERY = new List<String> {
        NAME_FIELD,
        TEMPERATURE_FIELD,
        LOCATION_FIELD,
        TIMESTAMP_FIELD
    };


    public static Weather_History__c insertWeatherHistory(Weather_History__c history) {
        insert as user history;
        return history;
    }

    public static List<Weather_History__c> getAllWeatherHistoryByLocation(String location) {
        AndLogicalCondition condition = new AndLogicalCondition();
        condition.addComparisonCondition(new ComparisonCondition(LOCATION_FIELD, ComparisonOperators.EQUALS, location));
        List<Weather_History__c> records = query(FIELDS_TO_QUERY, condition, new OrderField(TIMESTAMP_FIELD).sortDescending(), QueryConstants.NO_LIMIT);

        if (records.size() > 0) {
            return records;
        }

        return null;
    }

    public static List<Weather_History__c> getAllWeatherHistoryByLocationForToday(String location) {
        AndLogicalCondition condition = new AndLogicalCondition();
        condition.addComparisonCondition(new ComparisonCondition(LOCATION_FIELD, ComparisonOperators.EQUALS, location));
        condition.addComparisonCondition(new ComparisonCondition(TIMESTAMP_FIELD, ComparisonOperators.EQUALS, QueryConstants.DateConstants.TODAY));
        List<Weather_History__c> records = query(FIELDS_TO_QUERY, condition, new OrderField(TIMESTAMP_FIELD).sortDescending(), QueryConstants.NO_LIMIT);

        if (records.size() > 0) {
            return records;
        }

        return null;
    }

    private static Weather_History__c getMinMaxTemperatureByLocationForDate(String location, Date dateValue, OrderField orderField) {
        AndLogicalCondition condition = new AndLogicalCondition();
        condition.addComparisonCondition(new ComparisonCondition(LOCATION_FIELD, ComparisonOperators.EQUALS, location));
        condition.addLogicalCondition(getDateCondition(dateValue));

        List<Weather_History__c> records = query(FIELDS_TO_QUERY, condition, orderField, 1);

        if (records.size() > 0) {
            return records[0];
        }

        return null;
    }

    public static Weather_History__c getMaxTemperatureByLocationForDate(String location, Date dateValue) {
        return getMinMaxTemperatureByLocationForDate(location, dateValue, new OrderField(TEMPERATURE_FIELD).sortDescending());
    }

    public static Weather_History__c getMinTemperatureByLocationForDate(String location, Date dateValue) {
        return getMinMaxTemperatureByLocationForDate(location, dateValue, new OrderField(TEMPERATURE_FIELD).sortAscending());
    }

    private static List<Weather_History__c> query(List<String> fields, LogicalCondition condition, OrderField orderField, Integer limitValue) {
        QueryBuilder queryBuilder = new QueryBuilder()
            .selectAllFields(fields)
            .fromObject(WEATHER_HISTORY_OBJECT_NAME)
            .whereLogicalCondition(condition)
            .orderBy(orderField)
            .limitRecords(limitValue);

        String queryString = queryBuilder.build();
        return Database.query(queryString);
    }

    public static AndLogicalCondition getDateCondition(Date dateValue) {
        AndLogicalCondition condition = new AndLogicalCondition();

        DateTime lowerBound = DateTimeUtility.getDateTimeSOD(dateValue);
        DateTime upperBound = DateTimeUtility.getDateTimeEOD(dateValue);

        condition.addComparisonCondition(new ComparisonCondition(TIMESTAMP_FIELD, ComparisonOperators.GREATER_THAN_EQUALS, lowerBound));
        condition.addComparisonCondition(new ComparisonCondition(TIMESTAMP_FIELD, ComparisonOperators.LESS_THAN_EQUALS, upperBound));
        return condition;
    }
}
