import { LightningElement, api, track, wire } from 'lwc';
import LightningModal from 'lightning/modal';
import isCandidateExistInSystem from '@salesforce/apex/JobApplHelper.isCandidateExistInSystem';

export default class ApplicantPortalLogin extends LightningModal {
    @track APPLICANT_NOT_FOUND_ERROR_MESSAGE = "No job applications were found for the given email id.";
    @track applicantErrorMessage = false;
    @api applicantEmail = '';
    applicant_Id;

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
            .then(applicantId => {
                if(Object.is(applicantId, null) || Object.is(applicantId, undefined)) {
                    this.applicantErrorMessage = true;
                    this.applicant_id = undefined;
                }
                else {
                    alert('Applicant Id : ' + JSON.stringify(applicantId));
                    this.applicant_Id = applicantId;
                    this.applicantErrorMessage = false;
                    this.close();
                }
            })
        }
        catch(error) {
            alert('Error occurred in applicant login : ' + error);
            this.applicant_Id = undefined;
            this.applicantErrorMessage = true;
        }
    }
}