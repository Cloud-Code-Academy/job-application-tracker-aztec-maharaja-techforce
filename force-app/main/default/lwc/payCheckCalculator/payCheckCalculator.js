import { LightningElement, api, track } from 'lwc';
import LightningModal from 'lightning/modal';
import calculatePayAndTaxes from '@salesforce/apex/PayCheckCalculator.calculatePayAndTaxes';

export default class PayCheckCalculator extends LightningModal {
    @api annualBaseSalary;
    @track annualGrossSalary;
    @track filingStatus = 'Single';
    @track age;
    @track taxableIncome;
    @track netAnnualIncome;
    @track netHalfYearlyIncome;
    @track netMonthlyIncome;
    @track netBimonthlyIncome;
    @track netBiweeklyIncome;    
    @track taxRate;
    @track estimatedFedTax;
    @track balanceFedTax;
    @track socialSecTax;
    @track medicareTax;
    @track k401 = 0;
    @track ira = 0;
    @track hsa = 0;
    @track fsa = 0;
    @track otherContributions = 0;
    @track itemizedDeductions = 0;
    @track taxesWithheld = 0;
    @track itemized = false;
    @track sDeductionValue;
    @track filingStatusOptions = [
        {
            label : 'Single',
            value : 'Single'
        },
        {
            label : 'Married, filing jointly',
            value : 'Married, filing jointly'
        },
        {
            label : 'Married, filing separately',
            value : 'Married, filing separately'
        },
        {
            label : 'Head of household',
            value : 'Head of household'
        }
    ]
    @track dedOptionValue = 'Standard';
    @track dedOptions = [
        {
            label : 'Standard Deduction',
            value : 'Standard'
        },
        {
            label : 'Itemize Deductions',
            value : 'Itemize'
        }
    ]


    connectedCallback() {
        this.annualGrossSalary = (this.annualBaseSalary).substr(1);
        try{
            this.calculateTaxWithholding();
        }
        catch(error) {
            alert('Error Occurred in calling calculateTaxWithHolding method : ' + error);
        }
      }

    handleDataChange(event) {
        if(event.target.label === 'Tax filing status') {
            this.filingStatus = event.target.value;
        }
        else if(event.target.label === 'Income') {
            this.annualGrossSalary = event.target.value;
        }
        else if(event.target.label === '401k') {
            if(event.target.value == null || event.target.value == undefined || event.target.value == '') {
                this.k401 = 0;
            }
            else {
                this.k401 = event.target.value;
            }   
        }
        else if(event.target.label === 'Ira') {
            if(event.target.value == null || event.target.value == undefined || event.target.value == '') {
                this.ira = 0;
            }
            else {
                this.ira = event.target.value;
            }
        }
        else if(event.target.label === 'TaxWithHeld') {
            if(event.target.value == null || event.target.value == undefined || event.target.value == '') {
                this.taxesWithheld = 0;
            }
            else {
                this.taxesWithheld = event.target.value;
            }
        }
        else if(event.target.label === 'Deductions')  {
            this.dedOptionValue = event.target.value;
            if(event.target.value === 'Standard') {
                this.itemized = false;
            }
            else {
                this.itemized = true;
            }
        }
        else if(event.target.label = 'ItemizedDeduction') {
            if(event.target.value == null || event.target.value == undefined || event.target.value == '') {
                this.itemizedDeductions = 0;
            }
            else {
                this.itemizedDeductions = event.target.value;
            }
        }
        else if(event.target.label === 'HSA') {
            if(event.target.value == null || event.target.value == undefined || event.target.value == '') {
                this.hsa = 0;
            }
            else {
                this.hsa = event.target.value;
            }
        }
        else if(event.target.label === 'FSA') {
            if(event.target.value == null || event.target.value == undefined || event.target.value == '') {
                this.fsa = 0;
            }
            else {
                this.fsa = event.target.value;
            }
        }
        else if(event.target.label === 'OtherContributions') {
            if(event.target.value == null || event.target.value == undefined || event.target.value == '') {
                this.otherContributions = 0;
            }
            else {
                this.otherContributions = event.target.value;
            }
        }

        this.calculateTaxWithholding();
    }

    async calculateTaxWithholding() {
        // Create the javascript object that mimics  DeductionsContributions - inner class definition from PayCheckCalculator apex class

        let innerClassObject = {
            k401 : this.k401,
            ira : this.ira,
            hsa : this.hsa,
            fsa : this.fsa,
            otherContributions : this.otherContributions,
            itemizedDeductions : this.itemizedDeductions,
            taxesWithheld : this.taxesWithheld
        };

        try {
            calculatePayAndTaxes({filingStatus : this.filingStatus, grossIncome : this.annualGrossSalary, age : this.age, dedContributions : innerClassObject, deductionStatus : this.dedOptionValue})
            .then (calculatedTaxes => {
                if(Object.is(calculatedTaxes, null) || Object.is(calculatedTaxes, undefined) || calculatedTaxes.length == 0) {
                    this.taxCalculationError = true;
                }
                else {
                    this.taxableIncome = calculatedTaxes['Taxable Income'];
                    this.taxRate = calculatedTaxes['Federal Tax Rate'];
                    this.estimatedFedTax = calculatedTaxes['Estimated Federal Taxes'];
                    this.balanceFedTax = calculatedTaxes['Balance Federal Taxes'];
                    this.socialSecTax = calculatedTaxes['Social Security Taxes'];
                    this.medicareTax = calculatedTaxes['Medicare Withholding'];
                    this.netAnnualIncome = calculatedTaxes['Net Annual Take Homepay'];
                    this.netHalfYearlyIncome = calculatedTaxes['Net Take Home Pay - 6 months'];
                    this.netMonthlyIncome = calculatedTaxes['Net Take Home Pay - Monthly'];
                    this.netBimonthlyIncome = calculatedTaxes['Net Take Home Pay - Bi-monthly'];
                    this.netBiweeklyIncome = calculatedTaxes['Net Take Home Pay - Bi-weekly'];
                    this.sDeductionValue = calculatedTaxes['Standard Deduction'];
                }
            })
            .catch(error => {
                alert('Error Occurred : ' + JSON.stringify(error));
                this.taxCalculationError = true;
            });            
        }
        catch(error) {
            alert('Entered to error block : ' + error);
            this.taxCalculationError = true;
        }
    }
}