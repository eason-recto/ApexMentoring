import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from '@salesforce/apex';

import getParticipants from '@salesforce/apex/StudentGradingTableController.getParticipants';
import fetchParticipants from '@salesforce/apex/StudentGradingTableController.fetchParticipants';
import updateParticipants from '@salesforce/apex/StudentGradingTableController.updateParticipants';
import deleteParticipant from '@salesforce/apex/StudentGradingTableController.deleteParticipant';

import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import { updateRecord } from 'lightning/uiRecordApi';

import PARTICIPANT_OBJECT from '@salesforce/schema/Participant__c';
import STATUS_FIELD from '@salesforce/schema/Participant__c.Status__c';

export default class StudentGradingTableParent extends LightningElement {
    @track participants = [];
    @track draftValues = [];
    @track participantStatuses = [];
    @track participantData;
    lastSavedData = [];

    @api recordId;
    @api showSearch;
    @api isLoaded = false;
    error;
    errorMessage;

    @wire(getObjectInfo, { objectApiName: PARTICIPANT_OBJECT })
    participantObjectMetadata;

    @wire(getPicklistValues, { recordTypeId: '$participantObjectMetadata.data.defaultRecordTypeId', fieldApiName: STATUS_FIELD })
    wirePicklist({ data, error }) {
        if (data) {
            this.participantStatuses = data.values;
            // this.loadParticipants();
        }
        else if (error) {
            console.log('getPicklistValues error: ' + JSON.stringify(error));
        }
    }

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
        // { label: 'Status', fieldName: 'participantStatus', editable: true, type: 'text'},
        { label: 'Status', fieldName: 'participantStatus', editable: true, type: 'statusPicklist', wrapText: true,
            typeAttributes: {
                options: {fieldName: 'participantStatuses' },
                value: {fieldName: 'participantStatus'},
                placeholder: 'Select a Status...',
                context: { fieldName: 'Id' }
            }
        },
        { label: 'GPA', fieldName: 'participantGPA', editable: true, type: 'number'},
        { label: 'Passed', fieldName: 'participantPassed', editable: true, type: 'boolean'},
        {
            type: "button", label: 'Delete', cellAttributes: { alignment: 'center' }, typeAttributes: {
                name: 'delete',
                title: 'Delete',
                disabled: false,
                value: 'delete',
                iconPosition: 'left',
                iconName:'utility:delete',
                label: 'Delete',
                variant: 'destructive'
            }
        }
    ];

    connectedCallback() {
        // this.loadParticipants();
    }

    handleSave(event) {
        this.isLoaded = true;
        /*this.saveDraftValues = this.draftValues;
 
        const recordInputs = this.saveDraftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
 
        // Updating the records using the UiRecordAPI
        const promises = recordInputs.map(recordInput => {
            updateRecord(recordInput);
        });
        Promise.all(promises).then(res => {
            this.showToast('Success', 'Records Updated Successfully!', 'success');
            this.draftValues = [];
            return this.refresh();
        }).catch(error => {
            this.showToast('Error', 'An Error Occured!', 'error');
        }).finally(() => {
            this.draftValues = [];
            this.isLoaded = false;
        });*/
        this.draftValues = event.detail.draftValues;
        this.draftValues.forEach(draft => {
            let participant = this.participants.find(participant => participant.participantId === draft.participantId);

            if(draft.participantStatus) {
                participant.participantStatus = draft.participantStatus;
            }

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
        this.isLoaded = false;
    }

    handleCancel(event) {
        //remove draftValues & revert data changes
        this.participants = JSON.parse(JSON.stringify(this.lastSavedData));
        this.draftValues = [];
    }

    saveParticipants() {
        updateParticipants({ participantsToUpdate: this.participants })
            .then(result => {
                this.showToast('Success!', 'Participants were successfully updated', 'success');
            })
            .catch(error => {
                this.error = error;
                this.showToast('Error', 'Participant was not found', 'error');
            })
    }

    loadParticipants() {
        getParticipants({ trainingId: this.recordId })
            .then(result => {
                this.participants = result;
                /*let options = [];
                for(var key in this.participantStatuses) {
                    options.push( { label: this.participantStatuses[key].label, value: this.participantStatuses[key].value });
                }

                this.participants = result.map( (record) => {
                    return {
                        ...record,
                        'picklistOptions': options
                    }
                });*/
                this.lastSavedData = JSON.parse(JSON.stringify(this.participants));
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.participants = undefined;
            });
    }

    @wire(fetchParticipants, { trainingId: '$recordId', pickList: '$participantStatuses' })
    participantData(result) {
        this.participantData = result;
        if (result.data) {
            this.participants = JSON.parse(JSON.stringify(result.data));

            this.participants.forEach(ele => {
                ele.participantStatuses = this.participantStatuses;
            })

            this.lastSavedData = JSON.parse(JSON.stringify(this.participants));

        } else if (result.error) {
            this.participants = undefined;
        }
    }

    updateDataValues(updateItem) {
        let copyParticipants = JSON.parse(JSON.stringify(this.participants));
 
        copyParticipants.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
            }
        });
 
        //write changes back to original data
        this.participants = [...copyParticipants];
    }

    updateDraftValues(updateItem) {
        let draftValueChanged = false;
        let copyDraftValues = [...this.draftValues];
        //store changed value to do operations
        //on save. This will enable inline editing &
        //show standard cancel & save button
        copyDraftValues.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
                draftValueChanged = true;
            }
        });
 
        if (draftValueChanged) {
            this.draftValues = [...copyDraftValues];
        } else {
            this.draftValues = [...copyDraftValues, updateItem];
        }
    }
 
    //handler to handle cell changes & update values in draft values
    handleCellChange(event) {
        let draftValues = event.detail.draftValues;
        draftValues.forEach(ele=>{
            this.updateDraftValues(ele);
        })
    }

    handleAddRow(event) {
        this.participants = [...this.participants, event.detail];
        refreshApex(this.participantData);
        // this.loadParticipants();
    }

    handleRowAction(event) {
        this.isLoaded = !this.isLoaded;
        deleteParticipant({participant: event.detail.row})
        .then(result => {
            setTimeout(() => {
                refreshApex(this.participantData);
                this.showToast('Success!', 'Participant has been deleted', 'success');
                // this.loadParticipants();
                this.isLoaded = !this.isLoaded;
            }, 500);
        })
        .catch(error => {
            this.error = error;
            this.isLoaded = !this.isLoaded;
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