import { LightningElement } from 'lwc';

let userArray = [
    {
        'Name': 'Alfreds Futterkiste', 
        'Title': 'CEO', 
        'Username': 'a.futterkiste@training.edu', 
        'Phone': '123456789', 
        'Department': 'Sales'
    },
    {
        'Name': 'Maria Anders', 
        'Title': 'Director', 
        'Username': 'm.anders@training.edu', 
        'Phone': '987654321', 
        'Department': 'Marketing'
    }
]

let totalArray = [
    {
        'Name': 'Total Users: ' + userArray.length, 
        'Title': '', 
        'Username': '', 
        'Phone': '', 
        'Department': ''
    }
]

userArray.push(totalArray[0])

const departmentArray = [
    {
        'Name': 'Sales'
    },
    {
        'Name': 'Marketing'
    }
]

const columns = [
    { label: 'Name', fieldName: 'Name'},
    { label: 'Title', fieldName: 'Title'},
    { label: 'Username', fieldName: 'Username', type: 'email'},
    { label: 'Phone', fieldName: 'Phone', type: 'phone'},
    { label: 'Department', fieldName: 'Department'},
];

export default class UserList extends LightningElement {
    userData = userArray;
    departmentData = departmentArray;
    columns = columns;
}