public with sharing class TrainingReminderScheduled implements Schedulable {
    
    /* #4 - Scheduled Apex: Task #1 and 2 - Trainer Reminder and Student Reminder
     * This method is a part of the Training Reminder process.
     * It is called from the Scheduled Apex UI.
     */
    public void execute(SchedulableContext sc) {
        EmailService.sendEmailsToNotifyTrainers();
        EmailService.sendEmailsToNotifyStudents();
    }
}