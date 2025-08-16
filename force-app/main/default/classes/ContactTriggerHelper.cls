public with sharing class ContactTriggerHelper{

    //member variable to store the list of contacts to be processed
    private List<Contact> contactlistToProcess;
    private Map<Id, Contact> oldContactMap;
    
    //constructor to process SObject from trigger to Contact List
    public ContactTriggerHelper(List<SObject> newContacts, Map<Id, SObject> oldContactMap) {
        this.contactlistToProcess = (List<Contact>) newContacts;
        this.oldContactMap = (Map<Id, Contact>) oldContactMap;
    }

    // When a contact is inserted
    public static void insertContactForDummyJSON(List<Contact> contactlistToProcess) {
        List<Contact> contactsForDummyJSONCall = new List<Contact>();
        for (Contact cont : contactlistToProcess) {
            // if DummyJSON_Id__c is null, generate a random number between 0 and 100 and set this as the contact's DummyJSON_Id__c value
            if (cont.DummyJSON_Id__c == null) {
                cont.DummyJSON_Id__c = (Math.random() * 100).intValue().toString();
            }// if DummyJSON_Id__c is less than or equal to 100, call the getDummyJSONUserFromId API
            else if (!String.isBlank(cont.DummyJSON_Id__c) && Integer.valueOf(cont.DummyJSON_Id__c) <= 100)  {
                //Make the future call to post the contact details to the Dummy JSON API
                contactsForDummyJSONCall.add(cont);
            }
        }
        MakeDummyJSONCallout.enqueueContactsForCallout(contactsForDummyJSONCall);
    }
   
    //When a contact is updated
    public static void updateContactForDummyJSON(List<Contact> contactlistToProcess) {
        for (Contact cont : contactlistToProcess) {
            MakeDummyJSONCallout.enqueueContactsForCallout(contactlistToProcess);
        }
    }
}