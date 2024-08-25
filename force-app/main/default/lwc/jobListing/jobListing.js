import { LightningElement, api, track, wire} from 'lwc';
import JobApplModalPage from 'c/jobApplModalPage';
import ApplicantPortalLogin from 'c/applicantPortalLogin';
import PayCheckCalculator from 'c/payCheckCalculator';
import getOpenJobs from '@salesforce/apex/JobApplHelper.getOpenJobs';
import { NavigationMixin } from 'lightning/navigation';


export default class JobListing extends NavigationMixin(LightningElement) {
    @track JOB_SEARCH_ERROR_MESSAGE = "No Jobs found for the given location.";
    @track searchJobError = false;
    @api locationName = '';
    @track annualBaseSalary = '';
    openJobsList;        

    /* BEGIN FLOW ATTRIBUTES */
    flowName;
    inputVariables;
    flowFinish = 'NONE';
    size = 'small';
    flowLabel = '';
    showFooter = false;
    showHeader = false;
    flowDescription;
    disableClose = false;
    autoRefresh = false;
    /* END FLOW ATTRIBUTES */
    
    connectedCallback() {
        this.searchJobs();
    }

    handleChange(event) {
        let inputValue = event.target.value;
        if(event.target.name === "locationName") { 
            this.locationName = inputValue;
            this.searchJobError = false;
        }
    }

    searchJobs() {
        try {
            //this.openJobsList = getOpenJobs({ location : this.locationName });
            getOpenJobs({location : this.locationName})
            .then (jobsList => {
                if(Object.is(jobsList, null) || Object.is(jobsList, undefined) || jobsList.length == 0) {
                    this.openJobsList = undefined;
                    this.searchJobError = true;
                }
                else {
                    this.openJobsList = jobsList;
                    this.searchJobError = false;
                }
            })
            .catch(error => {
                alert('Error Occurred : ' + JSON.stringify(error));
                this.searchJobError = true;
            });            
        }
        catch(error) {
            alert('Entered to error block : ' + error);
            this.openJobsList = undefined;
            this.searchJobError = true;
        }
    }

    portalLogin() {
        ApplicantPortalLogin.open({
            size : 'small'
        });
        // this.navigateToApplicantView();
    }

    applyJob(event) {
            this.size = 'small';
            this.flowName = 'Job_Application_Screen';
            this.flowLabel = 'Job Application Screen';
            this.showHeader = false;
            this.showFooter = false;
            this.flowDescription = 'Job Application Screen';
            this.inputVariables = [{
                name: 'Job_Id',
                type: 'String',
                value: event.target.value
            }];
            this.flowFinish = 'STOP'
            this.handleFlowModal();
    }

    async calculateTakeHomePay(event) {
        this.annualBaseSalary = event.target.value;
        const result = await PayCheckCalculator.open({
            size: 'medium',
            annualBaseSalary : this.annualBaseSalary
        });
    }

    /* FLOW MODAL OPENING */

    async handleFlowModal() {
        try{
            this.result = await JobApplModalPage.open({
            size: this.size,
            flowName: this.flowName,
            header: this.flowLabel,
            flowModal: true,
            showHeader: this.showHeader,
            showFooter: this.showFooter,
            inputVariables: this.inputVariables,
            flowFinish: this.flowFinish,
            desription: this.flowDescription,
            disableClose: this.disableClose
        });
    }
        catch(error){
            console.log ('error in flow invoking : ' + error);
        }
    }
    
    navigateToApplicantView() {
        console.log('Navigating to applicant view page');
        let direction = {
            componentDef : 'c:applicantView'
        };
        let encodeDef = btoa(JSON.stringify(direction));
        console.log('encodeDef : ' + encodeDef);
        this[NavigationMixin.Navigate]({
            type:'standard__webPage',
            attributes : {
                url : '/one/one.app#' + encodeDef
            }
        });

        // this[NavigationMixin.Navigate]({
        //     type: 'standard__objectPage',
        //     attributes: {
        //         objectApiName: 'Account',
        //         actionName: 'new'
        //     }
        // });
    }
}