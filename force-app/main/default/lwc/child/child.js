import { LightningElement,api } from 'lwc';

export default class ChildCcmponent extends LightningElement {
    @api textMessage;
    sendMessagetoParent(event){
        const sendMessageFromChild = new CustomEvent('childmessage', {detail: 'Hi I am your child'});
        this.dispatchEvent(sendMessageFromChild);
    }
}