/**
 * Created by chris.baldock on 22/4/17.
 */

public with sharing class PPR_ActivityTimeline_Controller {


    @AuraEnabled
    public static contactDetails getDefaultContactDetails(String objectName, ID recordId)
    {

        objectName = String.isEmpty(objectName) ? '' : objectName;

        ContactDetails conDetails = new ContactDetails();

        if(objectName == 'Lead'){
            Lead thisLead = [SELECT id, name, mobilePhone, email FROM Lead WHERE id =: recordId];
            conDetails.name = thisLead.name;
            conDetails.phone = thisLead.mobilePhone;
            conDetails.email = thisLead.email;
        }
        else if(objectName == 'Contact'){
            Contact thisContact = [SELECT id, name, mobilePhone, email FROM Contact WHERE id =: recordId];
            conDetails.name = thisContact.name;
            conDetails.phone = thisContact.mobilePhone;
            conDetails.email = thisContact.email;
        }

        return conDetails;

    }

    public class ContactDetails{
        @AuraEnabled public String name { get;set; }
        @AuraEnabled public String phone { get;set; }
        @AuraEnabled public String email { get;set; }
    }

    @AuraEnabled
    public static List<PPR_ActivityTimeline_Model> getActivityTimeline(String objectName, ID recordId)
    {
        // Create a return List
        List<PPR_ActivityTimeline_Model> returnList = new List<PPR_ActivityTimeline_Model>();

        // Add Tasks Types
        getEmails(returnList, objectName, recordId);
        getSMS(returnList, objectName, recordId);

        // Sort List
        returnList.sort();

        return returnList;

    }

    @AuraEnabled
    public static List<PPR_ActivityTimeline_Model> getActivityTimeline()
    {
        // Create a return List
        List<PPR_ActivityTimeline_Model> returnList = new List<PPR_ActivityTimeline_Model>();

        // Add Tasks Types
        getEmails(returnList, '', '');
        getSMS(returnList, '', '');

        // Sort List
        returnList.sort();

        return returnList;

    }

    @AuraEnabled
    public static void getEmails(List<PPR_ActivityTimeline_Model> returnList, String objectName, ID recordId)
    {
        List<Communication_History__c> commList = new List<Communication_History__c>();

        objectName = String.isEmpty(objectName) ? '' : objectName;

        if(objectName == 'Lead'){
            commList = [select Id, Type__c, Subject__c, Body__c, Contact_Name__c, CreatedDate FROM Communication_History__c WHERE Type__c = 'Email' AND Lead__c <> '' AND Lead__c =: recordId];
        }
        else if(objectName == 'Contact'){
            commList = [select Id, Type__c, Subject__c, Body__c, Contact_Name__c, CreatedDate FROM Communication_History__c WHERE Type__c = 'Email' AND Contact__c <> '' AND Contact__c =: recordId];
        }
        else{
            commList = [select Id, Type__c, Subject__c, Body__c, Contact_Name__c, CreatedDate FROM Communication_History__c WHERE Type__c = 'Email'];
        }

        if(commList.size() > 0)
        {
            for(Communication_History__c cl: commList)
            {
                PPR_ActivityTimeline_Model activityItem = new PPR_ActivityTimeline_Model();
                activityItem.RecordId = cl.Id;
                activityItem.ActivityTimelineType = 'Email';
                activityItem.Subject = cl.Subject__c;
                activityItem.Detail = cl.Body__c;
                activityItem.ActualDate = cl.CreatedDate;
                activityItem.ShortDate = cl.CreatedDate.format('dd MMMM');
                activityItem.Recipients = cl.Contact_Name__c;

                returnList.add(activityItem);
            }
        }
    }

    @AuraEnabled
    public static void getSMS(List<PPR_ActivityTimeline_Model> returnList, String objectName, ID recordId)
    {

        List<Communication_History__c> commList = new List<Communication_History__c>();

        objectName = String.isEmpty(objectName) ? '' : objectName;

        if(objectName == 'Lead'){
            commList = [select Id, Type__c, Subject__c, Body__c, Contact_Name__c, CreatedDate FROM Communication_History__c WHERE Type__c = 'SMS' AND Lead__c <> '' AND Lead__c =: recordId];
        }
        else if(objectName == 'Contact'){
            commList = [select Id, Type__c, Subject__c, Body__c, Contact_Name__c, CreatedDate FROM Communication_History__c WHERE Type__c = 'SMS' AND Contact__c <> '' AND Contact__c =: recordId];
        }
        else{
            commList = [select Id, Type__c, Subject__c, Body__c, Contact_Name__c, CreatedDate FROM Communication_History__c WHERE Type__c = 'SMS'];
        }

        if(commList.size() > 0)
        {
            for(Communication_History__c cl: commList)
            {
                PPR_ActivityTimeline_Model activityItem = new PPR_ActivityTimeline_Model();
                activityItem.RecordId = cl.Id;
                activityItem.ActivityTimelineType = 'SMS';
                activityItem.Subject = cl.Subject__c;
                activityItem.Detail = cl.Body__c;
                activityItem.ActualDate = cl.CreatedDate;
                activityItem.ShortDate = cl.CreatedDate.format('dd MMMM');
                activityItem.Recipients = cl.Contact_Name__c;

                returnList.add(activityItem);
            }
        }
    }


    @AuraEnabled
    public static void addSMS(ID recordId, String objectName, String contactName, String mobileNumber, String SMSText)
    {

        objectName = String.isEmpty(objectName) ? '' : objectName;

        Communication_History__c newComms = new Communication_History__c();
        newComms.Type__c = 'SMS';
        newComms.Subject__c = mobileNumber;
        newComms.Body__c = SMSText;
        newComms.Contact_Name__c = contactName;
        if(objectName == 'Lead' && String.isNotEmpty(recordId)){
            newComms.Lead__c = recordId;
        }
        if(objectName == 'Contact' && String.isNotEmpty(recordId)){
            newComms.Contact__c = recordId;
        }

        insert newComms;

    }

    @AuraEnabled
    public static void addEmail(ID recordId, String objectName, String contactName, String emailAddress, String emailText)
    {

        objectName = String.isEmpty(objectName) ? '' : objectName;

        Communication_History__c newComms = new Communication_History__c();
        newComms.Type__c = 'Email';
        newComms.Subject__c = emailAddress;
        newComms.Body__c = emailText;
        newComms.Contact_Name__c = contactName;
        if(objectName == 'Lead' && String.isNotEmpty(recordId)){
            newComms.Lead__c = recordId;
        }
        if(objectName == 'Contact' && String.isNotEmpty(recordId)){
            newComms.Contact__c = recordId;
        }

        insert newComms;

    }

}