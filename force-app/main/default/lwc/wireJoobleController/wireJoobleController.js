import { LightningElement, wire,api } from 'lwc';
// import joobleCallout from '@salesforce/apex/JoobleController.joobleCallout';

export default class WireJoobleController extends LightningElement {
    
    // @wire(joobleCallout)
    @api jobs;
    // console.log(jobs);
}