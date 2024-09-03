public with sharing class BirthdayContactsTableController {
    public static final Integer TODAYS_DAY = Date.today().day();
    public static final Integer TODAYS_MONTH = Date.today().month();

    @AuraEnabled
    public static List<Contact> getBirthdayContacts() {
        return [
            SELECT Id, Name, Phone, Title, Email, Birthdate, Birthday_Congrats_Sent__c
            FROM Contact
            WHERE CALENDAR_MONTH(Birthdate) = :TODAYS_MONTH AND DAY_IN_MONTH(Birthdate) = :TODAYS_DAY
        ];
    }

    @AuraEnabled
    public static void updateBirthdayContacts(Contact contact) {
        System.debug(contact);
        if (contact.Birthday_Congrats_Sent__c == true) {
            throw new HandledException();
        }
        contact.Birthday_Congrats_Sent__c = true;

        

        update contact;
    }

    @AuraEnabled
    public static void sendBirthdayEmail(Contact contact) {
        Messaging.SingleEmailMessage birthdayEmail = createBirthdayEmail(contact);
        List<Messaging.SingleEmailMessage> birthdayEmails = new List<Messaging.SingleEmailMessage>();
        birthdayEmails.add(birthdayEmail);

        Messaging.sendEmail(birthdayEmails);
    }

    private static Messaging.SingleEmailMessage createBirthdayEmail(Contact contact) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(contact.Id);
        mail.setSubject('Cakes and Candles');
        mail.setHTMLBody('Dear ' + contact.Name + ',' + '<br><br>' +
                         'Happy Birthday!' + '<br><br>' +
                         'Your team,'+ '<br><br>' + 
                         '@ Cloud Prism'
                        );
        return mail;
    }
}