/*----------------------------------------------------
* @name           SentinelSubscriptionTriggerHandler 
* @date           8 Nov 2020
* @description    This is a handler class for SentinelSubscriptionTrigger. 
* ------------------------------------------------------*/
public with sharing class SentinelSubscriptionTriggerHandler {

    private Sentinel_User_Info__c configObj;
    private List<Sentinel_Order_Field_Mapping__c> quoteMappingFieldList;
     
    public SentinelSubscriptionTriggerHandler(){
        configObj = Sentinel_User_Info__c.getOrgDefaults();
        quoteMappingFieldList = Sentinel_Order_Field_Mapping__c.getall().values();
    }
    
    public void onAfterInsert(List<SBQQ__Subscription__c> newQuotes){
        //EXECUTE AFTER INSERT LOGIC
        SentinelUtil.syncSubscriptionEntitlements(new Set<String>{newQuotes[0].id}, 'create');
    }
     
    
    public Set<String> getMappedQuoteFields() {
        Set<String> quoteFields = new Set<String>();
        for(Sentinel_Order_Field_Mapping__c mapObj : quoteMappingFieldList) {
            if(!String.isBlank(mapObj.SF_Api_Field__c) && 
                !mapObj.SF_Api_Field__c.contains('.') && 
                !mapObj.Category__c.equalsIgnoreCase('ProductSubscription') && 
                !mapObj.Category__c.equalsIgnoreCase('EntitlementSubscription') && mapObj.sObjectName__c.equalsIgnoreCase('Subscription')) {
                quoteFields.add(mapObj.SF_Api_Field__c);
            }
        }
        return quoteFields;
    }
}