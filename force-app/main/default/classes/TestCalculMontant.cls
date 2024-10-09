@isTest
private class TestCalculMontant {
    @isTest static void testNetAmountCalculation() {
        Test.startTest();  // Start test block

        // Use TestDataFactory to create test data
        Account acc1 = TestDataFactory.createTestAccount();
        Product2 prod = TestDataFactory.createTestProduct();
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod);
        Contract con = TestDataFactory.createContract(acc1);

        // Create an order with shipment cost and verify NetAmount
        Order ord1 = TestDataFactory.createOrder(acc1, con, pbe);

        // Verify that the NetAmount is calculated correctly
        Order ordAfter = [SELECT NetAmount__c FROM Order WHERE Id = :ord1.Id];
        Decimal expectedNetAmount = (1 * 1000 + 20 * 1000) - 100;  // TotalAmount - ShipmentCost
        System.assertEquals(expectedNetAmount, ordAfter.NetAmount__c, 'NetAmount should be correctly calculated as TotalAmount - ShipmentCost');

        Test.stopTest();
    }
}
