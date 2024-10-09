@isTest
private class TestUpdateAccountCA {
    @isTest static void testLargeOrderUpdate() {
        Test.startTest();  // Start test block to handle governor limits

        // Use TestDataFactory to create test data
        Account acc1 = TestDataFactory.createTestAccount();
        Product2 prod = TestDataFactory.createTestProduct();
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod);
        Contract con = TestDataFactory.createContract(acc1);

        // Create a list of 100 orders using the factory
        List<Order> orders = new List<Order>();
        for (Integer i = 0; i < 100; i++) {
            Order ord = TestDataFactory.createOrder(acc1, con, pbe);
            orders.add(ord);
        }

        // Insert orders and add order items (already handled in the factory)

        // Verify that the account's revenue is updated correctly after processing 100 orders
        Account accAfter = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc1.Id];
        Decimal expectedRevenue = 100 * (10 * 150 + 20 * 1000);  // Calculating expected revenue
        System.assertEquals(expectedRevenue, accAfter.Chiffre_d_affaire__c, 'The account revenue should be updated correctly for 100 orders');

        Test.stopTest();
    }
}
