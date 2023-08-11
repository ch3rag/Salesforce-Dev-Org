CTStatusUpdateSchedule updateSchedule = new CTStatusUpdateSchedule();

Id jobId = System.schedule('Person/Location Status Update Job', CTStatusUpdateSchedule.CRON, updateSchedule);

System.debug(jobId);