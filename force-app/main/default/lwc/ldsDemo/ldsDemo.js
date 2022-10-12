import { LightningElement,api,track } from 'lwc';
import FirstName from '@salesforce/schema/Contact.FirstName';
import LastName from '@salesforce/schema/Contact.LastName';
import Phone from '@salesforce/schema/Contact.Phone';
import Email from '@salesforce/schema/Contact.Email';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class LdsDemo extends LightningElement {
@api recordId;
@api objectApiName;
@track fields = [FirstName,LastName,Phone,Email];
connectedCallback(){
    this.objectName = this.objectApiName;
}
handleLoad(event){
   const toastmsg = new ShowToastEvent({
    title : 'Loaded',
    message : 'Data Loaded',
    variant : 'info',
    mode : 'dismissable'
   })
   this.dispatchEvent(toastmsg);
}
handleError(){
    const toastmsg = new ShowToastEvent({
        title : 'Error',
        message : 'Data Error occured',
        variant : 'error',
        mode : 'dismissable'
       })
       this.dispatchEvent(toastmsg);
}
handleSuccess(){
    const toastmsg = new ShowToastEvent({
        title : 'Success',
        message : 'Data saved successfully',
        variant : 'success',
        mode : 'dismissable'
       })
       this.dispatchEvent(toastmsg);
}
}