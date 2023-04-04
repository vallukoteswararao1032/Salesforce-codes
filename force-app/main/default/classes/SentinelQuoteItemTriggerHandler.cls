/*----------------------------------------------------
* @name           SentinelQuoteItemTriggerHandler 
* @date           8 Nov 2020
* @description    This is a trigger on Salesforce CPQ object Quote to create/ update entitlement. 
* ------------------------------------------------------*/
public with sharing class SentinelQuoteItemTriggerHandler {

    private Sentinel_User_Info__c configObj;
    private List<Sentinel_Order_Field_Mapping__c> QuoteMappingFieldList;
     
    public SentinelQuoteItemTriggerHandler(){
        configObj = Sentinel_User_Info__c.getOrgDefaults();
        QuoteMappingFieldList = Sentinel_Order_Field_Mapping__c.getall().values();
    }

    public void onAfterInsert(List<SBQQ__QuoteLine__c> newQuoteItems){
        //EXECUTE AFTER INSERT LOGIC
        Set<Id> quoteSet = new Set<Id>();

        Boolean odrSentForProcessing = false;
        Set<Id> productIds = new Set<Id>();

        for(SBQQ__QuoteLine__c quoteItm : newQuoteItems) {
            productIds.add(quoteItm.SBQQ__Product__c);

        }

        Map<ID, Product2> mProduct2 = new Map<ID, Product2>([SELECT Id, Name, Thales__c FROM Product2 WHERE Id IN: productIds ]);

        for(SBQQ__QuoteLine__c quoteItm : newQuoteItems) {
            Product2 prdt = mProduct2.get(quoteItm.SBQQ__Product__c);
            if(prdt.Thales__c)
                quoteSet.add(quoteItm.SBQQ__Quote__c);
        }

        for(SBQQ__Quote__c quote : [select id from SBQQ__Quote__c where (SBQQ__Status__c = 'Activated' OR SBQQ__Status__c = 'Approved' OR SBQQ__Status__c = 'Disable' 
            OR SBQQ__Status__c = 'Commit' ) and Eid__c != null and Id IN :quoteSet limit 1]) {
            if(!SentinelConstants.integrationDone) {
                SentinelConstants.integrationDone = true;
                system.debug('onAfterInsert syncQuoteEntitlements called');
                SentinelUtil.syncQuoteEntitlements(new Set<String>{quote.id}, 'update');
            }
        }
    }
     
    public void onAfterUpdate(List<SBQQ__QuoteLine__c> oldQuoteItems, List<SBQQ__QuoteLine__c> updatedQuoteItems, Map<Id, SBQQ__QuoteLine__c> QuoteItemMap){
        //AFTER UPDATE LOGIC
        Set<String> mappedOdrItemFields= getMappedQuoteItemFields();
        Set<Id> quoteSet = new Set<Id>();
        system.debug('onAfterUpdate mappedOdrItemFields==' + mappedOdrItemFields);
        if(!mappedOdrItemFields.isEmpty()) {
            Map<Id, SBQQ__QuoteLine__c> mQuoteLineDBRec = fetchQuoteLine(oldQuoteItems);
            for(SBQQ__QuoteLine__c quoteItm : oldQuoteItems) {
                SBQQ__QuoteLine__c quoteLineDBRec = mQuoteLineDBRec.get(quoteItm.Id);
                if(quoteLineDBRec.SBQQ__Product__r.Thales__c){
                    SBQQ__QuoteLine__c newOdrItem = QuoteItemMap.get(quoteItm.id);
                    for(String field : mappedOdrItemFields) {
                        if(quoteItm.get(field) != newOdrItem.get(field)) {
                            quoteSet.add(newOdrItem.SBQQ__Quote__c);
                        }
                    }
                }
            }
        }        
        system.debug('onAfterUpdate quoteSet ==' + quoteSet );

        for(SBQQ__Quote__c quote : [select id from SBQQ__Quote__c where (SBQQ__Status__c = 'Activated' OR SBQQ__Status__c = 'Approved' OR SBQQ__Status__c = 'Disable'
        OR SBQQ__Status__c = 'Commit') and Eid__c != null and Id IN :quoteSet limit 1]) {
            system.debug('onAfterUpdate quote ==' + quote );
            if(!SentinelConstants.integrationDone) {
                SentinelConstants.integrationDone = true;
                system.debug('onAfterUpdate syncQuoteEntitlements called');
                SentinelUtil.syncQuoteEntitlements(new Set<String>{quote.id}, 'update');
            }
        }
    }

    public Set<String> getMappedQuoteItemFields() {
        Set<String> ordFields = new Set<String>();
        for(Sentinel_Order_Field_Mapping__c mapObj : QuoteMappingFieldList) {
            if(!String.isBlank(mapObj.SF_Api_Field__c) && 
                !mapObj.SF_Api_Field__c.contains('.') && 
                mapObj.Category__c.equalsIgnoreCase('ProductQuote') && mapObj.sObjectName__c.equalsIgnoreCase('Quote') ) {
                ordFields.add(mapObj.SF_Api_Field__c);
            }
        }
        return ordFields;
    }

    public Map<Id, SBQQ__QuoteLine__c> fetchQuoteLine (List<SBQQ__QuoteLine__c> quoteLines) {

        List<SBQQ__QuoteLine__c> quoteLineDBRecs = [SELECT Id, SBQQ__Product__r.Thales__c 
                                                        FROM SBQQ__QuoteLine__c 
                                                        WHERE Id IN: quoteLines
                                                    ];

        Map<Id, SBQQ__QuoteLine__c> mQuoteLineDBRec = new Map<Id, SBQQ__QuoteLine__c>();
        mQuoteLineDBRec.putAll(quoteLineDBRecs);
        return mQuoteLineDBRec;

    }
}