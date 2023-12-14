public with sharing class OrderField {
    private String fieldName;
    private String sortOrder;

    public OrderField(String fieldName) {
        this.fieldName = fieldName;
    }

    public OrderField sortDescending() {
        this.sortOrder = QueryConstants.DESC_KEYWORD;
        return this;
    }

    public OrderField sortAscending() {
        this.sortOrder = QueryConstants.ASC_KEYWORD;
        return this;
    }

    public override String toString() {
        return fieldName + GlobalConstants.WHITESPACE + sortOrder;
    }
}