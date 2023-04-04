/*----------------------------------------------------
* @name           LoginSettingsController 
* @date           10 May 2020
* @description    This is a controller class for the setting page. 
* ------------------------------------------------------*/
public with sharing class LoginSettingsController {

    public Boolean                                        init                 = FALSE;
    @Testvisible private final Sentinel_User_Info__c      Settings;
    public string                                         option               {get;set;}

    public LoginSettingsController () {
        // ////  due to package unmanaged deployment/creation, 4 Nov 2020, remove namespace from fields and object  
        List<Sentinel_User_Info__c> rd = [SELECT Request_Timeout__c,
                                            Username__c, 
                                            Password__c, 
                                            Org_URL__c, 
                                            DML_Url__c,
                                            Order_Sync__c,
                                            ProdDML_Url__c,
                                            ProdOrg_URL__c,
                                            ProdUsername__c,
                                            ProdPassword__c,
                                            StageOrg_URL__c,
                                            StageDML_Url__c,
                                            StageUsername__c,
                                            StagePassword__c,
                                            Selected_Org__c,
                                            Quote_Sync__c,
                                            Subscription_Sync__c
                                        FROM /*SENTNL__Sentinel_User_Info__c*/ Sentinel_User_Info__c /*WHERE Name='Primary User'*/]; //// commenting due to package unmanaged deployment/creation, 4 Nov 2020, remove namespace   
        system.debug('rd=' + rd );
        if (rd.size() == 1) {
            Settings = rd[0];
        } else {
            Settings = new Sentinel_User_Info__c(Selected_Org__c = 'dev');
        }
    }
    
    public Sentinel_User_Info__c getSettings() {
        return Settings;
    }

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('dev','Developer')); 
        options.add(new SelectOption('stage','Stage')); 
        options.add(new SelectOption('prod','Production')); 
        return options; 
    }

    public PageReference rdSave() {
        try {
            upsert Settings;
        } catch (Exception e) {
            system.debug('Error:' + e.getMessage());
        }
        PageReference pgRef = new PageReference('/apex/LoginSettings?mode=view');
        pgRef.setRedirect(true);
        return pgRef;
    } 
    
    public PageReference editRedirect() {
        PageReference pgRef = new PageReference('/apex/LoginSettings?mode=edit');
        pgRef.setRedirect(true);
        return pgRef;
    }

    public PageReference cancelRedirect() {
        PageReference pgRef = new PageReference('/apex/LoginSettings?mode=view');
        pgRef.setRedirect(true);
        return pgRef;
    }
}