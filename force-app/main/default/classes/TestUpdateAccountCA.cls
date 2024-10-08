@isTest
private class TestUpdateAccountCA {
    @isTest static void testLargeOrderUpdate() {
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

        // Activate the contract
        con.Status = 'Activated';
        update con;

        // Create a list of 100 orders for the same account
        List<Order> orders = new List<Order>();
        for (Integer i = 0; i < 100; i++) {
            Order ord = new Order(
                AccountId = acc1.Id,
                EffectiveDate = Date.today(),
                Status = 'Draft',
                ContractId = con.Id,
                Pricebook2Id = Test.getStandardPricebookId()  // Assign the standard price book to the Order
            );
            orders.add(ord);
        }
        insert orders;

        // Add two order items for each order
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Order ord : orders) {
            OrderItem oi = new OrderItem(OrderId = ord.Id, PricebookEntryId = pbe.Id, Quantity = 10, UnitPrice = 150);
            orderItems.add(oi);
            OrderItem oi2 = new OrderItem(OrderId = ord.Id, PricebookEntryId = pbe.Id, Quantity = 20, UnitPrice = 1000);
            orderItems.add(oi2);
        }
        insert orderItems;

        // Update all orders to 'Activated' status
        for (Order ord : orders) {
            ord.Status = 'Activated';
        }
        update orders;

        System.debug('Total Orders Updated: ' + orders.size());  // Debug to ensure all orders are updated

        Test.stopTest();  // End test block to finalize governor limits

        // Verify that the account's revenue is updated correctly after processing 100 orders
        Account accAfter = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc1.Id];
        System.debug('Account Revenue: ' + accAfter.Chiffre_d_affaire__c);  // Debug to verify revenue update

        // Calculate expected revenue based on 100 orders (each order with two items: 10 * 150 and 20 * 1000)
        Decimal expectedRevenue = 100 * (10 * 150 + 20 * 1000);
        System.assertEquals(expectedRevenue, accAfter.Chiffre_d_affaire__c, 'The account revenue should be updated correctly for 100 orders');
    }
}
