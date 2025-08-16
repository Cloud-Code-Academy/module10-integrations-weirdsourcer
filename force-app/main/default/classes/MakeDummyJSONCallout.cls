public with sharing class MakeDummyJSONCallout implements Queueable, Database.AllowsCallouts{

    //member variable
    public List<Contact> contactsToProcess;

    //Constructor
    public MakeDummyJSONCallout(List<Contact> newContacts){
        this.contactsToProcess = newContacts;
    }

    //Method to queue job
    public static void enqueueContactsForCallout(List<Contact> newContacts){
        //Check contacts list is not null
         if(newContacts != null){
            //Enqueue the job
            System.enqueueJob(new MakeDummyJSONCallout(newContacts));
        } 
	}
    
    public void execute(QueueableContext context) {
        //Get the list of contacts to be processed
        //List<Contact> contactsToBeProcessed = this.contactsToBeProcessed;
        //Loop through the list of contacts
        for (Contact cont : contactsToProcess){
            //Check if the contact is an insert and DummyJSON_Id is <= 100
            if (cont.Id == null && Integer.valueOf(cont.DummyJSON_Id__c) <= 100){
                //call the getDummyJSONUserFromId API
                DummyJSONCallout.getDummyJSONUserFromId(cont.DummyJSON_Id__c);
            }

            //When a contact is updated
            //if DummyJSON_Id__c is greater than 100, call the postCreateDummyJSONUser API
            if (cont.Id != null && !String.isBlank(cont.DummyJSON_Id__c) && Integer.valueOf(cont.DummyJSON_Id__c) > 100) {
                //Make the future call to post the contact details to the Dummy JSON API
                DummyJSONCallout.postCreateDummyJSONUser(cont.Id);
            }
        }
    }
}