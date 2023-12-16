public with sharing class WeatherHistoryRepository {

    public static final String WEATHER_HISTORY_OBJECT_NAME = SObjectType.Weather_History__c.getName();
    public static final String NAME_FIELD = SObjectType.Weather_History__c.fields.Name.getName();
    public static final String TEMPERATURE_FIELD = SObjectType.Weather_History__c.fields.Temperature__c.getName();
    public static final String LOCATION_FIELD = SObjectType.Weather_History__c.fields.Location__c.getName();
    public static final String DATA_TYPE_FIELD = SObjectType.Weather_History__c.fields.Data_Type__c.getName();

    public static final String DATA_TYPE_MIN_TEMPERATURE = 'MIN_TEMPERATURE';
    public static final String DATA_TYPE_MAX_TEMPERATURE = 'MAX_TEMPERATURE';
    public static final String DATA_TYPE_AVG_TEMPERATURE = 'AVG_TEMPERATURE';


    private static final List<String> FIELDS_TO_QUERY = new List<String> {
        NAME_FIELD,
        TEMPERATURE_FIELD,
        LOCATION_FIELD,
        QueryConstants.CREATED_DATE_FIELD,
        DATA_TYPE_FIELD
    };


    public static Weather_History__c insertWeatherHistory(Weather_History__c history) {
        insert as user history;
        return history;
    }

    public static Weather_History__c updateWeatherHistory(Weather_History__c history) {
        update history;
        return history;
    }

    public static List<Weather_History__c> getAllWeatherHistoryByLocation(String location) {
        AndLogicalCondition condition = new AndLogicalCondition();
        condition.addComparisonCondition(new ComparisonCondition(LOCATION_FIELD, ComparisonOperators.EQUALS, location));
        List<Weather_History__c> records = query(FIELDS_TO_QUERY, condition, new OrderField(QueryConstants.CREATED_DATE_FIELD).sortDescending(), QueryConstants.NO_LIMIT);

        if (records.size() > 0) {
            return records;
        }

        return null;
    }

    public static List<Weather_History__c> getAllWeatherHistoryByLocationForToday(String location) {
        AndLogicalCondition condition = new AndLogicalCondition();
        condition.addComparisonCondition(new ComparisonCondition(LOCATION_FIELD, ComparisonOperators.EQUALS, location));
        condition.addComparisonCondition(new ComparisonCondition(QueryConstants.CREATED_DATE_FIELD, ComparisonOperators.EQUALS, QueryConstants.DateConstants.TODAY));
        condition.addComparisonCondition(new ComparisonCondition(DATA_TYPE_FIELD, ComparisonOperators.EQUALS, QueryConstants.NULL_KEYWORD));
        List<Weather_History__c> records = query(FIELDS_TO_QUERY, condition, new OrderField(QueryConstants.CREATED_DATE_FIELD).sortDescending(), QueryConstants.NO_LIMIT);

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

    public static Decimal getAvgTemperatureByLocationForDate(String location, Date dateValue) {
        AndLogicalCondition condition = new AndLogicalCondition();
        condition.addComparisonCondition(new ComparisonCondition(LOCATION_FIELD, ComparisonOperators.EQUALS, location));
        condition.addLogicalCondition(getDateCondition(dateValue));

        QueryBuilder builder = new QueryBuilder()
            .selectAggregateField(TEMPERATURE_FIELD, QueryConstants.AggregateOperators.AVG)
            .fromObject(WEATHER_HISTORY_OBJECT_NAME)
            .whereLogicalCondition(condition);
        
        AggregateResult result = (AggregateResult) Database.query(builder.build())[0];
        return (Decimal) result.get(QueryConstants.EXPR_0);
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

        condition.addComparisonCondition(new ComparisonCondition(QueryConstants.CREATED_DATE_FIELD, ComparisonOperators.GREATER_THAN_EQUALS, lowerBound));
        condition.addComparisonCondition(new ComparisonCondition(QueryConstants.CREATED_DATE_FIELD, ComparisonOperators.LESS_THAN_EQUALS, upperBound));
        return condition;
    }
}
