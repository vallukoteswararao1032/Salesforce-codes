@isTest
private class SentinelOrderItemTriggerTest {
    static Product2 product;
    static PricebookEntry pbe;
    static SBQQ__Quote__c quote;
    static SBQQ__QuoteLine__C quoteLine;

    @testSetup
    static void setupTestData(){

        CPQTestDataFactory.createUserInfo();
        // List<sObject> ls = Test.loadData(Sentinel_Order_Field_Mapping__c.sObjectType, 'Sentinel_Order_Field_Mapping');    
        List<Sentinel_Order_Field_Mapping__c> ls = SentinelUtil.getListOrderMapFields(SentinelConstants.categoryVsSentinelFieldMap, false);

        Account acc = CPQTestDataFactory.createAccount('TestParentAccount', null);
        
        
        Opportunity opp = CPQTestDataFactory.createOpportunity(
           acc.Id, 'Multiple', 'Prospecting');
        Contact con = CPQTestDataFactory.createContact(acc.Id);
        product = CPQTestDataFactory.createProduct('Product X', 100);
        System.debug('$$$ product ' + product);
        pbe = CPQTestDataFactory.createPricebookEntry(product.Id, 100);
        Order ord = CPQTestDataFactory.createOrder(acc, pbe.Id, con.Id);
        

        OrderItem ordItm = CPQTestDataFactory.createOrderItem(ord, product, pbe.Id);
        
        quote = CPQTestDataFactory.createQuote(acc.Id, opp.Id, con.Id);
        quoteLine = CPQTestDataFactory.createQuoteLine(quote.Id, product.Id, pbe);
        Contract cntrct = CPQTestDataFactory.createContract(acc.Id);
        
        SBQQ__Subscription__c subscription = CPQTestDataFactory.createSubscription(acc.Id,cntrct.Id, product.Id, 100, 1000, false);
        subscription.SBQQ__QuoteLine__c = quoteLine.Id;

        insert subscription;

        List<Sentinel_Order_Field_Mapping__c> ordFldMapings = new List<Sentinel_Order_Field_Mapping__c>();
        
        Sentinel_Order_Field_Mapping__c ordFldMaping = CPQTestDataFactory.populateOrdFldMapng('Order', 'Order', 'Status');
        Sentinel_Order_Field_Mapping__c ordFldNameMaping = CPQTestDataFactory.populateOrdFldMapng('Order', 'Order', 'Name');
        ordFldMapings.add(ordFldMaping);
        ordFldMapings.add(ordFldNameMaping);
        //added by Bhavika on 21st Feb 2022
        Sentinel_Order_Field_Mapping__c ordC1FldNameMaping = CPQTestDataFactory.populateOrdFldMapng('Customer', 'Order', 'Account.Name');
		ordFldMapings.add(ordC1FldNameMaping);

        Sentinel_Order_Field_Mapping__c quoteFldMaping = CPQTestDataFactory.populateOrdFldMapng('Quote', 'Quote', 'SBQQ__SubscriptionTerm__c');
        ordFldMapings.add(quoteFldMaping);
        Sentinel_Order_Field_Mapping__c quoteItmFldMaping = CPQTestDataFactory.populateOrdFldMapng('ProductQuote', 'Quote', 'SBQQ__Quantity__c');
        ordFldMapings.add(quoteItmFldMaping);

        Sentinel_Order_Field_Mapping__c ordItmFldMaping = CPQTestDataFactory.populateOrdFldMapng('Product', 'Order', 'Quantity');
        ordFldMapings.add(ordItmFldMaping);
        insert ordFldMapings;
            
    }

    @isTest
    static void activateQuotesTest () {

        // Test.setMock(HttpCalloutMock.class, new Mock());
        // List<SBQQ__Quote__c> quotes = [SELECT Id, Name FROM SBQQ__Quote__c];
        // for (SBQQ__Quote__c qutoe : quotes) {
            
        //     qutoe.SBQQ__Status__c = 'Activated';
        //     //ordObj.EID__c = ordObj.Id;


        // }
        // update quotes;
        // SentinelConstants.integrationDone = false;
        // for (SBQQ__Quote__c qutoe : quotes) {
            
        //     qutoe.SBQQ__SubscriptionTerm__c = 24;
        //     //ordObj.EID__c = ordObj.Id;


        // }

        // update quotes;

    }

    @isTest
    static void qutoeLinesTest () {
        Test.setMock(HttpCalloutMock.class, new Mock());
        List<SBQQ__Quote__c> quotes = [SELECT Id, Name FROM SBQQ__Quote__c];
        for (SBQQ__Quote__c quote : quotes) {
            
            quote.SBQQ__Status__c = 'Activated';
            quote.EID__c = quote.Id;


        }
        update quotes;
        
        List<SBQQ__QuoteLine__c> quoteItms = [SELECT Id FROM SBQQ__QuoteLine__c];
        for (SBQQ__QuoteLine__c quoteItmObj : quoteItms) {
            
            
            quoteItmObj.SBQQ__Quantity__c = 10;

        }
        update quoteItms;

    }
    @isTest
    static void activateOrdersTest () {
        Test.setMock(HttpCalloutMock.class, new Mock());
        List<Order> ords = [SELECT Id, Name FROM Order];
        for (Order ordObj : ords) {
            
            ordObj.Status = 'Activated';
            //ordObj.EID__c = ordObj.Id;


        }
        update ords;
        SentinelConstants.integrationDone = false;
        for (Order ordObj : ords) {
            
            ordObj.Name += ' 2';
            //ordObj.EID__c = ordObj.Id;


        }

        update ords;

    }

    @isTest
    static void updateOrderItmsTest () {
        Test.setMock(HttpCalloutMock.class, new Mock());
        List<Order> ords = [SELECT Id FROM Order];
        for (Order ordObj : ords) {
            
            ordObj.Status = 'Activated';
            ordObj.EID__c = ordObj.Id;


        }
        update ords;
        List<OrderItem> ordItms = [SELECT Id, Product2.Thales__c FROM OrderItem];
        for (OrderItem ordItmObj : ordItms) {
            
            System.debug('$$$ ordItmObj ' + ordItmObj.Product2.Thales__c);
            ordItmObj.Quantity = 12;

        }
        update ordItms;

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