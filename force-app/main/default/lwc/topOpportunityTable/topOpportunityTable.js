import { LightningElement, api } from 'lwc';
import getOpportunities from '@salesforce/apex/TopOpportunityTableController.getOpportunities';

export default class TopOpportunityTable extends LightningElement {
    errors;
    errorMessage;

    @api opportunityLimit;

    opportunities = [];

    columns = [
        { 
            label: 'Opportunity Name', 
            fieldName: 'opportunityURL',
            type: 'url',
            editable: false,
            displayReadOnlyIcon: true,
            typeAttributes: {
                label: { fieldName: 'opportunityName' },
                target: '_self'
            }
        },
        { label: 'Stage', fieldName: 'opportunityStageName', editable: false, type: 'text'},
        { label: 'Amount', fieldName: 'opportunityAmount', editable: false, type: 'currency'},
        { label: 'Close Date', fieldName: 'opportunityCloseDate', editable: false, type: 'date'},
        { label: 'Owner', fieldName: 'opportunityOwnerName', editable: false, type: 'text'},
    ];

    connectedCallback() {
        this.loadOpportunities();
    }

    loadOpportunities() {
        getOpportunities({opportunityLimit : this.opportunityLimit})
            .then(result => {
                this.opportunities = result;
            })
            .catch(error => {
                this.errors = error;
            });
    }
}