global class UpdateAccounts implements Database.Batchable<sObject>{
    
   global Database.QueryLocator start(Database.BatchableContext info){ 
       //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
       return Database.getQueryLocator('SELECT Id FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = \'Ordered\')');
   }
    
   global void execute(Database.BatchableContext info, List<Account> scope){      
    Map<Id, Decimal> accountRevenueMap = new Map<Id, Decimal>();
    List<Order> orders = [SELECT AccountId, TotalAmount FROM Order WHERE AccountId IN :scope AND Status = 'Ordered'];

    // Calculer le chiffre d'affaires pour chaque compte
    for (Order ord : orders) {
        if (accountRevenueMap.containsKey(ord.AccountId)) {
            accountRevenueMap.put(ord.AccountId, accountRevenueMap.get(ord.AccountId) + ord.TotalAmount);
        } else {
            accountRevenueMap.put(ord.AccountId, ord.TotalAmount);
        }
    }

    // Mettre à jour le chiffre d'affaires des comptes
    for (Account acc : scope) {
        acc.Chiffre_d_affaire__c = accountRevenueMap.containsKey(acc.Id) ? accountRevenueMap.get(acc.Id) : 0;
    }
    
       update scope;
   }    
    
   global void finish(Database.BatchableContext info){     
       
   } 
}