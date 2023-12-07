public with sharing class CTDataCleanupSchedule implements Schedulable {
    public static final String CRON = '00 00 02 * * ?';

    public void execute(SchedulableContext sc) {
        CTPeopleTracingDataCleanupBatch peopleTracingCleanupBatch = new CTPeopleTracingDataCleanupBatch();
        Database.executeBatch(peopleTracingCleanupBatch, 2000);


        CTLocationTracingDataCleanupBatch locationTracingCleanupBatch = new CTLocationTracingDataCleanupBatch();
        Database.executeBatch(locationTracingCleanupBatch, 2000);
    }
}
