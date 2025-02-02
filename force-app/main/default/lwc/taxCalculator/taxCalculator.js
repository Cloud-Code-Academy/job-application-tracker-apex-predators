import { LightningElement, wire, api } from 'lwc';  
import { getRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';  
import { RefreshEvent } from 'lightning/refresh';  

// CONSTANTS
const fieldsFromRecord = ['Job_Application__c.Salary__c']; // Field API name from the record
const medicareWithholdingRate = 0.0145;
const socialSecurityWithholdingRate = 0.062;

const federalWithholdingRate = [
    // Federal tax brackets for 2025 (assuming Single Filer)
    { minEarnings: 0, maxEarnings: 11925, rate: 0.10 },
    { minEarnings: 11926, maxEarnings: 48475, rate: 0.12 },
    { minEarnings: 48476, maxEarnings: 103350, rate: 0.22 },
    { minEarnings: 103351, maxEarnings: 197300, rate: 0.24 },
    { minEarnings: 197301, maxEarnings: 250525, rate: 0.32 },
    { minEarnings: 250526, maxEarnings: 626350, rate: 0.35 },
    { minEarnings: 626351, maxEarnings: Infinity, rate: 0.37 }
];

export default class TaxCalculator extends LightningElement {
    
    // Record and Tax-Related Properties
    @api recordId;
    salaryFromRecord = 0;
    totalTaxes = 0;
    
    // Tax Breakdown
    fedTaxOwed = 0;
    socialSecurityTaxOwed = 0;
    medicareTaxOwed = 0;

    // Salary Breakdown
    yearlyPay = 0;
    sixMonthPay = 0;
    monthlyPay = 0;
    biWeeklyPay = 0;
    weeklyPay = 0;

    // Formatted Display Values
    formattedSalaryFromRecord = '0.00';
    formattedTotalTaxes = '0.00';
    formattedFedTaxOwed = '0.00';
    formattedSocialSecurityTaxOwed = '0.00';
    formattedMedicareTaxOwed = '0.00';
    formattedYearlyPay = '0.00';
    formattedSixMonthPay = '0.00';
    formattedMonthlyPay = '0.00';
    formattedBiWeeklyPay = '0.00';
    formattedWeeklyPay = '0.00';

    // Wire Service to Fetch Salary Data
    @wire(getRecord, { 
        recordId: '$recordId', 
        fields: fieldsFromRecord 
    })
    wiredRecord({ error, data }) {
        if (data) {
            console.log("Record Data:", data);
            this.salaryFromRecord = data.fields.Salary__c.value || 0;
            this.handleCalculations();
        } else if (error) {
            console.error('Error retrieving record:', error);
        }
    }

    // Notify record updates
    handleRecordUpdate() {
        getRecordNotifyChange([this.recordId]);
    }

    // Refresh view
    refreshView() {
        this.dispatchEvent(new RefreshEvent());
    }

    // Perform Salary and Tax Calculations
    handleCalculations() {
        console.log("Running handleCalculations...");
        console.log(`Salary from record: ${this.salaryFromRecord}`);

        let fedTaxOwed = 0;
        let remainingSalary = this.salaryFromRecord;

        // Calculate Federal Tax Using Brackets
        for (const bracket of federalWithholdingRate) {
            if (remainingSalary > bracket.minEarnings) {
                let taxableAmount = Math.min(remainingSalary, bracket.maxEarnings) - bracket.minEarnings;
                let taxForBracket = taxableAmount * bracket.rate;
                fedTaxOwed += taxForBracket;
            } else {
                break; // Stop when salary is fully processed
            }
        }

        // Assign Raw Tax Values
        this.fedTaxOwed = fedTaxOwed;
        this.socialSecurityTaxOwed = this.salaryFromRecord * socialSecurityWithholdingRate;
        this.medicareTaxOwed = this.salaryFromRecord * medicareWithholdingRate;
        this.totalTaxes = this.fedTaxOwed + this.socialSecurityTaxOwed + this.medicareTaxOwed;

        // Calculate Pay Breakdown After Taxes
        this.yearlyPay = this.salaryFromRecord - this.totalTaxes;
        this.sixMonthPay = this.yearlyPay / 2;
        this.monthlyPay = this.yearlyPay / 12;
        this.biWeeklyPay = this.yearlyPay / 26;
        this.weeklyPay = this.yearlyPay / 52;

        // Calls formatValues method to format the values for display as lightning-input 
        this.formatValues();

        console.log(`Fed Tax Owed: ${this.fedTaxOwed}, Social Security: ${this.socialSecurityTaxOwed}, Medicare: ${this.medicareTaxOwed}`);
    }

    // Format Numeric Values for Display
    formatValues() {
        this.formattedSalaryFromRecord = this.formatNumber(this.salaryFromRecord);
        this.formattedTotalTaxes = this.formatNumber(this.totalTaxes);
        this.formattedFedTaxOwed = this.formatNumber(this.fedTaxOwed);
        this.formattedSocialSecurityTaxOwed = this.formatNumber(this.socialSecurityTaxOwed);
        this.formattedMedicareTaxOwed = this.formatNumber(this.medicareTaxOwed);
        this.formattedYearlyPay = this.formatNumber(this.yearlyPay);
        this.formattedSixMonthPay = this.formatNumber(this.sixMonthPay);
        this.formattedMonthlyPay = this.formatNumber(this.monthlyPay);
        this.formattedBiWeeklyPay = this.formatNumber(this.biWeeklyPay);
        this.formattedWeeklyPay = this.formatNumber(this.weeklyPay);
    }

    // Helper Method to Format Numbers
    formatNumber(value) {
        return value.toLocaleString(undefined, { maximumFractionDigits: 2, minimumFractionDigits: 2 });
    }

    // Handle Salary Input Change
    updateSalary(event) {
        console.log(`Raw input value: ${event.target.value}`);
        
        this.salaryFromRecord = event.target.value ? Number(event.target.value) : 0;
    
        console.log(`Converted salary: ${this.salaryFromRecord}`);
        
        this.handleCalculations();
    }
}
