import { LightningElement, api, wire } from 'lwc';
import joobleCallout from '@salesforce/apex/JoobleController.joobleCallout';

export default class SearchJobForm extends LightningElement {
    jobTitle;
    location;
    jobListFromForm;
    error;

    handleTitleChange(event){
        this.jobTitle = event.target.value;
    }

    handleLocationChange(event){
        this.location = event.target.value;
    }

    async handleSubmit(){
        try{
            this.jobListFromForm = await joobleCallout({keyword: this.jobTitle, location: this.location});
            this.error = undefined;
        } catch(error){
            this.error = error;
            this.jobListFromForm = undefined;
        }
    }
}