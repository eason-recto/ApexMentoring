import { LightningElement } from 'lwc';
import getActiveDepartments from '@salesforce/apex/UserByDepartmentTableController.getActiveDepartments';
import getActiveUsersByDepartment from '@salesforce/apex/UserByDepartmentTableController.getActiveUsersByDepartment';

export default class UserByDepartmentTable extends LightningElement {
    error;
    errorMessage;

    departments = [];

    users = [];
    columns = [
        { label: 'User Name', fieldName: 'Name', editable: true, type: 'text'},
        { label: 'Email', fieldName: 'Email', editable: false, type: 'email'},
        { label: 'Department', fieldName: 'Department', editable: false, type: 'text'},
    ];
    inputChoice = 'All Departments';

    get options() {
        var returnOptions = [{label: 'All Departments' , value: 'All Departments'}];
        console.log('OPTIONS ONE');
        if(this.departments) {
            this.departments.forEach(department => {
                returnOptions = [...returnOptions, {label: department.Department , value: department.Department}];
            }); 
        }
        console.log('OPTIONS TWO');
        return returnOptions;
    }

    connectedCallback() {
        this.loadUsers();
        this.loadDepartments();
    }

    handleChange(event) {
        this.inputChoice = event.detail.value;
        this.loadUsers();
    }

    loadUsers() {
        getActiveUsersByDepartment({department : this.inputChoice})
            .then(result => {
                this.users = result;
            })
            .catch(error => {
                this.error = error;
            });
    }

    loadDepartments() {
        console.log('LOAD DEPARTMENTS')
        getActiveDepartments()
            .then(result => {
                this.departments = result;
            })
            .catch(error => {
                this.error = error;
            });
    }
}
