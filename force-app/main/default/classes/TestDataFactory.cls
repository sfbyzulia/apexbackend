public class TestDataFactory {

    // Method to create a test account
    public static Account createTestAccount() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        return acc;
    }

    // Method to create a test product
    public static Product2 createTestProduct() {
        Product2 prod = new Product2(Name = 'Test Product', Family = 'Test Family');
        insert prod;
        return prod;
    }

    // Method to create a pricebook entry
    public static PricebookEntry createPricebookEntry(Product2 prod) {
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = prod.Id,
            UnitPrice = 1000,
            IsActive = true
        );
        insert pbe;
        return pbe;
    }

    // Method to create a contract
    public static Contract createContract(Account acc) {
        Contract con = new Contract(
            AccountId = acc.Id,
            Status = 'Draft',
            StartDate = Date.today(),
            ContractTerm = 12
        );
        insert con;
        con.Status = 'Activated';
        update con;
        return con;
    }

    // Method to create an order
    public static Order createOrder(Account acc, Contract con, PricebookEntry pbe) {
        Order ord = new Order(
            AccountId = acc.Id,
            Status = 'Draft',
            ContractId = con.Id,
            EffectiveDate = Date.today(),
            Pricebook2Id = Test.getStandardPricebookId(),
            ShipmentCost__c = 100
        );
        insert ord;

        // Add multiple order items
        List<OrderItem> orderItems = new List<OrderItem>();
        OrderItem oi1 = new OrderItem(OrderId = ord.Id, PricebookEntryId = pbe.Id, Quantity = 1, UnitPrice = 1000);
        orderItems.add(oi1);
        OrderItem oi2 = new OrderItem(OrderId = ord.Id, PricebookEntryId = pbe.Id, Quantity = 20, UnitPrice = 1000);
        orderItems.add(oi2);
        insert orderItems;

        // Update order status to 'Activated'
        ord.Status = 'Activated';
        update ord;
        return ord;
    }
}
