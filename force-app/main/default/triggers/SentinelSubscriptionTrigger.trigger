/*----------------------------------------------------
* @name           SentinelSubscriptionTrigger 
* @date           8 Nov 2020
* @description    This is a trigger on Salesforce CPQ object Subscription  to create entitlement. 
* ------------------------------------------------------*/
trigger SentinelSubscriptionTrigger on SBQQ__Subscription__c   (after insert) {
    SentinelSubscriptionTriggerHandler handler = new SentinelSubscriptionTriggerHandler();

    //After Insert
    if(Trigger.isInsert && Trigger.isAfter){
    
    if(System.IsBatch() == false && System.isFuture() == false){ 
    // make your future call here 
    handler.onAfterInsert(Trigger.new);
}
    
        
    }
   
}