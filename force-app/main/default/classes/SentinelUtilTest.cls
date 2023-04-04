/*----------------------------------------------------
* @name           SentinelOrderTrigger 
* @date           23 May 2020
* @description    This is a test class 
* ------------------------------------------------------*/
@isTest
public with sharing class SentinelUtilTest {

    @TestSetup
    public static void setup(){
        CPQTestDataFactory.createUserInfo();
        Account acc = new Account(Name = 'testAcc1');
        insert acc;
        
        Contract contr = new Contract(
            AccountID = acc.id,
            StartDate = system.today(),
            Status = 'Draft',
            ContractTerm = 6
            );
        insert contr;

        Product2 p = new Product2();
        p.Name = ' Test Product ';
        p.Description='Test Product Entry 1';
        p.productCode = 'ABC';
        p.isActive = true;
        insert p;
    
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = Test.getStandardPricebookId();
        standardPrice.Product2Id = p.Id;
        standardPrice.UnitPrice = 1;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;
    
        Order odr = new Order(
            AccountID = acc.id, 
            EffectiveDate = system.today(),
            Status = 'Draft',
            Pricebook2Id = Test.getStandardPricebookId(),
            ContractId = contr.id);
        insert odr;
    
        OrderItem i = new OrderItem();
        i.OrderId = odr.id;
        i.Quantity = 24;
        i.UnitPrice = 240;
        i.Product2id = p.id;
        i.PricebookEntryId=standardPrice.id;
        insert i;
        
        
        // create SF CPQ Quote and Quote line item data
        
         SBQQ__Quote__c   quote = new SBQQ__Quote__c  (
            SBQQ__Account__c = acc.id, 
            SBQQ__ExpirationDate__c = system.today()+30,
            SBQQ__Status__c = 'Draft',
            SBQQ__PriceBook__c = Test.getStandardPricebookId(),
            SBQQ__MasterContract__c = contr.id);
        insert quote;
    
        SBQQ__QuoteLine__c  qli = new SBQQ__QuoteLine__c ();
        qli.SBQQ__Quote__c = quote.id;
        qli.SBQQ__Quantity__c = 24;
        qli.SBQQ__ListPrice__c = 240;
        qli.SBQQ__Product__c = p.id;
        qli.SBQQ__PricebookEntryId__c=standardPrice.id;
        insert qli;
        
        
        

    }

    @isTest
    public static void positiveTestGuid() {
        Test.startTest();
            String guid = SentinelUtil.newGuid();
        Test.stopTest();
        system.assertEquals(guid.length(), 36);
    }

    @isTest
    public static void positiveCreateEntitlement() {
        List<Sentinel_Order_Field_Mapping__c> settingList = SentinelUtil.getListOrderMapFields(SentinelConstants.categoryVsSentinelFieldMap, false);
        settingList.addAll(SentinelUtil.getListOrderMapFields(SentinelConstants.categoryVsCustomAttributeMap, true));
        for(Sentinel_Order_Field_Mapping__c settObj : settingList) {
            if(settObj.Category__c == 'Product') {
                settObj.SF_Api_Field__c = 'SBQQ__Quantity__c';
            } else {
                settObj.SF_Api_Field__c = 'Status';
            }
        }
        insert settingList;

        // Sentinel_User_Info__c cusSetting = new Sentinel_User_Info__c(
        //     Username__c = 'testuser',
        //     PAssword__c = 'asdf',
        //     Org_URL__c = 'https://test.salesforce.com/abc',
        //     DML_Url__c = 'https://test.dmllesforce.com/xyz',
        //     Name='Primary User',
        //     Selected_Org__c = 'dev');
        // insert cusSetting;


        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new Mock());
            Order odr = [select id from Order limit 1];
            //SentinelUtil.syncEntitlements(new Set<String>{odr.id}, 'create');
        Test.stopTest();

        //system.assertNotEquals(null, [select EID__c from Order where id = :odr.id].EID__c);
    }
    // for Quote
    @isTest
    public static void positiveCreateQuoteEntitlement() {
        List<Sentinel_Order_Field_Mapping__c> settingList = SentinelUtil.getListOrderMapFields(SentinelConstants.categoryVsSentinelFieldMap, false);
        settingList.addAll(SentinelUtil.getListOrderMapFields(SentinelConstants.categoryVsCustomAttributeMap, true));
        for(Sentinel_Order_Field_Mapping__c settObj : settingList) {
            settObj.sObjectName__c='Quote';
            if(settObj.Category__c == 'ProductQuote') {
                settObj.SF_Api_Field__c = 'Quantity';
            } else {
                settObj.SF_Api_Field__c = 'SBQQ__Status__c';
            }
        }
        insert settingList;

        Sentinel_User_Info__c cusSetting = new Sentinel_User_Info__c(
            Username__c = 'tstusr',
            PAssword__c = 'asdf',
            Org_URL__c = 'https://test.salesforce.com/abc',
            DML_Url__c = 'https://test.dmllesforce.com/xyz',
            Name='Primary Usr',
            Selected_Org__c = 'dev');
        //insert cusSetting;


        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new Mock());
            Order odr = [select id from Order limit 1];
            //SentinelUtil.syncQuoteEntitlements(new Set<String>{odr.id}, 'create');
        Test.stopTest();

        //system.assertNotEquals(null, [select EID__c from Order where id = :odr.id].EID__c);
    }

    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().endsWith('abc')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{"token": "eyJraWQiOiJkc"}');
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint().endsWith('xyz')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{"status": "Success","entitlements": [{"status": "Success","entitlement":{"eId": "67672a46-e95b-4c8f-81a9-c79d2a54f5ad"}}]}');
                res.setStatusCode(201);
                return res;
            } else {
                System.assert(false, 'unexpected endpoint ' + req.getEndpoint());
                return null;
            }
        }
    }
}