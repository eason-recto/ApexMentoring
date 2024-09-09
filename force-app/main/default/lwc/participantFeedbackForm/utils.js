import TRAINING from '@salesforce/schema/Training_Feedback__c.Training__c';
import PARTICIPANT from '@salesforce/schema/Training_Feedback__c.Participant__c';
import RATING from '@salesforce/schema/Training_Feedback__c.Training_Rating__c';
import MOST_HELPFUL_PART from '@salesforce/schema/Training_Feedback__c.Most_Helpful_Part__c';
import SUGGESTIONS_FOR_IMPROVEMENT from '@salesforce/schema/Training_Feedback__c.Suggestions_for_Improvement__c';
import LEARNED_FROM_TRAINING from '@salesforce/schema/Training_Feedback__c.Learned_From_Training__c';
import ADDITIONAL_THOUGHTS from '@salesforce/schema/Training_Feedback__c.Additional_Thoughts__c';

export const FIELDS = [
    TRAINING,
    PARTICIPANT,
    RATING,
    MOST_HELPFUL_PART,
    SUGGESTIONS_FOR_IMPROVEMENT,
    LEARNED_FROM_TRAINING,
    ADDITIONAL_THOUGHTS
];