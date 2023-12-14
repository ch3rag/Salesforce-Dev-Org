public with sharing class ComparisonCondition {
    private String operator;
    private String fieldName;
    private String value;
    private Boolean isValueString;


    public ComparisonCondition(String fieldName, String operator, String value) {
        this.fieldName = fieldName;
        this.operator = operator;
        this.value = value;
        this.isValueString = true;
    }

    public ComparisonCondition(String fieldName, String operator, Integer value) {
        this(fieldName, operator, String.valueOf(value));
        isValueString = false;
    }

    public ComparisonCondition(String fieldName, String operator, QueryConstants.DateConstants value) {
        this(fieldName, operator, String.valueOf(value));
        isValueString = false;
    }

    public ComparisonCondition(String fieldName, String operator, DateTime value) {
        this(fieldName, operator, DateTimeUtility.getDateTimeFormatted(value));
        isValueString = false;
    }

    public override String toString() {
        String finalCondition = fieldName + GlobalConstants.WHITESPACE + operator + GlobalConstants.WHITESPACE;
        if (isValueString) {
            finalCondition += GlobalConstants.SINGLE_QUOTE + value + GlobalConstants.SINGLE_QUOTE;
        } else {
            finalCondition += value;
        }

        return finalCondition;
    }
}
