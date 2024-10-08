@isTest
private class testRecordsCreation {
    @isTest static void test() {
        Test.startTest();  // Start test block to handle governor limits

        // Create a test account
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;

        // Create a test product
        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        insert pd1;

        // Create a PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        insert pbe;

        // Create a test contract with required fields
        Contract con = new Contract(
            AccountId = acc1.Id,
            Status = 'Draft',
            StartDate = Date.today(),
            ContractTerm = 12
        );
        insert con;

        // Create a test Order with required fields
        Order o1 = new Order(
            AccountId = acc1.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            ContractId = con.Id,
            Pricebook2Id = Test.getStandardPricebookId()  // Assign the standard price book to the Order
        );
        insert o1;

        // Add order items
        OrderItem oi1 = new OrderItem(OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity = 10, UnitPrice = 150);
        insert oi1;

        OrderItem oi2 = new OrderItem(OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity = 20, UnitPrice = 1000);
        insert oi2;

        // Update the Order to 'Activated' status for the batch class
        o1.Status = 'Activated';
        update o1;

        System.debug('Order Status: ' + o1.Status);  // Debug to ensure status update is correct

        // Execute the batch class
        UpdateAccounts batch = new UpdateAccounts();
        ID batchId = Database.executeBatch(batch);

        Test.stopTest();  // End test block to finalize governor limits

        // Verify that the account's revenue is updated
        Account accAfter = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc1.Id];
        System.debug('Account Revenue: ' + accAfter.Chiffre_d_affaire__c);  // Debug to verify revenue update
        System.assertEquals(12500, accAfter.Chiffre_d_affaire__c, 'The account revenue should be updated based on the order items');
    }
}
