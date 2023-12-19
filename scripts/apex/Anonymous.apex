String WEATHER_HISTORY_OBJECT_NAME = SObjectType.Weather_History__c.getName();
String NAME_FIELD = SObjectType.Weather_History__c.fields.Name.getName();
String TEMPERATURE_FIELD = SObjectType.Weather_History__c.fields.Temperature__c.getName();
String LOCATION_FIELD = SObjectType.Weather_History__c.fields.Location__c.getName();
String TIMESTAMP_FIELD = SObjectType.Weather_History__c.fields.Timestamp__c.getName();
String location = 'Lucknow, UP, India';
List<String> FIELDS_TO_QUERY = new List<String> {
    NAME_FIELD,
    TEMPERATURE_FIELD,
    LOCATION_FIELD,
    TIMESTAMP_FIELD
};

Date dateValue = Date.today().addDays(0);

AndLogicalCondition getDateCondition(Date dateValue) {
    AndLogicalCondition condition = new AndLogicalCondition();

    DateTime lowerBound = DateTimeUtility.getDateTimeSOD(dateValue);
    DateTime upperBound = DateTimeUtility.getDateTimeEOD(dateValue);

    condition.addComparisonCondition(new ComparisonCondition(TIMESTAMP_FIELD, ComparisonOperators.GREATER_THAN_EQUALS, lowerBound));
    condition.addComparisonCondition(new ComparisonCondition(TIMESTAMP_FIELD, ComparisonOperators.LESS_THAN_EQUALS, upperBound));
    return condition;
}

// Integer y = 1;
// for (Integer i = 0; i < 60; i += 10) {
//     String jobName = 'Weather Logging Job ' + y;
//     String cronExp = '0 ' + i + ' * * * ?';
//     System.schedule(jobName, cronExp, new WeatherLogger());
//     y += 1;
// }

// for (CronTrigger job : [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name LIKE 'Weather Logging Job%']) {
//     System.abortJob(job.Id);
// }

// AndLogicalCondition andConditionOne = new AndLogicalCondition();
// andConditionOne.addComparisonCondition(new ComparisonCondition('Location__c', ComparisonOperators.EQUALS, 'Lucknow'));
// andConditionOne.addComparisonCondition(new ComparisonCondition('Temperature__c', ComparisonOperators.EQUALS, 12));

// AndLogicalCondition andConditionTwo = new AndLogicalCondition();
// andConditionTwo.addComparisonCondition(new ComparisonCondition('Location__c', ComparisonOperators.EQUALS, 'Delhi'));
// andConditionTwo.addComparisonCondition(new ComparisonCondition('Temperature__c', ComparisonOperators.EQUALS, 14));

// OrLogicalCondition orCondition = new OrLogicalCondition();
// orCondition.addLogicalCondition(andConditionOne);
// orCondition.addLogicalCondition(andConditionTwo);


// String query = new QueryBuilder()
//     .selectField('Name')
//     .selectField('Location__c')
//     .selectField('Temperature__c')
//     .fromObject('Weather_History__c')
//     .whereLogicalCondition(orCondition)
//     .build();

// System.debug(query);

// System.debug(WeatherHistoryRepository.getAllWeatherHistoryByLocationForToday('Lucknow, UP, India'));

// System.debug(String.valueOf(QueryConstants.DateConstants.TODAY));

// AndLogicalCondition condition = new AndLogicalCondition();
// condition.addComparisonCondition(new ComparisonCondition('TimeStamp__c', ComparisonOperators.EQUALS, QueryConstants.DateConstants.TODAY));


// String query = new QueryBuilder()
//     .selectField('Name')
//     .selectField('Location__c')
//     .selectField('Temperature__c')
//     .fromObject('Weather_History__c')
//     .whereLogicalCondition(condition)
//     .orderBy('Timestamp__c', QueryConstants.DESC_KEYWORD)
//     .build();

// System.debug(query);

// String queryString = 'SELECT MIN(Temperature__c) FROM Weather_History__c WHERE (Location__c = \'Lucknow, UP, India\' AND (Timestamp__c >= 2023-12-14T00:00:00+0000 AND Timestamp__c <= 2023-12-14T11:59:59+0000))';
// System.debug(Database.query(queryString));
// System.debug(DateTimeUtility.getDateTimeEOD(Date.today()).formatGmt('yyyy-MM-dd\'T\'HH:mm:ss'));

AndLogicalCondition dateCondition = new AndLogicalCondition();

DateTime lowerBound = DateTimeUtility.getDateTimeSOD(Date.today());
DateTime upperBound = DateTimeUtility.getDateTimeEOD(Date.today());

dateCondition.addComparisonCondition(new ComparisonCondition('Timestamp__c', ComparisonOperators.GREATER_THAN_EQUALS, lowerBound));
dateCondition.addComparisonCondition(new ComparisonCondition('Timestamp__c', ComparisonOperators.LESS_THAN_EQUALS, upperBound));

AndLogicalCondition condition = new AndLogicalCondition();
condition.addComparisonCondition(new ComparisonCondition('Location__c', ComparisonOperators.NOT_EQUALS, QueryConstants.NULL_KEYWORD));
condition.addLogicalCondition(dateCondition);

QueryBuilder queryBuilder = new QueryBuilder()
            .selectField('NAME')
            .selectAggregateField('Temperature__c', QueryConstants.AggregateOperators.MAX)
            .selectAggregateField('Temperature__c', QueryConstants.AggregateOperators.MIN)
            .fromObject('Weather_History__c')
            .whereLogicalCondition(condition)
            .groupBy('Location__c')
            .groupBy('Name')
            .orderByAscending('Location__c')
            .orderByDescending('Name')
            .limitRecords(5);

System.debug(queryBuilder.build());

// System.debug(WeatherHistoryRepository.getMaxTemperatureByLocationForDate('Lucknow, UP, India', Date.today()));
// System.debug(WeatherHistoryRepository.getMinTemperatureByLocationForDate('Lucknow, UP, India', Date.today()));


// Id minId = WeatherHistoryRepository.getMinTemperatureByLocationForDate('Lucknow, UP, India', Date.today().addDays(-1)).Id;
// Id maxId = WeatherHistoryRepository.getMaxTemperatureByLocationForDate('Lucknow, UP, India', Date.today().addDays(-1)).Id;

// AndLogicalCondition condition = new AndLogicalCondition();
// condition.addComparisonCondition(new ComparisonCondition(QueryConstants.CREATED_DATE_FIELD, ComparisonOperators.EQUALS, QueryConstants.DateConstants.YESTERDAY));
// condition.addComparisonCondition(new ComparisonCondition(QueryConstants.ID_FIELD, ComparisonOperators.NOT_EQUALS, minId));
// condition.addComparisonCondition(new ComparisonCondition(QueryConstants.ID_FIELD, ComparisonOperators.NOT_EQUALS, maxId));

// QueryBuilder queryBuilder = new QueryBuilder()
//             .selectField(QueryConstants.ID_FIELD)
//             .fromObject('Weather_History__c')
//             .whereLogicalCondition(condition);
// System.debug(queryBuilder.build());

// System.schedule('Weather Data Cleanup Batch', WeatherDataCleanupSchedule.CRON, new WeatherDataCleanupSchedule());


// Id minId = WeatherHistoryRepository.getMinTemperatureByLocationForDate('Lucknow, UP, India', Date.today().addDays(-1)).Id;
// Id maxId = WeatherHistoryRepository.getMaxTemperatureByLocationForDate('Lucknow, UP, India', Date.today().addDays(-1)).Id;

// Decimal averageTemperature = WeatherHistoryRepository.getMinTemperatureByLocationForDate('Lucknow, UP, India', Date.today());


// AndLogicalCondition condition = new AndLogicalCondition();
// condition.addComparisonCondition(new ComparisonCondition(LOCATION_FIELD, ComparisonOperators.EQUALS, location));
// condition.addLogicalCondition(getDateCondition(dateValue));

// QueryBuilder builder = new QueryBuilder()
//     .selectAggregateField(TEMPERATURE_FIELD, QueryConstants.AggregateOperators.AVG)
//     .fromObject(WEATHER_HISTORY_OBJECT_NAME)
//     .whereLogicalCondition(condition);

// AggregateResult result = (AggregateResult)Database.query(builder.build())[0];
// System.debug(result.get('EXPR0'));

System.debug(WeatherHistoryRepository.getAvgTemperatureByLocationForDate('Lucknow, UP, India', Date.today().addDays(-2)));

new WeatherDataCleanupSchedule().execute(null);

Weather_History__c max = WeatherHistoryRepository.getMaxTemperatureByLocationForDate('Lucknow, UP, India', Date.today().addDays(-1));
max.Data_Type__c = WeatherHistoryRepository.DATA_TYPE_MAX_TEMPERATURE;

update max;



        AndLogicalCondition condition = new AndLogicalCondition();
        condition.addComparisonCondition(new ComparisonCondition(QueryConstants.CREATED_DATE_FIELD, ComparisonOperators.EQUALS, QueryConstants.DateConstants.YESTERDAY));
        condition.addComparisonCondition(new ComparisonCondition(WeatherHistoryRepository.DATA_TYPE_FIELD, ComparisonOperators.EQUALS, QueryConstants.NULL_KEYWORD));

        QueryBuilder queryBuilder = new QueryBuilder()
                    .selectField(QueryConstants.ID_FIELD)
                    .fromObject(WeatherHistoryRepository.WEATHER_HISTORY_OBJECT_NAME)
                    .whereLogicalCondition(condition);
        System.debug(queryBuilder.build());

Database.executeBatch(new WeatherDataCleanupBatch());

Integer days = -5;
Weather_History__c minTemperature = WeatherHistoryRepository.getMinTemperatureByLocationForDate('Lucknow, UP, India', Date.today().addDays(days));
Weather_History__c maxTemperature = WeatherHistoryRepository.getMaxTemperatureByLocationForDate('Lucknow, UP, India', Date.today().addDays(days));

minTemperature.Data_Type__c = WeatherHistoryRepository.DATA_TYPE_MIN_TEMPERATURE;
maxTemperature.Data_Type__c = WeatherHistoryRepository.DATA_TYPE_MAX_TEMPERATURE;

update minTemperature;
update maxTemperature;

System.debug(WeatherHistoryRepository.getAvgTemperatureByLocationForDate('Lucknow, UP, India', Date.today().addDays(-5)));

System.debug(WeatherHistoryRepository.getMinMaxAvgWeatherHistoryByLocationForCurrentYear('Lucknow, UP, India'));