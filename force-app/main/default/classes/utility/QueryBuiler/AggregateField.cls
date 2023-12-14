public with sharing class AggregateField {
    private String fieldName;
    private QueryConstants.AggregateOperators operator;

    public AggregateField(String fieldName, QueryConstants.AggregateOperators operator) {
        this.fieldName = fieldName;
        this.operator = operator;
    }

    public override String toString() {
        return String.valueOf(operator) + GlobalConstants.LEFT_PARENTHESIS + fieldName + GlobalConstants.RIGHT_PARENTHESIS;
    }
}
