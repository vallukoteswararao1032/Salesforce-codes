/*----------------------------------------------------
 * @name           SentinelOrderTriggerHandler
 * @date           10 May 2020
 * @description    This is a handler class for SentinelOrderTrigger.
 * ------------------------------------------------------*/
public with sharing class SentinelOrderTriggerHandler{
	private Sentinel_User_Info__c configObj;
	private List<Sentinel_Order_Field_Mapping__c> orderMappingFieldList;

	public SentinelOrderTriggerHandler(){
		configObj = Sentinel_User_Info__c.getOrgDefaults();
		orderMappingFieldList = Sentinel_Order_Field_Mapping__c.getall().values();
	}

	public void onAfterInsert(List<Order> newOrders){
		//EXECUTE AFTER INSERT LOGIC
		//SentinelUtil.syncEntitlements(new Set<String>{newOrders[0].id}, 'create');
	}

	public void onAfterUpdate(List<Order> oldOrders, List<Order> updatedOrders, Map<Id, Order> OrderMap){
		//AFTER UPDATE LOGIC
		Map<String, String> sentinelToOrderStatusMap = new Map<String, String>();
        sentinelToOrderStatusMap = getMappedodrstatusvalue();
        System.debug('sentinelToOrderStatusMap-----'+sentinelToOrderStatusMap);

		Set<String> mappedOdrFields = getMappedOrderFields();
		Boolean odrSentForProcessing = false;
		if (!mappedOdrFields.isEmpty() || !sentinelToOrderStatusMap.isEmpty()){
			for (Order odr : oldOrders){
				Order newOdr = OrderMap.get(odr.id);
				if (odr.Last_Sync__c != null){
					system.debug('OT-Old Order Last_Sync__c: ' + odr.Last_Sync__c);
				} else{
					system.debug('OT-Old Order Last_Sync__c is empty or null');
				}
				if (newOdr.Last_Sync__c != null){
					system.debug('OT-New Order Last_Sync__c: ' + newOdr.Last_Sync__c);
				} else{
					system.debug('OT-New Order Last_Sync__c is empty or null');
				}
				system.debug('OT-Old Order Status :' + odr.Status);
				system.debug('OT-New Order Status :' + newOdr.Status);
				if (odr.SBQQ__Quote__c != null){
					system.debug('OT-order created from Quote');
				} else{
					system.debug('OT-Direct order');
				}
				if (odr.Status != newOdr.Status && newOdr.Status != 'Draft' && (sentinelToOrderStatusMap.get('Commit') != null || sentinelToOrderStatusMap.get('Closed') != null || sentinelToOrderStatusMap.get('Disable') != null) && (checkStatus(newOdr.Status))){

					system.debug('OT-Odr-1 :' + odr);

					if (!SentinelConstants.integrationDone){
						SentinelConstants.integrationDone = true;

						if ((odr.Status == 'Draft' || odr.Status == 'Activated' || odr.Status == 'Disable' || odr.Status == 'Commit' || odr.Status == 'Closed') && odr.EID__c != null && odr.SBQQ__Quote__c == null){
							system.debug('OT-EID1: ' + odr.EID__c);
							if (odr.Last_Sync__c == null){
								// First time created
								SentinelUtil.syncEntitlements(new Set<String>{newOdr.id}, 'createWithEid');
							} else{
								// Already entitlement created, So need to update
								SentinelUtil.syncEntitlements(new Set<String>{newOdr.id}, 'update');
							}
						} else if ((odr.Status == 'Draft' || odr.Status == 'Activated' || odr.Status == 'Disable' || odr.Status == 'Commit' || odr.Status == 'Closed') && odr.EID__c != null && odr.SBQQ__Quote__c != null){
							system.debug('OT-EID2: ' + odr.EID__c);
							SentinelUtil.syncEntitlements(new Set<String>{newOdr.id}, 'update');
						} else if (odr.EID__c == null && newOdr.EID__c == null){
							system.debug('OT-EID3: ' + odr.EID__c);
							SentinelUtil.syncEntitlements(new Set<String>{newOdr.id}, 'create');
						} else{
							system.debug('OT-reached to not covered case. So, Sentinel Connect API call not happend');
						}

						odrSentForProcessing = true;
						break;
					}
				} else if ((sentinelToOrderStatusMap.get('Commit') != null || sentinelToOrderStatusMap.get('Closed') != null || sentinelToOrderStatusMap.get('Disable') != null) && (checkStatus(newOdr.Status)) && newOdr.Status != 'Draft') {

					system.debug('OT-Odr-2 :' + odr);

					if (!System.isFuture()){
						for (String field : mappedOdrFields){

							system.debug('++A1' + odr.get(field));
							system.debug('++A2' + newOdr.get(field));

                            if (odr.get(field) != newOdr.get(field)){
                                system.debug('++A3' + odr.get(field));
                                system.debug('++A4' + newOdr.get(field));
								if (!SentinelConstants.integrationDone){
									SentinelConstants.integrationDone = true;
									SentinelUtil.syncEntitlements(new Set<String>{newOdr.id}, 'update');
									odrSentForProcessing = true;
									break;
								}
							}
                            if (odr.get('Status') != newOdr.get('Status')){
                                System.debug('Status----'+odr.get('Status'));
                                System.debug('Status----'+newOdr.get('Status'));
                                if (!SentinelConstants.integrationDone){
                                    SentinelConstants.integrationDone = true;
                                    SentinelUtil.syncEntitlements(new Set<String>{ newOdr.id }, 'update');
                                    odrSentForProcessing = true;
                                    break;
                                }
                            }
						}
					}
				} else{
					if (newOdr != null && newOdr.Status != null && newOdr.Status == 'Draft' && (sentinelToOrderStatusMap.get(newOdr.Status) != null)){
						system.debug('OT-Odr No need to call becoz it is in Draft state');
					} else{
						system.debug('OT-Odr other case');
					}
				}
				if (odrSentForProcessing)
					break;
			}
		}
	}

	public Set<String> getMappedOrderFields(){
		Set<String> ordFields = new Set<String>();
		//system.debug('++26Nov'+orderMappingFieldList);
		for (Sentinel_Order_Field_Mapping__c mapObj : orderMappingFieldList){

			//system.debug('++26Nov'+mapObj );

			if (mapObj.sObjectName__c.equalsIgnoreCase('Order') && !String.isBlank(mapObj.SF_Api_Field__c) && !mapObj.SF_Api_Field__c.contains('.') && !mapObj.Category__c.equalsIgnoreCase('Product')){
				ordFields.add(mapObj.SF_Api_Field__c);
                System.debug('ordFields____' + ordFields);
			}

		}
		return ordFields;
	}
	public Map<String, String> getMappedodrstatusvalue(){
        Map<String, String> ordFieldValue = new Map<String, String>();
        for (Sentinel_Order_Field_Mapping__c mapstatus : orderMappingFieldList){
            if (mapstatus.sObjectName__c.equalsIgnoreCase('Order') && !String.isBlank(mapstatus.SF_orderfield_value__c) && !mapstatus.SF_orderfield_value__c.contains('.') && !mapstatus.Category__c.equalsIgnoreCase('Product')){
                ordFieldValue.put(mapstatus.SF_orderfield_value__c, mapstatus.Sentinel_Status_value__c);
                System.debug('ordFieldValue_____' + ordFieldValue);
            }
        }
        return ordFieldValue;
    }

    public Boolean checkStatus(String key){
        Map<String, String> sentinelToOrderStatusMap = new Map<String, String>();
        sentinelToOrderStatusMap = getMappedodrstatusvalue();
        if(sentinelToOrderStatusMap.get(key) != null) {
            System.debug('key0000---'+sentinelToOrderStatusMap.get(key));
            return true;
        }
        return false;
    }
}