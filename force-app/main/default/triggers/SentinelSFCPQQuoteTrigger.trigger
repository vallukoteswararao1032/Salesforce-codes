/*----------------------------------------------------
* @name           SentinelSFCPQQuoteTrigger 
* @date           8 Nov 2020
* @description    This is a trigger on Salesforce CPQ object Quote(SBQQ__Quote__c)  to create/ update entitlement. 
* ------------------------------------------------------*/
trigger SentinelSFCPQQuoteTrigger on SBQQ__Quote__c  (before insert, after insert, after update, after delete, after undelete) {
    SentinelQuoteTriggerHandler handler = new SentinelQuoteTriggerHandler();
    
    system.debug('++eidchecked' + SentinelConstants.isEidEntered);

    if(Trigger.isInsert && Trigger.isBefore){
      if(Trigger.new[0].EID__c!=null)
         SentinelConstants.isEidEntered=true;
         for(SBQQ__Quote__c qoutes:trigger.new){
            qoutes.SBQQ__Status__c='Draft';
         }
      
      }
     
     system.debug('++eidchecked' + SentinelConstants.isEidEntered);
     
    //After Insert
    if(Trigger.isInsert && Trigger.isAfter){
         if(Trigger.new[0].EID__c!=null)
             SentinelConstants.isEidEntered=true;
        
        system.debug('++eidchecked' + SentinelConstants.isEidEntered);
     
        handler.onAfterInsert(Trigger.new);
    }
    //After Update
    else if(Trigger.isUpdate && Trigger.isAfter){
        handler.onAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }
    
    
    
    system.debug('++eidchecked' + SentinelConstants.isEidEntered);
    
}