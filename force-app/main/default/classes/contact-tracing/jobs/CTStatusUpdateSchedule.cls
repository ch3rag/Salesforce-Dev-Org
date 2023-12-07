public with sharing class CTStatusUpdateSchedule implements Schedulable {
    public static final String CRON = '00 00 03 * * ?';

    public void execute(SchedulableContext sc) {
        CTUpdatePersonStatusBatch personStatusUpdateBatch = new CTUpdatePersonStatusBatch();
        Database.executeBatch(personStatusUpdateBatch, 2000);

        CTLocationStatusUpdateBatch locationStatusUpdateBatch = new CTLocationStatusUpdateBatch();
        Database.executeBatch(locationStatusUpdateBatch, 2000);
    }
}
