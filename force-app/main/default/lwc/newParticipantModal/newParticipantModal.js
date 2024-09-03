import { LightningElement, api } from 'lwc';
import LightningModal from 'lightning/modal';
import STATUS from '@salesforce/schema/Participant__c.Status__c';
import GPA from '@salesforce/schema/Participant__c.GPA__c';
import CONTACT_NAME from '@salesforce/schema/Participant__c.Contact_Name__c';
import TRAINING from '@salesforce/schema/Participant__c.Training__c';
import PASSED from '@salesforce/schema/Participant__c.Passed__c';

export default class NewParticipantModal extends LightningModal {
    @api recordId;
    
    participantApiName = 'Participant__c';

    status = STATUS;
    gpa = GPA;
    contactName = CONTACT_NAME;
    training = TRAINING;
    passed = PASSED;

    closeModal() {
        this.close();
    }

    handleSave(event) {
        event.preventDefault();
        this.dispatchEvent(new CustomEvent('addparticipant', {detail : event.detail.fields}));
        this.closeModal();
    }
}