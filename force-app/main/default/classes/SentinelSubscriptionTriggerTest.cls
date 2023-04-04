@isTest
private class SentinelSubscriptionTriggerTest {
    static Account account;
    static List<Account> childAccounts = new List<Account>();
    static Opportunity opportunity;
    static Product2 product;
    static PricebookEntry priceBookEntry;
    static SBQQ__Quote__c quote;
    static SBQQ__QuoteLine__C quoteLine;
    
    static void setupTestData(){
        account = CPQTestDataFactory.createAccount('TestParentAccount', null);
        Account childAccount1 = CPQTestDataFactory.createAccount(
            'TestChildAccount1', account.Id);
        Account childAccount2 = CPQTestDataFactory.createAccount(
            'TestChildAccount2',account.Id);
        Account childAccount3 = CPQTestDataFactory.createAccount(
            'TestChildAccount3',account.Id);
        childAccounts.add(childAccount1);
        childAccounts.add(childAccount2);
        childAccounts.add(childAccount3);
        
        opportunity = CPQTestDataFactory.createOpportunity(
           account.Id, 'Multiple', 'Prospecting');
        product = CPQTestDataFactory.createProduct('Product X', 100);
        priceBookEntry = CPQTestDataFactory.createPricebookEntry(product.Id, 100);
        quote = CPQTestDataFactory.createQuote(account.Id, opportunity.Id);
        quoteLine = CPQTestDataFactory.createQuoteLine(quote.Id, product.Id, priceBookEntry);
        Contract cntrct = CPQTestDataFactory.createContract(account.Id);
        CPQTestDataFactory.createSubscription(account.Id,cntrct.Id, product.Id, 100, 1000);
        Sentinel_Order_Field_Mapping__c ordFldMaping = new Sentinel_Order_Field_Mapping__c();
        ordFldMaping.Name = 'Test';
        ordFldMaping.Category__c = 'Test';
        ordFldMaping.Field_Description__c = 'Test';
        ordFldMaping.Field_Type__c = 'Text';
        ordFldMaping.SF_Api_Field__c = 'Test__c';
        ordFldMaping.sObjectName__c = 'Subscription';
        insert ordFldMaping;
            
    }
    
    static testMethod void testSave() {
        setupTestData();
        
        SentinelSubscriptionTriggerHandler handler = new SentinelSubscriptionTriggerHandler();
        handler.getMappedQuoteFields();
        //Your logic to verify stuff
    }
}