public with sharing class DateTimeUtility {

    private static final Integer ELEVEN = 11;
    private static final Integer FIFTY_NINE = 59;
    private static final Integer NINE_HUNDRED_NINETY_NINE = 999;
    private static final String FORMAT = 'yyyy-MM-dd\'T\'HH:mm:ssZ';
    public static Time getTimeEOD() {
        return Time.newInstance(ELEVEN, FIFTY_NINE, FIFTY_NINE, NINE_HUNDRED_NINETY_NINE);
    }

    public static DateTime getDateTimeSOD(Date dateValue) {
        return DateTime.newInstanceGmt(dateValue.year(), dateValue.month(), dateValue.day());
    }

    public static DateTime getDateTimeEOD(Date dateValue) {
        return DateTime.newInstanceGmt(dateValue, getTimeEOD());
    }

    public static String getDateTimeFormatted(DateTime dateTimeValue) {
        return dateTimeValue.formatGmt(FORMAT);
    }
}