import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import searchParticipants from '@salesforce/apex/StudentGradingTableController.searchParticipants';
import createParticipant from '@salesforce/apex/StudentGradingTableController.createParticipant';
import newParticipantModal from 'c/newParticipantModal';

export default class SearchComponentChild extends LightningElement {
    @api recordId;
    error;
    errorMessage;

    @api isLoaded = false;
    inputText = '';

    showSuccessMessage() {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Participants were successfully updated",
            variant: "success"
          })
        );
    }

    showErrorMessage() {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error",
            message: "Participant was not found",
            variant: "error"
          })
        );
    }

    showWarningMessage() {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Warning",
            message: "This will be shipped in the next release",
            variant: "warning"
          })
        );
    }

    handleChange(event) {
        this.errorMessage = "";
        this.inputText = event.detail.value;
    }

    handleInputClickAddParticipant(event) {
        this.isLoaded = !this.isLoaded;
        // this.error = [];
        this.errorMessage = "";
        searchParticipants ({ erpId : this.inputText })
        .then(result => {
            setTimeout(() => {
                const newEvent = new CustomEvent('addrow', {detail : result});
                this.dispatchEvent(newEvent);
                this.isLoaded = !this.isLoaded;
            }, 500);
        })
        .catch(error => {
            this.error = error;
            console.log(JSON.stringify(error));
            this.errorMessage = "No student found with this ERP ID: " + this.inputText;
            this.showErrorMessage();
            this.isLoaded = !this.isLoaded;
        })
    }

    handleInputClickNewStudent(event) {
        this.errorMessage = "";
        this.showWarningMessage();
    }

    handleNew(event) {
        this.errorMessage = "";
        this.inputText = "";
        newParticipantModal.open({
            size: "small", 
            recordId: this.recordId, 
            onaddparticipant: (event) => {
                this.saveNewParticipant(event);
            }
        });
    }

    saveNewParticipant(event) {
        const fieldDetails = event.detail;
        createParticipant({ participantToCreate : fieldDetails })
        .then(result => {
            this.dispatchEvent(new CustomEvent('addrow', {detail : result}));
        })
        .catch(error => {
            this.error = error;
        })
    }
}