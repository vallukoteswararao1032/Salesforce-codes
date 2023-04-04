@isTest
public class SentinelFunctionalityUtil {

    static Account acc;
    static Opportunity opp;
    static Contact con;
    static Product2 product;
    static Integer s_num = 1;

    static PricebookEntry pbe;
    static SBQQ__Quote__c quote;
    static SBQQ__QuoteLine__C quoteLine;
    public static Order ord;
    static OrderItem ordItm;

    
    public static void setupTestData(){


        Test.startTest();
        List<Sentinel_Order_Field_Mapping__c> ordFldMapings = new List<Sentinel_Order_Field_Mapping__c>();
        
        // Test data setup for Order
        Sentinel_Order_Field_Mapping__c ordFldMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('Order', 'Order', 'Status', '');
        Sentinel_Order_Field_Mapping__c ordFldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('Order', 'Order', 'Name', '');
        Sentinel_Order_Field_Mapping__c ordEnt1FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('Entitlement', 'Order', 'EID__c', 'EID');
        Sentinel_Order_Field_Mapping__c ordEnt2FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('Entitlement', 'Order', 'PoNumber', 'refId1');
        Sentinel_Order_Field_Mapping__c ordEnt3FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('Entitlement', 'Order', 'Account.AccountNumber', 'refId2');
        Sentinel_Order_Field_Mapping__c ordEnt4FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('Entitlement', 'Order', 'userRegistration__c', 'userRegistration');
        // Sentinel_Order_Field_Mapping__c ordEnt5FldNameMaping = SentinelCPQTestDataFactory.populateOrdCustomFldMapng('Entitlement', 'Order', 'OriginalOrder.Name', 'Order Type');
        
        ordFldMapings.add(ordFldMaping);
        ordFldMapings.add(ordFldNameMaping);
        ordFldMapings.add(ordEnt1FldNameMaping);
        ordFldMapings.add(ordEnt2FldNameMaping);
        ordFldMapings.add(ordEnt3FldNameMaping);
        ordFldMapings.add(ordEnt4FldNameMaping);
        // ordFldMapings.add(ordEnt5FldNameMaping);

        Sentinel_Order_Field_Mapping__c ordItmFldMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('Product', 'Order', 'Quantity', '');
        ordFldMapings.add(ordItmFldMaping);

        Sentinel_Order_Field_Mapping__c ordC1FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('Customer', 'Order', 'Account.AccountNumber', 'externalId');
        Sentinel_Order_Field_Mapping__c ordC2FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('Customer', 'Order', 'Account.Name', 'customerName');
        Sentinel_Order_Field_Mapping__c ordC3FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('Customer', 'Order', 'Account.BillingCountry', 'customerIdentifier');
        Sentinel_Order_Field_Mapping__c ordC4FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('Customer', 'Order', 'Account.BillingState', 'refId');
        Sentinel_Order_Field_Mapping__c ordC5FldNameMaping = SentinelCPQTestDataFactory.populateOrdCustomFldMapng('Customer', 'Order', 'Account.BillingCity', 'Customer 1');
        ordFldMapings.add(ordC1FldNameMaping);
        ordFldMapings.add(ordC2FldNameMaping);
        ordFldMapings.add(ordC3FldNameMaping);
        ordFldMapings.add(ordC4FldNameMaping);
        ordFldMapings.add(ordC5FldNameMaping);
        
        Sentinel_Order_Field_Mapping__c ordCC1FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContact', 'Order', 'Account.ShippingCity', 'shippingAddress.city');
        Sentinel_Order_Field_Mapping__c ordCC2FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContact', 'Order', 'Account.ShippingCountry', 'shippingAddress.country');
        Sentinel_Order_Field_Mapping__c ordCC3FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContact', 'Order', 'Account.ShippingState', 'shippingAddress.state');
        Sentinel_Order_Field_Mapping__c ordCC4FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContact', 'Order', 'Account.ShippingPostalCode', 'shippingAddress.postalCode');
        Sentinel_Order_Field_Mapping__c ordCC5FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContact', 'Order', 'Account.Name', 'contactName');
        Sentinel_Order_Field_Mapping__c ordCC6FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContact', 'Order', 'Account.BillingCity', 'billingAddress.city');
        Sentinel_Order_Field_Mapping__c ordCC7FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContact', 'Order', 'Account.BillingCountry', 'billingAddress.country');
        Sentinel_Order_Field_Mapping__c ordCC8FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContact', 'Order', 'Account.BillingState', 'billingAddress.state');
        Sentinel_Order_Field_Mapping__c ordCC9FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContact', 'Order', 'Account.BillingPostalCode', 'billingAddress.postalCode');
        Sentinel_Order_Field_Mapping__c ordCC10FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContact', 'Order', 'BillToContact.Email', 'contactEmail');
        Sentinel_Order_Field_Mapping__c ordCC11FldNameMaping = SentinelCPQTestDataFactory.populateOrdCustomFldMapng('CustomerContact', 'Order', 'Account.ShippingCity', 'Alias Name');
        ordFldMapings.add(ordCC1FldNameMaping);
        ordFldMapings.add(ordCC2FldNameMaping);
        ordFldMapings.add(ordCC3FldNameMaping);
        ordFldMapings.add(ordCC4FldNameMaping);
        ordFldMapings.add(ordCC5FldNameMaping);
        ordFldMapings.add(ordCC6FldNameMaping);
        ordFldMapings.add(ordCC7FldNameMaping);
        ordFldMapings.add(ordCC8FldNameMaping);
        ordFldMapings.add(ordCC9FldNameMaping);
        ordFldMapings.add(ordCC10FldNameMaping);
        ordFldMapings.add(ordCC11FldNameMaping);

        Sentinel_Order_Field_Mapping__c ordCP1FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ChannelPartner', 'Order', 'Account.AccountNumber', 'partnerIdentifier');
        Sentinel_Order_Field_Mapping__c ordCP2FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ChannelPartner', 'Order', 'Account.AccountNumber', 'externalId');
        Sentinel_Order_Field_Mapping__c ordCP3FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ChannelPartner', 'Order', 'Account.AccountNumber', 'refId1');
        Sentinel_Order_Field_Mapping__c ordCP4FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ChannelPartner', 'Order', 'Account.ShippingPostalCode', 'shippingAddress.postalCode');
        Sentinel_Order_Field_Mapping__c ordCP5FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ChannelPartner', 'Order', 'Account.Name', 'partnerName');
        Sentinel_Order_Field_Mapping__c ordCP6FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ChannelPartner', 'Order', 'Account.BillingCity', 'billingAddress.city');
        Sentinel_Order_Field_Mapping__c ordCP7FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ChannelPartner', 'Order', 'Account.BillingCountry', 'billingAddress.country');
        Sentinel_Order_Field_Mapping__c ordCP8FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ChannelPartner', 'Order', 'Account.BillingState', 'billingAddress.state');
        Sentinel_Order_Field_Mapping__c ordCP9FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ChannelPartner', 'Order', 'Account.BillingPostalCode', 'billingAddress.postalCode');
        Sentinel_Order_Field_Mapping__c ordCP10FldNameMaping = SentinelCPQTestDataFactory.populateOrdCustomFldMapng('ChannelPartner', 'Order', 'Account.Name', 'Alias Name');
        ordFldMapings.add(ordCP1FldNameMaping);
        ordFldMapings.add(ordCP2FldNameMaping);
        ordFldMapings.add(ordCP3FldNameMaping);
        ordFldMapings.add(ordCP4FldNameMaping);
        ordFldMapings.add(ordCP5FldNameMaping);
        ordFldMapings.add(ordCP6FldNameMaping);
        ordFldMapings.add(ordCP7FldNameMaping);
        ordFldMapings.add(ordCP8FldNameMaping);
        ordFldMapings.add(ordCP9FldNameMaping);
        ordFldMapings.add(ordCP10FldNameMaping);


        // Test data setup for Quote    
        Sentinel_Order_Field_Mapping__c quoteFldMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('Quote', 'Quote', 'SBQQ__SubscriptionTerm__c', '');
        Sentinel_Order_Field_Mapping__c quoteEnt1FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('EntitlementQuote', 'Quote', 'EID__c', 'EID');
        Sentinel_Order_Field_Mapping__c quoteEnt2FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('EntitlementQuote', 'Quote', 'SBQQ__Account__r.AccountNumber', 'refId1');
        Sentinel_Order_Field_Mapping__c quoteEnt3FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('EntitlementQuote', 'Quote', 'SBQQ__Account__r.AccountNumber', 'refId2');
        Sentinel_Order_Field_Mapping__c quoteEnt4FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('EntitlementQuote', 'Quote', 'userRegistration__c', 'userRegistration');
        // Sentinel_Order_Field_Mapping__c quoteEnt5FldNameMaping = SentinelCPQTestDataFactory.populateOrdCustomFldMapng('EntitlementQuote', 'Quote', 'OriginalOrder.Name', 'Order Type');

        ordFldMapings.add(quoteFldMaping);
        ordFldMapings.add(quoteEnt1FldNameMaping);
        ordFldMapings.add(quoteEnt2FldNameMaping);
        ordFldMapings.add(quoteEnt3FldNameMaping);
        ordFldMapings.add(quoteEnt4FldNameMaping);
        // ordFldMapings.add(quoteEnt5FldNameMaping);

        Sentinel_Order_Field_Mapping__c quoteItmFldMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ProductQuote', 'Quote', 'SBQQ__Quantity__c', 'totalQuantity');
        ordFldMapings.add(quoteItmFldMaping);

        Sentinel_Order_Field_Mapping__c quoteC1FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerQuote', 'Quote', 'SBQQ__Account__r.AccountNumber', 'externalId');
        Sentinel_Order_Field_Mapping__c quoteC2FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerQuote', 'Quote', 'SBQQ__Account__r.Name', 'customerName');
        Sentinel_Order_Field_Mapping__c quoteC3FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerQuote', 'Quote', 'SBQQ__Account__r.AccountNumber	', 'customerIdentifier');
        Sentinel_Order_Field_Mapping__c quoteC4FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerQuote', 'Quote', 'SBQQ__Account__r.AccountNumber', 'refId');
        Sentinel_Order_Field_Mapping__c quoteC5FldNameMaping = SentinelCPQTestDataFactory.populateOrdCustomFldMapng('CustomerQuote', 'Quote', 'SBQQ__Account__r.Name', 'Customer 1');
        ordFldMapings.add(quoteC1FldNameMaping);
        ordFldMapings.add(quoteC2FldNameMaping);
        ordFldMapings.add(quoteC3FldNameMaping);
        ordFldMapings.add(quoteC4FldNameMaping);
        ordFldMapings.add(quoteC5FldNameMaping);
        
        Sentinel_Order_Field_Mapping__c quoteCC1FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContactQuote', 'Quote', 'SBQQ__Account__r.ShippingStreet', 'shippingAddress.city');
        Sentinel_Order_Field_Mapping__c quoteCC2FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContactQuote', 'Quote', 'SBQQ__Account__r.ShippingCountry', 'shippingAddress.country');
        Sentinel_Order_Field_Mapping__c quoteCC3FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContactQuote', 'Quote', 'SBQQ__Account__r.ShippingState', 'shippingAddress.state');
        Sentinel_Order_Field_Mapping__c quoteCC4FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContactQuote', 'Quote', 'SBQQ__Account__r.ShippingPostalCode', 'shippingAddress.postalCode');
        Sentinel_Order_Field_Mapping__c quoteCC5FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContactQuote', 'Quote', 'SBQQ__Account__r.Name', 'contactName');
        Sentinel_Order_Field_Mapping__c quoteCC6FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContactQuote', 'Quote', 'SBQQ__Account__r.BillingCity', 'billingAddress.city');
        Sentinel_Order_Field_Mapping__c quoteCC7FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContactQuote', 'Quote', 'SBQQ__Account__r.BillingCountry', 'billingAddress.country');
        Sentinel_Order_Field_Mapping__c quoteCC8FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContactQuote', 'Quote', 'SBQQ__Account__r.BillingState', 'billingAddress.state');
        Sentinel_Order_Field_Mapping__c quoteCC9FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContactQuote', 'Quote', 'SBQQ__Account__r.BillingPostalCode', 'billingAddress.postalCode');
        Sentinel_Order_Field_Mapping__c quoteCC10FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('CustomerContactQuote', 'Quote', 'SBQQ__PrimaryContact__r.Email', 'contactEmail');
        Sentinel_Order_Field_Mapping__c quoteCC11FldNameMaping = SentinelCPQTestDataFactory.populateOrdCustomFldMapng('CustomerContactQuote', 'Quote', 'SBQQ__Account__r.Name', 'Alias Name');
        ordFldMapings.add(quoteCC1FldNameMaping);
        ordFldMapings.add(quoteCC2FldNameMaping);
        ordFldMapings.add(quoteCC3FldNameMaping);
        ordFldMapings.add(quoteCC4FldNameMaping);
        ordFldMapings.add(quoteCC5FldNameMaping);
        ordFldMapings.add(quoteCC6FldNameMaping);
        ordFldMapings.add(quoteCC7FldNameMaping);
        ordFldMapings.add(quoteCC8FldNameMaping);
        ordFldMapings.add(quoteCC9FldNameMaping);
        ordFldMapings.add(quoteCC10FldNameMaping);
        ordFldMapings.add(quoteCC11FldNameMaping);

        Sentinel_Order_Field_Mapping__c quoteCP1FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ChannelPartnerQuote', 'Quote', 'SBQQ__Account__r.AccountNumber', 'partnerIdentifier');
        Sentinel_Order_Field_Mapping__c quoteCP2FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ChannelPartnerQuote', 'Quote', 'SBQQ__Account__r.AccountNumber', 'externalId');
        Sentinel_Order_Field_Mapping__c quoteCP3FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ChannelPartnerQuote', 'Quote', 'SBQQ__Account__r.AccountNumber', 'refId1');
        Sentinel_Order_Field_Mapping__c quoteCP4FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ChannelPartnerQuote', 'Quote', 'SBQQ__Account__r.ShippingPostalCode', 'shippingAddress.postalCode');
        Sentinel_Order_Field_Mapping__c quoteCP5FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ChannelPartnerQuote', 'Quote', 'SBQQ__Account__r.Name', 'partnerName');
        Sentinel_Order_Field_Mapping__c quoteCP6FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ChannelPartnerQuote', 'Quote', 'SBQQ__Account__r.BillingCity', 'billingAddress.city');
        Sentinel_Order_Field_Mapping__c quoteCP7FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ChannelPartnerQuote', 'Quote', 'SBQQ__Account__r.BillingCountry', 'billingAddress.country');
        Sentinel_Order_Field_Mapping__c quoteCP8FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ChannelPartnerQuote', 'Quote', 'SBQQ__Account__r.BillingState', 'billingAddress.state');
        Sentinel_Order_Field_Mapping__c quoteCP9FldNameMaping = SentinelCPQTestDataFactory.populateOrdFldMapng('ChannelPartnerQuote', 'Quote', 'SBQQ__Account__r.BillingPostalCode', 'billingAddress.postalCode');
        Sentinel_Order_Field_Mapping__c quoteCP10FldNameMaping = SentinelCPQTestDataFactory.populateOrdCustomFldMapng('ChannelPartnerQuote', 'Quote', 'SBQQ__Account__r.Name', 'Alias Name');
        ordFldMapings.add(quoteCP1FldNameMaping);
        ordFldMapings.add(quoteCP2FldNameMaping);
        ordFldMapings.add(quoteCP3FldNameMaping);
        ordFldMapings.add(quoteCP4FldNameMaping);
        ordFldMapings.add(quoteCP5FldNameMaping);
        ordFldMapings.add(quoteCP6FldNameMaping);
        ordFldMapings.add(quoteCP7FldNameMaping);
        ordFldMapings.add(quoteCP8FldNameMaping);
        ordFldMapings.add(quoteCP9FldNameMaping);
        ordFldMapings.add(quoteCP10FldNameMaping);

        insert ordFldMapings;

        // Pod__c pod = SentinelCPQTestDataFactory.createTestPod('CPQ Test',true);
        
        SentinelCPQTestDataFactory.createUserInfo();
        //List<sObject> ls = Test.loadData(Sentinel_Order_Field_Mapping__c.sObjectType, 'Sentinel_Order_Field_Mapping');
        List<Sentinel_Order_Field_Mapping__c> ls = SentinelUtil.getListOrderMapFields(SentinelConstants.categoryVsSentinelFieldMap, false);
        acc = SentinelCPQTestDataFactory.createAccount('Test Account', null, null);
        
        
        opp = SentinelCPQTestDataFactory.createOpportunity( acc.Id, 'Multiple', 'Prospecting');
        con = SentinelCPQTestDataFactory.createContact(acc.Id);
        product = SentinelCPQTestDataFactory.createProduct('Product X', 100);
        System.debug('$$$ product ' + product);
        pbe = SentinelCPQTestDataFactory.createPricebookEntry(product.Id, 100);
        
        Test.stopTest();
    }

    public static void populateData () {
        acc = [SELECT Id FROM Account LIMIT 01];
        opp = [SELECT Id FROM Opportunity LIMIT 01];
        con = [SELECT Id FROM Contact Limit 01];
        pbe = [SELECT Id FROM PriceBookEntry Limit 01];
        product = [SELECT Id FROM Product2 Limit 01];
        /*
        quote = [SELECT Id FROM SBQQ__Quote__c];
        quoteLine = [SELECT Id FROM SBQQ__QuoteLine__C];
        ord = [SELECT Id FROM Order];
        ordItm = [SELECT Id FROM OrderItem];
        */
        createData();
    }

    static void createData() {

        quote = SentinelCPQTestDataFactory.createQuote(acc.Id, opp.Id, con.Id, false);
        quote.SBQQ__Status__c = 'Activated';
        quote.EID__c = quote.Id;
        insert quote;
        quoteLine = SentinelCPQTestDataFactory.createQuoteLine(quote.Id, product.Id, pbe);

        ord = SentinelCPQTestDataFactory.createOrder(acc, pbe.Id, con.Id);
        ordItm = SentinelCPQTestDataFactory.createOrderItem(ord, product, pbe.Id, FALSE);
        ordItm.SBQQ__QuoteLine__c = quoteLine.Id;
        
        insert ordItm;
    }

    public static void updateQuote() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        acc = [SELECT Id FROM Account LIMIT 01];
        opp = [SELECT Id FROM Opportunity LIMIT 01];
        con = [SELECT Id FROM Contact Limit 01];
        pbe = [SELECT Id FROM PriceBookEntry Limit 01];
        product = [SELECT Id FROM Product2 Limit 01];
        Test.startTest();
        quote = SentinelCPQTestDataFactory.createQuote(acc.Id, opp.Id, con.Id, false);
        quote.SBQQ__Status__c = 'Draft';

        insert quote;
        quote.SBQQ__Status__c = 'Activated';
        update quote;
        Test.stopTest();

    }

    public static void updateOrders () {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Mock());
        /*
        populateData();

        SentinelOrderTriggerHandler hndlr = new SentinelOrderTriggerHandler();
        List<Order> newOrds = new List<Order>{ord};
        
        Map<Id, Order> newOrdMap = new Map<Id, Order>();
        newOrdMap.putAll(newOrds);
        
        Order oldOrd = ord.clone();
        oldOrd.Id = ord.Id;
        oldOrd.Name += ' oldOrd ';
        List<Order> oldOrds = new List<Order>{oldOrd};
        ord.Status = 'Activated';
        hndlr.onAfterUpdate(newOrds, oldOrds, newOrdMap);
        */

        Order oldOrd = new Order();
        oldOrd.Status = 'Draft';
        Order ord = new Order();
        ord.Status = 'Activated';
        ord.Id = getFakeId(Order.SObjectType);
        oldOrd.Id = ord.Id;
        List<Order> newOrds = new List<Order>{ord};
        List<Order> oldOrds = new List<Order>{oldOrd};
        Map<Id, Order> newOrdMap = new Map<Id, Order>();
        newOrdMap.putAll(newOrds);
        SentinelOrderTriggerHandler hndlr = new SentinelOrderTriggerHandler();
        hndlr.onAfterUpdate(oldOrds, newOrds, newOrdMap);
        SentinelConstants.integrationDone = false;
        // hndlr.syncEntitlements(oldOrd, ord);
        /*
        */
        Test.stopTest();

    }
    
    public static void updateOrders2 () {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Mock());
        

        String recId = getFakeId(Order.SObjectType);
        Order oldOrd = new Order();
        oldOrd.Status = 'Activated';
        oldOrd.Id = recId;

        Order ord = new Order();
        ord.Status = 'Activated';
        ord.Id = recId;
        ord.Name = ord.Id + ' Test';
        List<Order> newOrds = new List<Order>{ord};
        List<Order> oldOrds = new List<Order>{oldOrd};
        Map<Id, Order> newOrdMap = new Map<Id, Order>();
        newOrdMap.putAll(newOrds);
        SentinelOrderTriggerHandler hndlr = new SentinelOrderTriggerHandler();
        hndlr.onAfterUpdate(oldOrds, newOrds, newOrdMap);
        
        Test.stopTest();

    }
    

    public static void updateOrderItmsTest2 () {
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Mock());
        populateData();
        
        SentinelOrderItemTriggerHandler hndlr = new SentinelOrderItemTriggerHandler();
        List<OrderItem> newOrdItms = new List<OrderItem>{ordItm};
        Map<Id, OrderItem> newOrdItmMap = new Map<Id, OrderItem>();
        newOrdItmMap.putAll(newOrdItms);
        
        OrderItem oldOrdItm = ordItm.clone();
        oldOrdItm.Id = ordItm.Id;
        oldOrdItm.Quantity *= 2;
        List<OrderItem> oldOrdItms = new List<OrderItem>{oldOrdItm};

        hndlr.onAfterUpdate(newOrdItms, oldOrdItms, newOrdItmMap);
        Test.stopTest();

    }

    public static void updateOrderItmsTest () {
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Mock());
        populateData();
        
        SentinelUtil.syncEntitlements(new Set<String>{ord.Id}, 'op');
        Test.stopTest();

    }
    

    public static String getFakeId(Schema.SObjectType sot) {
        String result = String.valueOf(s_num++);
        return sot.getDescribe().getKeyPrefix() + 
            '0'.repeat(12-result.length()) + result;
    }

    public static void updateQuote2 () {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Mock());
        

        String recId = getFakeId(SBQQ__Quote__c.SObjectType);
        SBQQ__Quote__c oldQte = new SBQQ__Quote__c();
        oldQte.SBQQ__Status__c = 'Activated';
        oldQte.Id = recId;

        SBQQ__Quote__c qte = new SBQQ__Quote__c();
        qte.SBQQ__Status__c = 'Activated';
        qte.Id = recId;
        qte.SBQQ__SubscriptionTerm__c = ((qte.SBQQ__SubscriptionTerm__c == null) ? 2 : qte.SBQQ__SubscriptionTerm__c)  * 2;
        List<SBQQ__Quote__c> newQts = new List<SBQQ__Quote__c>{qte};
        List<SBQQ__Quote__c> oldQts = new List<SBQQ__Quote__c>{oldQte};
        Map<Id, SBQQ__Quote__c> newQtMap = new Map<Id, SBQQ__Quote__c>();
        newQtMap.putAll(newQts);
        SentinelQuoteTriggerHandler hndlr = new SentinelQuoteTriggerHandler();
        hndlr.onAfterInsert(newQts);
        hndlr.onAfterUpdate(oldQts, newQts, newQtMap);
        
        Test.stopTest();

    }

    public static void updateQuoteWithDiffStatus () {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Mock());
        

        String recId = getFakeId(SBQQ__Quote__c.SObjectType);
        SBQQ__Quote__c oldQte = new SBQQ__Quote__c();
        oldQte.SBQQ__Status__c = 'Approved';
        oldQte.Id = recId;

        SBQQ__Quote__c qte = new SBQQ__Quote__c();
        qte.SBQQ__Status__c = 'Activated';
        qte.Id = recId;
        qte.SBQQ__SubscriptionTerm__c = ((qte.SBQQ__SubscriptionTerm__c == null) ? 2 : qte.SBQQ__SubscriptionTerm__c)  * 2;
        List<SBQQ__Quote__c> newQts = new List<SBQQ__Quote__c>{qte};
        List<SBQQ__Quote__c> oldQts = new List<SBQQ__Quote__c>{oldQte};
        Map<Id, SBQQ__Quote__c> newQtMap = new Map<Id, SBQQ__Quote__c>();
        newQtMap.putAll(newQts);
        SentinelQuoteTriggerHandler hndlr = new SentinelQuoteTriggerHandler();
        hndlr.onAfterUpdate(oldQts, newQts, newQtMap);
        
        Test.stopTest();

    }

    public static void syncQuoteEntitlements() {
        try {
            Test.setMock(HttpCalloutMock.class, new Mock());
            populateData();
            SentinelUtil.syncQuoteEntitlements(new Set<String>{quote.Id}, 'op');
        }
        catch (Exception e) {
           
        }
        
    }

    public static void syncEntitlements() {
        try {
            Test.setMock(HttpCalloutMock.class, new Mock());
            populateData();
            SentinelUtil.syncEntitlements(new Set<String>{ord.Id}, 'op');
        }
        catch (Exception e) {
           
        }
        
    }
    
    /*
    public static void updateOrderItmsTest2 () {
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Mock());
        populateData();
        
        SentinelOrderItemTriggerHandler hndlr = new SentinelOrderItemTriggerHandler();
        List<OrderItem> newOrdItms = new List<OrderItem>{ordItm};
        Map<Id, OrderItem> newOrdItmMap = new Map<Id, OrderItem>();
        newOrdItmMap.putAll(newOrdItms);
        
        OrderItem oldOrdItm = ordItm.clone();
        oldOrdItm.Id = ordItm.Id;
        oldOrdItm.Quantity *= 2;
        List<OrderItem> oldOrdItms = new List<OrderItem>{ordItm};

        hndlr.onAfterUpdate(newOrdItms, oldOrdItms, newOrdItmMap);
        Test.stopTest();

    }
    */

    private class Mock implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().endsWith('abc')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{"token": "eyJraWQiOiJkc"}');
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint().endsWith('xyz')) {
                HTTPResponse res = new HTTPResponse();
                //res.setBody('{"status": "Success","entitlements": [{"status": "Success","entitlement":{"eId": "67672a46-e95b-4c8f-81a9-c79d2a54f5ad"}}]}');
                res.setBody('{"status":"Success","entitlements":[{"status":"Success","entitlement":{"creationDate":"2021-01-26 06:58","entitlementAsWhole":false,"eId":"b7537b00-9144-4c7c-858d-c1503043139f","id":"6cfa8290-03cc-481b-867a-5d947611425e","startDate":"2020-12-23","expiry":{"neverExpires":true},"customer":{"id":"b870dd64-d762-42c9-a963-d1aa89a0c821","name":"Rivercrest Engineering","identifier":"ca350ce2-4cdd-4fa2-82fe-0c8a610d7615","externalId":"IN0000041397"},"userRegistration":"OPTIONAL","refId1":"Q-71858","activationAllowed":true,"revocationAllowed":true,"state":"DRAFT","sendNotification":false,"isTest":false,"productKeys":{"productKey":[{"startDate":"2020-12-23","expiry":{"neverExpires":true},"id":"439862fa-5bb8-4b60-a28e-557ca09329d3","enforcement":{"id":"d467f0dc-2e4a-11eb-9468-06bf6ecdff30","name":"Sentinel RMS","version":"9.7"},"totalQuantity":1,"availableQuantity":1,"splittedQuantity":0,"activationMethod":"FIXED","fixedQuantity":1,"state":"DRAFT","item":{"itemProduct":{"product":{"externalId":"IWIC-ONESE-500-0-T1-FX-NEW-SUB","id":"e9dbc80e-b7ac-48a7-9af3-aa4e77823ba2","identifier":"764","nameVersion":{"name":"ICMOne 1D - Tier 1  (500 nodes) Subscription","version":"1.0"}}}},"commonLicenseAttributes":{"commonLicenseAttribute":[{"name":"LICENSE_VERSION","value":"21","displayText":"21 - RMS  9.7"},{"name":"ALLOW_VM_DETECTION","value":"1","displayText":"Enabled"},{"name":"CLIENT_1_CRITERIA","value":"2010","displayText":"Ethernet Address + UUID "}]},"activationAttributes":{"activationAttribute":[{"groupName":"LOCKING","name":"CLIENT_1_CRITERIA","value":"2010","readOnly":true,"mandatory":false,"associatedAttribute":{"name":"CLIENT_1_INFO","readOnly":false,"mandatory":true}}]},"customAttributes":{"customAttribute":[{"name":"License Type","value":"Subscription"}, '
                            +' {"name":"Line Item Number","value":" '+ ((null != quoteLine && String.isNotBlank(quoteLine.Name)) ?  quoteLine.Name : 'QL-0177365') +' "},{"name":"Vendor Data"}]}}]},"entitlementAttributes":{"entitlementAttribute":[{"name":"DURATION","value":"720","isSANL":false,"groupName":"CLOUD_SERVED"},{"name":"RENEW_FREQUENCY","value":"24","isSANL":false,"groupName":"CLOUD_SERVED"},{"name":"USAGE_SYNC_FREQUENCY","value":"24","isSANL":false,"groupName":"CLOUD_SERVED"},{"name":"FINGERPRINT_REGISTRATION","value":"true","isSANL":false,"groupName":"CLOUD_SERVED"},{"name":"REDUNDANCY_MAJORITY_RULE","value":"TRUE","isSANL":false,"groupName":"POLICY"},{"name":"REDUNDANT_SERVERS","value":"3","isSANL":false,"groupName":"LOCKING"}]}}}]}');
                res.setStatusCode(201);
                return res;
            } else {
                System.assert(false, 'unexpected endpoint ' + req.getEndpoint());
                return null;
            }
        }

    }
}