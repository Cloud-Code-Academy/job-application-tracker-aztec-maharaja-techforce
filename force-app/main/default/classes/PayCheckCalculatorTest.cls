/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class PayCheckCalculatorTest {

    // @isTest
    // static void testCalculatePayAndTaxes() {
    //     String filingStatus = 'Single';
    //     Double income = 140000;
    //     Integer age = 52;
    //     PayCheckCalculator.DeductionsContributions dedContributions = new PayCheckCalculator.DeductionsContributions();
    //     dedContributions.k401 = 15000;
    //     dedContributions.ira = 0;
    //     dedContributions.hsa = 7500;
    //     dedContributions.fsa = 0;
    //     dedContributions.otherContributions = 0;
    //     dedContributions.itemizedDeductions = 0;
    //     dedContributions.taxesWithheld = 0;

    //     Test.startTest();
    //     Map<String, Double> taxResult = PayCheckCalculator.calculatePayAndTaxes(filingStatus, income, age, dedContributions);
    //     Test.stopTest();

    //     Set<String> mapKeys = new Set<String>{'Taxable Income', 'Federal Tax Rate', 'Estimated Federal Taxes', 'Social Security Taxes', 'Medicare Withholding','Net Annual Take Homepay',
    //                                             'Net Take Home Pay - 6 months', 'Net Take Home Pay - Monthly', 'Net Take Home Pay - Bi-monthly', 'Net Take Home Pay - Bi-weekly'};
    //     System.assertEquals(mapKeys, taxResult.keySet(), 'Result Map keys does not match with expected keys');
    // }
}