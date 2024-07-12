public with sharing class PayCheckCalculator {
    public static final Map<String, Double> standardDeductionMap = new Map<String, Double>{'Single' => 13850, 
                                                                                    'Married, filing jointly' => 27700, 
                                                                                    'Married, filing separately' => 13850, 
                                                                                    'Head of household' => 20800};

    public PayCheckCalculator() {

    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Double> calculatePayAndTaxes(String filingStatus, Double grossIncome, Integer age, DeductionsContributions dedContributions, String deductionStatus) {
        Double taxableIncome = 0;
        Double federalTaxRate = 0.0;
        Double estimatedFedTaxes = 0;
        Double standardDeduction = standardDeductionMap.get(filingStatus);
        Double netIncome = 0;
        Double socialSecurityTaxes = 0;
        Double medicareWithholding = 0;
        Double taxDeductedFromPayCheck = 0;
        Double federalTaxBalance = 0;

        taxableIncome = grossIncome - (dedContributions.k401 + dedContributions.ira + dedContributions.hsa + dedContributions.fsa + dedContributions.otherContributions);
        if(deductionStatus == 'Standard') {
            taxableIncome -= standardDeduction;
        }
        else {
            taxableIncome -= dedContributions.itemizedDeductions; 
            standardDeduction = 0;
        }

        taxDeductedFromPayCheck = dedContributions.taxesWithheld;
        estimatedFedTaxes = calculateFedTax(filingStatus, taxableIncome);
        federalTaxBalance = estimatedFedTaxes - taxDeductedFromPayCheck;
        socialSecurityTaxes = calculateSocialSecurityTax(taxableIncome);
        medicareWithholding = calculateMedicareWithholding(taxableIncome);

        netIncome = grossIncome - estimatedFedTaxes - socialSecurityTaxes - medicareWithholding - dedContributions.k401 - dedContributions.hsa - dedContributions.ira - dedContributions.fsa - dedContributions.otherContributions;
        federalTaxRate = Decimal.valueOf((estimatedFedTaxes / grossIncome));
        return new Map<String, Double>{'Taxable Income' => taxableIncome, 
                                        'Federal Tax Rate' => federalTaxRate, 
                                        'Estimated Federal Taxes' => estimatedFedTaxes,
                                        'Balance Federal Taxes' => federalTaxBalance,
                                        'Social Security Taxes' => socialSecurityTaxes,
                                        'Medicare Withholding' => medicareWithholding,
                                        'Net Annual Take Homepay' => netIncome,
                                        'Net Take Home Pay - 6 months' => (netIncome / 2),
                                        'Net Take Home Pay - Monthly' => (netIncome / 12),
                                        'Net Take Home Pay - Bi-monthly' => (netIncome / 24),
                                        'Net Take Home Pay - Bi-weekly' => (netIncome / 26),
                                        'Standard Deduction' => standardDeduction};
    }

    public class DeductionsContributions {
        @AuraEnabled
        public Double k401 { get; set; }
        @AuraEnabled
        public Double ira { get; set; }
        @AuraEnabled
        public Double hsa { get; set; }
        @AuraEnabled
        public Double fsa { get; set; }
        @AuraEnabled
        public Double otherContributions { get; set; }
        @AuraEnabled
        public Double taxesWithheld { get; set; }
        @AuraEnabled 
        public Double itemizedDeductions { get; set; }
    }

    public static Double calculateFedTax(String filingStatus, Double taxIncome) {
        Double taxSlab = 37;
        switch on (filingStatus) {
            when 'Single' {
                if(taxIncome > 0 && taxIncome <= 11000) {
                    taxSlab = 10;
                }
                else if(taxIncome > 11001 && taxIncome <= 44725) {
                    taxSlab = 12;
                }
                else if(taxIncome > 44726 && taxIncome <= 95375) {
                    taxSlab = 22;
                }
                else if(taxIncome > 95376 && taxIncome <= 182100) {
                    taxSlab = 24;
                }
                else if(taxIncome > 182101 && taxIncome <= 231250) {
                    taxSlab = 32;
                }
                else if(taxIncome > 231251 && taxIncome <= 578125) {
                    taxSlab = 35;
                }
                else {
                    taxSlab = 37;
                }
            }
            when 'Married, filing jointly' {
                if(taxIncome > 0 && taxIncome <= 22000) {
                    taxSlab = 10;
                }
                else if(taxIncome > 22001 && taxIncome <= 89450) {
                    taxSlab = 12;
                }
                else if(taxIncome > 89451 && taxIncome <= 190750) {
                    taxSlab = 22;
                }
                else if(taxIncome > 190751 && taxIncome <= 364200) {
                    taxSlab = 24;
                }
                else if(taxIncome > 364201 && taxIncome <= 462500) {
                    taxSlab = 32;
                }
                else if(taxIncome > 462501 && taxIncome <= 693750) {
                    taxSlab = 35;
                }
                else {
                    taxSlab = 37;
                }
            }
            when 'Married, filing separately' {
                if(taxIncome > 0 && taxIncome <= 11000) {
                    taxSlab = 10;
                }
                else if(taxIncome > 11001 && taxIncome <= 44725) {
                    taxSlab = 12;
                }
                else if(taxIncome > 44726 && taxIncome <= 95375) {
                    taxSlab = 22;
                }
                else if(taxIncome > 95376 && taxIncome <= 182100) {
                    taxSlab = 24;
                }
                else if(taxIncome > 182101 && taxIncome <= 231250) {
                    taxSlab = 32;
                }
                else if(taxIncome > 231251 && taxIncome <= 346875) {
                    taxSlab = 35;
                }
                else {
                    taxSlab = 37;
                }
            }
            when 'Head of household' {
                if(taxIncome > 0 && taxIncome <= 15700) {
                    taxSlab = 10;
                }
                else if(taxIncome > 15701 && taxIncome <= 59850) {
                    taxSlab = 12;
                }
                else if(taxIncome > 59851 && taxIncome <= 95350) {
                    taxSlab = 22;
                }
                else if(taxIncome > 95351 && taxIncome <= 182100) {
                    taxSlab = 24;
                }
                else if(taxIncome > 182101 && taxIncome <= 231250) {
                    taxSlab = 32;
                }
                else if(taxIncome > 231251 && taxIncome <= 578100) {
                    taxSlab = 35;
                }
                else {
                    taxSlab = 37;
                }
            }
        }
        return (taxIncome * taxSlab)/100;
    }

    public static Double calculateSocialSecurityTax(Double taxIncome) {
        return (taxIncome * 6.2)/100;
    }

    public static Double calculateMedicareWithholding(Double taxIncome) {
        return (taxIncome * 1.45)/100;
    }
}