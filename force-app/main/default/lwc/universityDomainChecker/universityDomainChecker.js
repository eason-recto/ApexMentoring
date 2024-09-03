import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import checkUniversityDomains from '@salesforce/apex/UniversityDomainCheckerController.checkUniversityDomains';

export default class UniversityDomainChecker extends LightningElement {
    error;

    @api isLoaded = false;
    inputText = '';
    message = '';
    messageClass = '';

    handleChange(event) {
        this.message = '';
        this.messageClass = '';
        this.inputText = event.detail.value;
    }

    handleCheck(event) {
        this.isLoaded = !this.isLoaded;
        checkUniversityDomains ({ domain : this.inputText })
        .then(result => {
            this.isLoaded = !this.isLoaded;
            if (result === true) {
                // this.showToast("You're in the clear", "University was found!", "success");
                this.message = 'This educational email domain is valid.';
                this.messageClass = 'slds-text-color_success';
            }
            else {
                // this.showToast("We hope you didn't pay a deposit", "No university was found with the provided domain", "warning");
                this.message = 'The email\’s domain doesn\’t belong to an educational institution.';
                this.messageClass = 'slds-text-color_error';
            }
        })
        .catch(error => {
            this.error = error;
            this.isLoaded = !this.isLoaded;
            this.showToast('Error', 'Something went wrong...', 'error');
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