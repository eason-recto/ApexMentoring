import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getParticipants from '@salesforce/apex/StudentGradingTableController.getParticipants';
import updateParticipants from '@salesforce/apex/StudentGradingTableController.updateParticipants';
import searchParticipants from '@salesforce/apex/StudentGradingTableController.searchParticipants';

export default class StudentGradingTable extends LightningElement {
    participants = [];
    draftValues = [];

    inputText = '';

    @api recordId;
    error;
    errorMessage;

    @api showSearch;

    @api isLoaded = false;

    columns = [
        { 
            label: 'Name', 
            fieldName: 'participantURL',
            type: 'url',
            editable: false,
            displayReadOnlyIcon: true,
            typeAttributes: {
                label: { fieldName: 'participantName' },
                target: '_self'
            }
        },
        { label: 'Email', fieldName: 'participantEmail', editable: false, type: 'email'},
        { label: 'Status', fieldName: 'participantStatus', editable: false, type: 'text'},
        { label: 'GPA', fieldName: 'participantGPA', editable: true, type: 'number'},
        { label: 'Passed', fieldName: 'participantPassed', editable: true, type: 'boolean'},
    ];

    connectedCallback() {
        this.loadParticipants();
    }

    handleSave(event) {
        this.draftValues = event.detail.draftValues;
        this.draftValues.forEach(draft => {
            let participant = this.participants.find(participant => participant.participantId === draft.participantId);

            if(draft.participantGPA) {
                participant.participantGPA = draft.participantGPA;
            }

            if(draft.participantPassed !== undefined) {
                participant.participantPassed = draft.participantPassed;
            }
        })

        /* Object Oriented Approach
        for (const draftValue of this.draftValues) {
            for (let participant of this.participants) {
                if (participant.participantId === draftValue.participantId) {
                    if (draftValue.participantGPA) {
                        participant.participantGPA = draftValue.participantGPA;
                    }
                    if (draftValue.participantPassed) {
                        participant.participantPassed = draftValue.participantPassed;
                    }
                }
            }
        }
        */

        this.draftValues = [];

        this.saveParticipants();
    }

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

    saveParticipants() {
        updateParticipants({ participantsToUpdate: this.participants })
            .then(result => {
                this.showSuccessMessage();
            })
            .catch(error => {
                this.error = error;
                this.showErrorMessage();
            })
    }

    loadParticipants() {
        getParticipants({trainingId : this.recordId})
            .then(result => {
                this.participants = result;
            })
            .catch(error => {
                this.error = error;
            });
    }

    handleChange(event) {
        this.inputText = event.detail.value;
    }

    handleInputClickAddParticipant(event) {
        this.isLoaded = !this.isLoaded;
        // this.error = [];
        this.errorMessage = "";
        searchParticipants ({ trainingId : this.recordId, erpId : this.inputText })
        .then(result => {
            this.participants = [...this.participants, result];
            this.isLoaded = !this.isLoaded;
        })
        .catch(error => {
            this.error = error;
            this.isLoaded = !this.isLoaded;
            this.errorMessage = "No student found with this ERP ID";
            this.showErrorMessage();
        })
    }

    handleInputClickNewStudent(event) {
        this.showWarningMessage();
    }
}