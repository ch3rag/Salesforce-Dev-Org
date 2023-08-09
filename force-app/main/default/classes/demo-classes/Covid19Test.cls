@isTest
public class Covid19Test {
    @IsTest
    public static void treatPatientTest() {
        Covid19 jaipur = new Covid19(10);
        System.assertEquals(10, jaipur.getTreated(), 'Treated count does not match');

        Covid19 hyd = new Covid19(112);
        System.assertEquals(112, hyd.getTreated(), 'Treated count does not match');

        // Check Recovered In Country
        System.assertEquals(122, Covid19.recoveredInCountry, 'Treated count does not match');

        jaipur.treatPatient();
        System.assert(11 == jaipur.getTreated(), 'getTreated() assertion failed');
        System.assert(123 == Covid19.recoveredInCountry, 'getTreated() assertion failed');
    }

    @IsTest
    public static void treatPatientTestNegative() {
        Covid19 jaipur = new Covid19(-1);
        System.assertEquals(0, jaipur.getTreated(), 'getTreated() assertion failed');
    }
}
