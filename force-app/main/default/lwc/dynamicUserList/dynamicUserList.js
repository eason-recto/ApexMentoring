import { LightningElement } from 'lwc';
import queryActiveUsers from '@salesforce/apex/DynamicUserListController.queryActiveUsers';

import FIRSTNAME_FIELD from '@salesforce/schema/User.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/User.LastName';
import EMAIL_FIELD from '@salesforce/schema/User.Email';
import PHONE_FIELD from '@salesforce/schema/User.Phone';

const columns = [
    { label: 'First Name', fieldName: 'FirstName'},
    { label: 'Last Name', fieldName: 'LastName'},
    { label: 'Email', fieldName: 'Email', type: 'email'},
    { label: 'Phone', fieldName: 'Phone', type: 'phone'},
];

export default class DynamicUserList extends LightningElement {
    users;
    columns;
    error;

    objectApiName = 'User';
    fields = [FIRSTNAME_FIELD, LASTNAME_FIELD, EMAIL_FIELD, PHONE_FIELD];

    connectedCallback() {
        this.renderUserTable();
    }

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: 'User created',
            message: 'Record ID: ' + event.detail.id,
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }

    renderUserTable() {
        queryActiveUsers()
            .then(result => {
                this.users = JSON.parse(result);
            })
            .catch(error => {
                this.error = error;
            });
        this.columns = columns
    }
}