import { LightningElement, api } from 'lwc';
import LightningModal from 'lightning/modal';
import sendApplSubmissionEmail from '@salesforce/apex/JobApplHelper.sendApplSubmissionEmail';

export default class JobApplModalPage extends LightningModal {
     /* FLOW PROPERTIES */
     @api header;
     @api flowName;
     @api inputVariables;
     @api flowModal = false;
     @api showFooter = false;
     @api showHeader = false;
     @api flowFinish = 'NONE';
 
     handleStatusChange(event) {
         if(event.detail.status === 'FINISHED'){
             this.close('flow finished: '+this.flowName);
            //  alert('Flow Modal is Closed for ' + JSON.stringify(this.inputVariables));

            try {
                //this.openJobsList = getOpenJobs({ location : this.locationName });
                sendApplSubmissionEmail({inputValues : JSON.stringify(this.inputVariables)})
                .then ()
                .catch(error => {
                    alert('Error Occurred : ' + JSON.stringify(error));
                });            
            }
            catch(error) {
                alert('Entered to error block : ' + error);
                this.openJobsList = undefined;
                this.searchJobError = true;
            }
         }
     }
 
     handleClose(){
         this.close('modal is closed');
     }
}