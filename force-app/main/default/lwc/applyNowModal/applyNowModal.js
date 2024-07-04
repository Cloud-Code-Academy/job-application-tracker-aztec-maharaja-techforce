import { LightningElement,api } from 'lwc';
import searchForJobPostingByPostingId from '@salesforce/apex/JobPostingHandler.searchForJobPostingByPostingId';
import searchForAccountByName from '@salesforce/apex/AccountHandler.searchForAccountByName';
import searchForCandidateByEmail from '@salesforce/apex/ContactHandler.searchForCandidateByEmail';
import createAccount from '@salesforce/apex/AccountHandler.createAccount';
import createJobPosting from '@salesforce/apex/JobPostingHandler.createJobPosting';
import createCandidate from '@salesforce/apex/ContactHandler.createCandidate';
import { createRecord } from 'lightning/uiRecordApi';
import JOB_APPLICATION_OBJECT from '@salesforce/schema/Job_Application__c';
import CANDIDATE_FIELD__c from '@salesforce/schema/Job_Application__c.Candidate__c';
import JOB_POSTING_FIELD__c from '@salesforce/schema/Job_Application__c.Job_Posting__c';
import STATUS_FIELD__c from '@salesforce/schema/Job_Application__c.Status__c';
import {ShowToastEvent} from 'lightning/platformShowToastEvent'



export default class ApplyNowModal extends LightningElement {
    @api jobdetails
    showSaveJobComponent
    firstName
    lastName
    email

    jobPost
    candidate

    // handleModal(){
    //     this.template.querySelector("section").classList.remove('slds-hide');
    //     this.template.querySelector("div.slds-backdrop").classList.remove('slds-hide');
    // }

    handleCancel(event){
        this.showSaveJobComponent = false
        const cancelButtonEvent = new CustomEvent('cancelmodal', {detail:this.showSaveJobComponent})
        this.dispatchEvent(cancelButtonEvent)
    }

    handleFirstNameChange(event){
        this.firstName = event.target.value
    }

    handleLastNameChange(event){
        this.lastName = event.target.value
    }

    handleEmailChange(event){
        this.email = event.target.value
    }

    async createJobApplicationRecord(){
        let inputFirstName = this.template.querySelector('.inputFirstName')
        let inputLastName = this.template.querySelector('.inputLastName')
        let inputEmail = this.template.querySelector('.inputEmail')
        const errorString = 'Please populate this field'

        if(!inputFirstName.value){
            inputFirstName.setCustomValidity(errorString)
            inputFirstName.reportValidity()
            return
        }
        if(!inputLastName.value){
            inputLastName.setCustomValidity(errorString)
            inputLastName.reportValidity()
            return
        }
        if(!inputEmail.value){
            inputEmail.setCustomValidity(errorString)
            inputEmail.reportValidity()
            return
        }
        const existingJobPosting = await searchForJobPostingByPostingId({postId: this.jobdetails.id})
        const existingAccount = await searchForAccountByName({name: this.jobdetails.company})
        const existingCandidate = await searchForCandidateByEmail({email:this.email})

        if(!existingCandidate) {
            const newCandidate = await createCandidate({firstName:this.firstName, lastName: this.lastName, email:this.email})
            this.candidate = newCandidate.Id
        }else{
            this.candidate = existingCandidate.Id
        }

        if(!existingAccount){
            const newAccount = await createAccount({name:this.jobdetails.company})
            const newJobPost = await createJobPosting({
                accountId:newAccount.Id, 
                jobPostingName:this.jobdetails.title,
                description: this.jobdetails.snippet,
                location: this.jobdetails.location,
                postId: this.jobdetails.id,
                salary: this.jobdetails.salary
                })
            this.jobPost = newJobPost.Id
        } else {
            if(!existingJobPosting){
                const newJobPost = await createJobPosting({
                    accountId: existingAccount.Id, 
                    jobPostingName:this.jobdetails.title,
                    description: this.jobdetails.snippet,
                    location: this.jobdetails.location,
                    postId: this.jobdetails.id,
                    salary: this.jobdetails.salary
                    })
                this.jobPost = newJobPost.Id
            } else{
                this.jobPost = existingJobPosting.Id
            }
        }

        const recordInput = {
            apiName: JOB_APPLICATION_OBJECT.objectApiName,
            fields:{
                [CANDIDATE_FIELD__c.fieldApiName]: this.candidate,
                [JOB_POSTING_FIELD__c.fieldApiName]: this.jobPost,
                [STATUS_FIELD__c.fieldApiName]: 'Saved'
            }
        };

        createRecord(recordInput).then((result) => {
            const success = new ShowToastEvent({
                title: 'Saved Job Succesfully',
                message: 'You have saved {0}',
                variant: 'success',
                messageData:[
                    {
                    url: 'https://capstone6-dev-ed.develop.lightning.force.com/' + result.id,
                    label: this.jobdetails.title
                }
            ]
            })
            this.dispatchEvent(success)

            this.handleCancel()
        }).catch(error =>{

            console.log('Error')
            console.log(error)
            console.log('Error.Message:')
            console.log(error.message)


            let errorMessage = error.body.output.errors[0].message
            errorMessage = errorMessage.replace(/(\r\n|\n|\r)/gm,"").slice(88,114)
            
            

            const fail = new ShowToastEvent({
                title: 'Something went wrong',
                message: errorMessage,
                variant: 'error'
            })
            this.dispatchEvent(fail)
        })
        


    }


}