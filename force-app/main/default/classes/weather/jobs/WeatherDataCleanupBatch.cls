public with sharing class WeatherDataCleanupBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        AndLogicalCondition condition = new AndLogicalCondition();
        condition.addComparisonCondition(new ComparisonCondition(QueryConstants.CREATED_DATE_FIELD, ComparisonOperators.EQUALS, QueryConstants.DateConstants.TODAY));
        condition.addComparisonCondition(new ComparisonCondition(WeatherHistoryRepository.DATA_TYPE_FIELD, ComparisonOperators.EQUALS, QueryConstants.NULL_KEYWORD));

        QueryBuilder queryBuilder = new QueryBuilder()
                    .selectField(QueryConstants.ID_FIELD)
                    .fromObject(WeatherHistoryRepository.WEATHER_HISTORY_OBJECT_NAME)
                    .whereLogicalCondition(condition);
        return Database.getQueryLocator(queryBuilder.build());
    }

    public void execute(Database.BatchableContext bc, List<Weather_History__c> scope) {
        delete scope;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Weather Cleanup Batch Complete.');
    }
}
