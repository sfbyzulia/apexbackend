@isTest
private class testUpdateAccountCA {
    @isTest static void test() {
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;

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
            Status = 'Activated',
            StartDate = Date.today(),
            ContractTerm = 12
        );
        insert con;

        // Create an order with the required fields
        Order o1 = new Order(
            AccountId = acc1.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            ContractId = con.Id,
            ContractNumber = con.ContractNumber
        );
        insert o1;

        OrderItem oi1 = new OrderItem(OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity = 10, UnitPrice = 150);
        insert oi1;
        OrderItem oi2 = new OrderItem(OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity = 20, UnitPrice = 1000);
        insert oi2;
    }
}
