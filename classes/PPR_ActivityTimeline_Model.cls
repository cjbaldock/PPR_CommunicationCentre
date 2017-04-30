/**
 * Created by chris.baldock on 22/4/17.
 */

global with sharing class PPR_ActivityTimeline_Model implements Comparable {

    @AuraEnabled public Id RecordId {get;set;}
    @AuraEnabled public String ActivityTimelineType {get;set;}
    @AuraEnabled public String Subject {get;set;}
    @AuraEnabled public String Detail {get;set;}
    @AuraEnabled public String ShortDate {get;set;}
    @AuraEnabled public String Recipients {get;set;}
    @AuraEnabled public DateTime ActualDate {get;set;}

    global Integer compareTo(Object objToCompare)
    {
        DateTime otherActualDate = objToCompare != null ? ((PPR_ActivityTimeline_Model)objToCompare).ActualDate : System.now();
        if (this.ActualDate == otherActualDate) return 0;
        if (this.ActualDate < otherActualDate) return 1;
        return -1;
    }

}