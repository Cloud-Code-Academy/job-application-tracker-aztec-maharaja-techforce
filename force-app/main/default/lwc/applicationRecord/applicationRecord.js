import { LightningElement, api, wire, track } from 'lwc';
import {getRecord} from 'lightning/uiRecordApi'
import STATUS_FIELD from '@salesforce/schema/Job_Application__c.Status__c';
import NAME_FIELD from '@salesforce/schema/Job_Application__c.Name';
import DATE_APPLIED_FIELD from '@salesforce/schema/Job_Application__c.Date_Applied__c';

import MyModal from 'c/myModal';
import INTERVIEW_OBJECT from '@salesforce/schema/Interview__c';
import SUBJECT_FIELD from '@salesforce/schema/Event.Subject';
import STARTDATETIME_FIELD from '@salesforce/schema/Event.StartDateTime';
import ENDDATETIME_FIELD from '@salesforce/schema/Event.EndDateTime';
import WHATID_FIELD from '@salesforce/schema/Event.WhatId';

const fields = [STATUS_FIELD, NAME_FIELD,DATE_APPLIED_FIELD]

export default class ApplicationRecord extends LightningElement {
    @api recordId;
    @track record;
    @track error
    status
    showComponent = false

    @wire(getRecord,{recordId:'$recordId',fields: fields}) 
    jobApplication({data,error}){
        if(data){
            this.record = data
            this.error = undefined
            this.status = data.fields.Status__c.value
            if(this.status == 'Applied'){
                this.showComponent = true
            } else {
                this.showComponent = false
            }
        } else if (error){
            this.error = error
            this.record = undefined
        }
    }

    get name() {
        return this.record.fields.Name.value
    }

    get dateApplied(){
        return this.record.fields.Date_Applied__c.value
    }



    handleOnClick(){
        this.openModal()
    }

    

    async openModal(){
        const result = await MyModal.open({
            // `label` is not included here in this example.
            // it is set on lightning-modal-header instead
            size: 'small',
            description: 'Accessible description of modal\'s purpose',
            objectApiName: INTERVIEW_OBJECT.objectApiName,
            applicationRecord: this.recordId
            // recordFields:[SUBJECT_FIELD,STARTDATETIME_FIELD,ENDDATETIME_FIELD,WHATID_FIELD]
        });
        // if modal closed with X button, promise returns result = 'undefined'
        // if modal closed with OK button, promise returns result = 'okay'
        console.log(result);
    }
}