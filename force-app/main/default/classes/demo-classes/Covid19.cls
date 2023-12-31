public class Covid19 {
    private Integer recoveredInArea = 0;
    public static Integer recoveredInCountry = 0;

    public Covid19(Integer recoveredInArea) {
        if (recoveredInArea < 0) {
            recoveredInArea = 0;
        }
        this.recoveredInArea = recoveredInArea;
        recoveredInCountry += recoveredInArea;
    }

    public void treatPatient() {
        recoveredInArea++;
        recoveredInCountry++;
    }

    public Integer getTreated() {
        return recoveredInArea;
    }
}
