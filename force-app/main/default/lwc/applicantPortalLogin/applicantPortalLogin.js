import { LightningElement, api, track, wire } from 'lwc';
import LightningModal from 'lightning/modal';
import { NavigationMixin } from 'lightning/navigation';
import isCandidateExistInSystem from '@salesforce/apex/JobApplHelper.isCandidateExistInSystem';

const columns = [
    { label: 'Job Title', fieldName: 'Job Title', type: 'string' },
    { label: 'Company Name', fieldName: 'Company Name', type: 'string' },
    { label: 'Date Applied', fieldName: 'Date Applied', type: 'string' },
    { label: 'Application Status', fieldName: 'Application Status', type: 'string' }
];

export default class ApplicantPortalLogin extends NavigationMixin(LightningModal) {
    @track APPLICANT_NOT_FOUND_ERROR_MESSAGE = "No job applications were found for the given email id.";
    @track applicantErrorMessage = false;
    @api applicantEmail = '';
    applicant_Id;
    jobsAppliedList;
  

    closeModal() {
        this.close();
    }

    handleChange(event) {
        let inputValue = event.target.value;
        if(event.target.name === "email_id") { 
            this.applicantEmail = inputValue;
            this.applicantErrorMessage = false;
        }
    }

    handleLogin(event) {
        try{
            isCandidateExistInSystem({email : this.applicantEmail})
            .then(jobsList => {
                if(Object.is(jobsList, null) || Object.is(jobsList, undefined)) {
                    this.applicantErrorMessage = true;
                    this.applicant_id = undefined;
                }
                else {
                    // alert('Applicant Id : ' + JSON.stringify(applicantId));
                    // this.applicant_Id = applicantId;
                    this.applicantErrorMessage = false;
                    // this.close();
                    this.jobsAppliedList = jobsList;
                    alert('Jobs List : ' + JSON.stringify(this.jobsAppliedList));
                    this.close();
                    this.navigateToApplicantView();
                    
                    }

            })
        }
        catch(error) {
            alert('Error occurred in applicant login : ' + error);
            this.applicant_Id = undefined;
            this.applicantErrorMessage = true;
        }
    }

    navigateToApplicantView() {
        let direction = {
            componentDef : 'c:Applicant_View'
        };
        let encodeDef = btoa(JSON.stringify(direction));
        this[NavigationMixin.Navigate]({
            type:'standard_webPage',
            attributes : {
                url : '/n/Jobs_Portal.app#' + encodeDef
            }
        })
    }
}