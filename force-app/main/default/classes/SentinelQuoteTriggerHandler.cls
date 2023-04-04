/*----------------------------------------------------
 * @name           SentinelQuoteTriggerHandler
 * @date           8 Nov 2020
 * @description    This is a handler class for SentinelSFCPQQuoteTrigger.
 * ------------------------------------------------------*/
public with sharing class SentinelQuoteTriggerHandler{
	private Sentinel_User_Info__c configObj;
	private List<Sentinel_Order_Field_Mapping__c> quoteMappingFieldList;

	public SentinelQuoteTriggerHandler(){
		configObj = Sentinel_User_Info__c.getOrgDefaults();
		quoteMappingFieldList = Sentinel_Order_Field_Mapping__c.getall().values();
	}

	public void onAfterInsert(List<SBQQ__Quote__c> newQuotes){
		//EXECUTE AFTER INSERT LOGIC
		//SentinelUtil.syncEntitlements(new Set<String>{newQuotes[0].id}, 'create');
	}

	public void onAfterUpdate(List<SBQQ__Quote__c> oldQuotes, List<SBQQ__Quote__c> updatedQuotes, Map<Id, SBQQ__Quote__c> QuoteMap){
		//AFTER UPDATE LOGIC
		Set<String> mappedQuoteFields = getMappedQuoteFields();
		Boolean quoteSentForProcessing = false;

		system.debug('++eidchecked1' + SentinelConstants.isEidEntered);


		if (!mappedQuoteFields.isEmpty()){
			for (SBQQ__Quote__c quote : oldQuotes){
				SBQQ__Quote__c newQuote = QuoteMap.get(quote.id);
				System.debug('quote Status : ' + quote.SBQQ__Status__c);
				System.debug('quote EID : ' + quote.EID__c);
				System.debug('quote Last Sync: ' + newQuote.Last_Sync__c);
				System.debug('newQuote Status: ' + newQuote.SBQQ__Status__c);
				System.debug('newQuote EID: ' + newQuote.EID__c);
				if (updatedQuotes.size() > 0){
					System.debug('updateQuote Status: ' + updatedQuotes.get(0).SBQQ__Status__c);
					System.debug('updateQuote EID: ' + updatedQuotes.get(0).EID__c);
				}
				system.debug('Checking Logic started');
				if (quote.SBQQ__Status__c != newQuote.SBQQ__Status__c && (newQuote.SBQQ__Status__c.equalsIgnoreCase('Activated') || newQuote.SBQQ__Status__c.equalsIgnoreCase('Approved') || newQuote.SBQQ__Status__c.equalsIgnoreCase('Disable') || newQuote.SBQQ__Status__c.equalsIgnoreCase('Commit'))){
					if (!SentinelConstants.integrationDone){
						SentinelConstants.integrationDone = true;

						System.debug('Case-1 executed ' + newQuote.SBQQ__Status__c);
						system.debug('++A1' + quote.SBQQ__Status__c);
						system.debug('++A1' + quote.EID__c);
						system.debug('++A1' + newQuote.SBQQ__Status__c);
						system.debug('++A1' + newQuote.EID__c);


						if (quote.SBQQ__Status__c == 'Draft' && quote.EID__c != null){
							if (quote.Last_Sync__c == null){
								SentinelUtil.syncQuoteEntitlements(new Set<String>{newQuote.id}, 'createWithEid');
							} else{
								system.debug('QT-update-1');
								SentinelUtil.syncQuoteEntitlements(new Set<String>{newQuote.id}, 'update');
							}
						} else if (quote.EID__c == null && newQuote.EID__c == null)
							SentinelUtil.syncQuoteEntitlements(new Set<String>{newQuote.id}, 'create');
						else if (quote.EID__c != null && quote.Last_Sync__c != null){
							system.debug('QT-update-2');
							SentinelUtil.syncQuoteEntitlements(new Set<String>{newQuote.id}, 'update');
						}
						quoteSentForProcessing = true;
						break;
					}
				} else if (newQuote.SBQQ__Status__c.equalsIgnoreCase('Activated') || newQuote.SBQQ__Status__c.equalsIgnoreCase('Approved') || newQuote.SBQQ__Status__c.equalsIgnoreCase('Disable') || newQuote.SBQQ__Status__c.equalsIgnoreCase('Commit')){
					if (!System.isFuture()){

						system.debug('++A1' + quote);

						for (String field : mappedQuoteFields){
							system.debug('++A1' + quote.get(field));
							system.debug('++A2' + newQuote.get(field));
							if (quote.get(field) != newQuote.get(field)){
								if (!SentinelConstants.integrationDone){
									SentinelConstants.integrationDone = true;
									system.debug('++A1' + quote);
									System.debug('Case-2 executed ' + newQuote.SBQQ__Status__c);
									SentinelUtil.syncQuoteEntitlements(new Set<String>{newQuote.id}, 'update');
									quoteSentForProcessing = true;
									break;
								}
							}
						}
					} else{
						system.debug('Case-2 else case executed');
					}
				} else{
					system.debug('Case-3 executed ' + newQuote.SBQQ__Status__c);
				}
				system.debug('Checking Logic completed');
				if (quoteSentForProcessing)
					break;
			}
		}
	}

	public Set<String> getMappedQuoteFields(){
		Set<String> quoteFields = new Set<String>();
		for (Sentinel_Order_Field_Mapping__c mapObj : quoteMappingFieldList){
			if (!String.isBlank(mapObj.SF_Api_Field__c) && !mapObj.SF_Api_Field__c.contains('.') && !mapObj.Category__c.equalsIgnoreCase('ProductQuote') && mapObj.sObjectName__c.equalsIgnoreCase('Quote')){
				quoteFields.add(mapObj.SF_Api_Field__c);
			}
		}
		return quoteFields;
	}
}