import { LightningElement,track } from 'lwc';

export default class ParentComponent extends LightningElement {
    @track message;
    @track messageFromChild;
    sendDatatoChild(event){
        this.message = 'Message from Parent!!!';        
    }
    handlechildMessage(event){
        this.messageFromChild = event.detail;
    }
}