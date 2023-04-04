/*----------------------------------------------------
* @name           SentinelQuoteItemTrigger 
* @date           8 Nov 2020
* @description    This is a trigger on Salesforce CPQ object Quote to create/ update entitlement. 
* ------------------------------------------------------*/
trigger SentinelQuoteItemTrigger on SBQQ__QuoteLine__c (after insert, after update) {
    SentinelQuoteItemTriggerHandler handler = new SentinelQuoteItemTriggerHandler();
     
    //After Insert
    if(Trigger.isInsert && Trigger.isAfter){
        handler.onAfterInsert(Trigger.new);
    }
    //After Update
    else if(Trigger.isUpdate && Trigger.isAfter){
        handler.onAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }
}