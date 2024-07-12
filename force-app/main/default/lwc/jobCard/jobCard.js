import { LightningElement,api } from 'lwc';

export default class JobCard extends LightningElement {
    @api jobs
    jobDetails
    showSaveJobComponent = false

    handleSaveJob(event){
        const itemIndex = event.currentTarget.dataset.index
        this.jobDetails = this.jobs[itemIndex]
        this.showSaveJobComponent = true
        // console.log(this.jobDetails)
        
    }

    handleCancelModal(event){
        this.showSaveJobComponent = event.detail
    }
}