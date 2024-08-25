import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class MyModal extends LightningModal {
    @api objectApiName
    @api applicationRecord
    interviewId

    handleOkay() {
        this.close('okay');
        console.log(this.interviewId)
    }
}