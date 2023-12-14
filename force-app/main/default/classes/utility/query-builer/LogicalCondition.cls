public with sharing abstract class LogicalCondition {
    protected List<ComparisonCondition> conditions;
    protected List<LogicalCondition> logicalConditions;
    protected String logicalOperator;

    public LogicalCondition(String logicalOperator) {
        this.conditions = new List<ComparisonCondition>();
        this.logicalConditions = new List<LogicalCondition>();
        this.logicalOperator = logicalOperator;
    }

    public LogicalCondition addComparisonCondition(ComparisonCondition condition) {
        conditions.add(condition);
        return this;
    }

    public LogicalCondition addLogicalCondition(LogicalCondition condition) {
        logicalConditions.add(condition);
        return this;
    }

    public virtual override String toString() {
        String finalCondition = GlobalConstants.EMPTY_STRING;
        finalCondition += GlobalConstants.LEFT_PARENTHESIS;
        for (ComparisonCondition condition : conditions) {
            finalCondition += String.valueOf(condition) + GlobalConstants.WHITESPACE + logicalOperator + GlobalConstants.WHITESPACE;
        }

        for (LogicalCondition condition : logicalConditions) {
            finalCondition += String.valueOf(condition)  + GlobalConstants.WHITESPACE + logicalOperator + GlobalConstants.WHITESPACE;
        }

        finalCondition = finalCondition.removeEnd(GlobalConstants.WHITESPACE + logicalOperator + GlobalConstants.WHITESPACE);
        finalCondition += GlobalConstants.RIGHT_PARENTHESIS;

        return finalCondition;
    }
}
