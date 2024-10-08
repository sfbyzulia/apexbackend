trigger UpdateAccountCA on Order (after update) {

    Set<Id> setAccountIds = new Set<Id>();

    for (Order newOrder : Trigger.new) {
        // Ensure AccountId and TotalAmount are not null
        if (newOrder.AccountId != null && newOrder.TotalAmount != null) {
            setAccountIds.add(newOrder.AccountId);
        }
    }

    if (!setAccountIds.isEmpty()) {
        // Retrieve related accounts
        Map<Id, Account> accountMap = new Map<Id, Account>([
            SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :setAccountIds
        ]);

        for (Order newOrder : Trigger.new) {
            if (newOrder.TotalAmount != null && accountMap.containsKey(newOrder.AccountId)) {
                Account acc = accountMap.get(newOrder.AccountId);
                // Initialize Chiffre_d_affaire__c to 0 if it's null
                acc.Chiffre_d_affaire__c = (acc.Chiffre_d_affaire__c != null) ? acc.Chiffre_d_affaire__c : 0;
                // Add the TotalAmount to Chiffre_d_affaire__c
                acc.Chiffre_d_affaire__c += newOrder.TotalAmount;
            }
        }
        // Update accounts with the new values
        update accountMap.values();
    }
}
