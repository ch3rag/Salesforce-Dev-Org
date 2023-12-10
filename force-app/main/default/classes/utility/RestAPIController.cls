public with sharing abstract class RestAPIController {

    private String apiEndPoint;
    private HttpRequest httpRequest;
    private HttpResponse httpResponse;
    private Map<String, String> requestParams;
    private String argAfterURLBeforeParams;

    private static final String FORWARD_SLASH = '/';
    private static final String QUESTION_MARK = '?';
    private static final String AMPERSAND = '&';
    private static final String EQUALS = '=';

    protected RestAPIController () {
        argAfterURLBeforeParams = '';
        requestParams = new Map<String, String>();
    }

    protected RestAPIController setRequestURL(String url) {
        apiEndPoint = url;
        return this;
    }

    protected RestAPIController addOrSetRequestURLParam(String key, String value) {
        requestParams.put(key, value);
        return this;
    }

    protected RestAPIController addArgAfterURLBeforeParams(String arg) {
        argAfterURLBeforeParams = arg;
        return this;
    }

    protected RestAPIController createHTTPRequest()  {
        httpRequest = new HttpRequest();
        return this;
    }

    protected RestAPIController setMethodGET() {
        httpRequest.setMethod(HttpConstants.GET_METHOD);
        return this;
    }

    protected RestAPIController setContentJSON() {
        httpRequest.setHeader(HttpConstants.CONTENT_TYPE, HttpConstants.APPLICATION_JSON);
        return this;
    }

    protected void submitRequest() {
        httpRequest.setEndpoint(createEndPointURL());
        Http http = new Http();
        try {
            httpResponse = http.send(httpRequest);
        } catch (System.CalloutException exp) {
            throw exp;
        }
    }

    private String addForwardSlash(String input) {
        if (input.right(1) != FORWARD_SLASH) {
            input += FORWARD_SLASH;
        }
        return input;
    }

    protected String createEndPointURL() {
        String finalURL =  apiEndPoint;
        finalURL = addForwardSlash(finalURL);
        finalURL += argAfterURLBeforeParams;
        finalURL += QUESTION_MARK;
        for (String key : requestParams.keySet()) {
            finalURL += (key + EQUALS + requestParams.get(key));
            finalURL += AMPERSAND;
        }
        finalURL = finalURL.removeEnd(AMPERSAND);
        return finalURL;
    }

    public String getStatus() {
        return httpResponse.getStatus();
    }

    public Integer getStatusCode() {
        return httpResponse.getStatusCode();
    }

    public Map<String, Object> getResponseBodyAsJSON() {
        return (Map<String, Object>) JSON.deserializeUntyped(httpResponse.getBody());
    }
}