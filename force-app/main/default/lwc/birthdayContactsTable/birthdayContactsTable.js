import { LightningElement, track, wire } from 'lwc';
import getBirthdayContacts from '@salesforce/apex/BirthdayContactsTableController.getBirthdayContacts';
import updateBirthdayContacts from '@salesforce/apex/BirthdayContactsTableController.updateBirthdayContacts';
import sendBirthdayEmail from '@salesforce/apex/BirthdayContactsTableController.sendBirthdayEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class BirthdayContactsTable extends LightningElement {
    data = [];
    contacts = [];
    @track errors;

    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Phone', fieldName: 'Phone' },
        { label: 'Title', fieldName: 'Title' },
        { label: 'Email', fieldName: 'Email' },
        {
            type: "button", label: 'Congratulate!', cellAttributes: { alignment: 'center' }, typeAttributes: {
                name: 'congratulate',
                title: 'Congratulate!',
                disabled: false,
                value: 'congratulate',
                iconPosition: 'left',
                iconName:'utility:email',
                label: {fieldName: 'buttonName'},
                variant: {fieldName: 'buttonVariant'}
            }
        }
    ];

    connectedCallback() {
        this.loadContacts();
    }

    loadContacts() {
        getBirthdayContacts()
        .then(result => {
            this.data = result;
            this.contacts = this.data;
            this.contacts = this.data.map(item => ({ ...item, buttonName: item.Birthday_Congrats_Sent__c == false?'Congratulate!':'Sent!', buttonVariant: item.Birthday_Congrats_Sent__c == false?'brand':'brand-outline' }));
        })
        .catch(error => {
            this.errors = error;
            this.showToast("Error", "Something went wrong...", "error");
        })
    }

    handleRowAction(event) {
        updateBirthdayContacts({contact: event.detail.row})
        .then(result => {
            sendBirthdayEmail({contact: event.detail.row})
            .then(result => {
                this.loadContacts();
                this.showToast("Success", "Congratulations email sent!", "success");
            })
            .catch(error => {
                this.errors = error;
                this.showToast("Error", "Something went wrong...", "error");
            })
        })
        .catch(error => {
            this.errors = error;
            this.showToast("Warning", "You already sent an email to this Contact.", "warning");
        })
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            })
        );
    }
}