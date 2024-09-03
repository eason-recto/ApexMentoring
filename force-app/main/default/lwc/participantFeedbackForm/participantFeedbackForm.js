import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import TRAINING from '@salesforce/schema/Training_Feedback__c.Training__c';
import PARTICIPANT from '@salesforce/schema/Training_Feedback__c.Participant__c';
import RATING from '@salesforce/schema/Training_Feedback__c.Training_Rating__c';
import MOST_HELPFUL_PART from '@salesforce/schema/Training_Feedback__c.Most_Helpful_Part__c';
import SUGGESTIONS_FOR_IMPROVEMENT from '@salesforce/schema/Training_Feedback__c.Suggestions_for_Improvement__c';
import LEARNED_FROM_TRAINING from '@salesforce/schema/Training_Feedback__c.Learned_From_Training__c';
import ADDITIONAL_THOUGHTS from '@salesforce/schema/Training_Feedback__c.Additional_Thoughts__c';

export default class ParticipantFeedbackForm extends LightningElement {
    @api recordId;
    error;
    
    trainingFeedbackApiName = 'Training_Feedback__c';

    training = TRAINING;
    participant = PARTICIPANT;
    rating = RATING;
    mostHelpfulPart = MOST_HELPFUL_PART;
    suggestionsForImprovement = SUGGESTIONS_FOR_IMPROVEMENT;
    learnedFromTraining = LEARNED_FROM_TRAINING;
    additionalThoughts = ADDITIONAL_THOUGHTS;

    handleSuccess(event) {        
        const inputFields = this.template.querySelectorAll('.needs-input');
        inputFields.forEach( field => {
            field.reset();
        });
        // this.training.value = recordId;
        this.showSuccessMessage();

    }

    handleError(event) {
        this.error = error;
        this.showErrorMessage();
    }

    showSuccessMessage() {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Participant feedback was successfully submitted!",
            variant: "success"
          })
        );
    }

    showErrorMessage() {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error",
            message: "Something went wrong...",
            variant: "error"
          })
        );
    }
}