public with sharing class QueryBuilder {
    private String sObjectName;
    private Set<String> selectedFields;
    private Set<String> groupFields;
    private List<OrderField> orderFields;
    private List<AggregateField> aggregateFields;
    private List<LogicalCondition> conditions;
    private String sortingOrder;
    private Integer limitValue;

    public QueryBuilder() {
        selectedFields = new Set<String>();
        groupFields = new Set<String>();
        orderFields = new List<OrderField>();
        aggregateFields = new List<AggregateField>();
        conditions = new List<LogicalCondition>();
        limitValue = QueryConstants.NO_LIMIT;
    }

    public QueryBuilder selectField(String fieldName) {
        selectedFields.add(fieldName);
        return this;
    }

    public QueryBuilder selectAggregateField(String fieldName, QueryConstants.AggregateOperators operator) {
        aggregateFields.add(new AggregateField(fieldName, operator));
        return this;
    }

    public QueryBuilder selectAllFields(List<String> fieldNames) {
        selectedFields.addAll(fieldNames);
        return this;
    }

    public QueryBuilder fromObject(String objectName) {
        sObjectName = objectName;
        return this;
    }

    public QueryBuilder whereLogicalCondition(LogicalCondition condition) {
        conditions.add(condition);
        return this;
    }

    public QueryBuilder orderByAscending(String field) {
        orderFields.add(new OrderField(field).sortAscending());
        return this;
    }

    public QueryBuilder orderByDescending(String field) {
        orderFields.add(new OrderField(field).sortDescending());
        return this;
    }

    public QueryBuilder orderBy(OrderField field) {
        orderFields.add(field);
        return this;
    }

    public QueryBuilder groupBy(String field) {
        groupFields.add(field);
        return this;
    }

    public QueryBuilder groupByAll(List<String> fields) {
        groupFields.addAll(fields);
        return this;
    }

    public QueryBuilder limitRecords(Integer limitValue) {
        this.limitValue = limitValue;
        return this;
    }

    public String build() {
        String finalQuery = GlobalConstants.EMPTY_STRING;

        finalQuery += QueryConstants.SELECT_KEYWORD + GlobalConstants.WHITESPACE;
        for (String selectField : selectedFields) {
            finalQuery += selectField + GlobalConstants.COMMA_WITH_WHITESPACE;
        }

        for (AggregateField field : aggregateFields) {
            finalQuery += String.valueOf(field) + GlobalConstants.COMMA_WITH_WHITESPACE;
        }

        finalQuery = finalQuery.removeEnd(GlobalConstants.COMMA_WITH_WHITESPACE);

        finalQuery += GlobalConstants.WHITESPACE + QueryConstants.FROM_KEYWORD;
        finalQuery += GlobalConstants.WHITESPACE + sObjectName; 

        if (conditions.size() > 0) {
            finalQuery += GlobalConstants.WHITESPACE + QueryConstants.WHERE_KEYWORD;
            for (LogicalCondition condition : conditions) {
                finalQuery += GlobalConstants.WHITESPACE;
                finalQuery += String.valueOf(condition);
            }
        }

        if (groupFields.size() > 0) {
            finalQuery += GlobalConstants.WHITESPACE + QueryConstants.GROUP_BY_KEYWORD  + GlobalConstants.WHITESPACE;
            for (String groupField : groupFields) {
                finalQuery += groupField + GlobalConstants.COMMA_WITH_WHITESPACE;
            }
            finalQuery = finalQuery.removeEnd(GlobalConstants.COMMA_WITH_WHITESPACE);
        }

        if (orderFields.size() > 0) {
            finalQuery += GlobalConstants.WHITESPACE + QueryConstants.ORDER_BY_KEYWORD + GlobalConstants.WHITESPACE;
            for (OrderField orderField : orderFields) {
                finalQuery += String.valueOf(orderField) + GlobalConstants.COMMA_WITH_WHITESPACE;
            }
            finalQuery = finalQuery.removeEnd(GlobalConstants.COMMA_WITH_WHITESPACE);
        }

        if (limitValue > QueryConstants.NO_LIMIT) {
            finalQuery += GlobalConstants.WHITESPACE + QueryConstants.LIMIT_KEYWORD + GlobalConstants.WHITESPACE + limitValue;
        }

        return finalQuery;
    }
}
