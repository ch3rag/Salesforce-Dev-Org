public with sharing class QueryConstants {
    public static final String SELECT_KEYWORD = 'SELECT';
    public static final String FROM_KEYWORD = 'FROM';
    public static final String WHERE_KEYWORD = 'WHERE';
    public static final String ORDER_BY_KEYWORD = 'ORDER BY';
    public static final String GROUP_BY_KEYWORD = 'GROUP BY';
    public static final String DESC_KEYWORD = 'DESC';
    public static final String ASC_KEYWORD = 'ASC';
    public static final String LIMIT_KEYWORD = 'LIMIT';
    public static final Integer NO_LIMIT = -1;

    public enum DateConstants {
        TODAY
    }

    public enum AggregateOperators {
        MIN,
        MAX,
        AVG
    }
}
