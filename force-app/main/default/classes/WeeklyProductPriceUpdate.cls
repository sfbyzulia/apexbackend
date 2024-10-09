public class WeeklyProductPriceUpdate implements Schedulable {
    public void execute(SchedulableContext sc) {
        // Retrieve all active pricebook entries for the standard pricebook
        Id standardPricebookId = Test.getStandardPricebookId();  // Get the standard pricebook ID

        List<PricebookEntry> pricebookEntries = [
            SELECT Id, Product2Id, UnitPrice 
            FROM PricebookEntry 
            WHERE Pricebook2Id = :standardPricebookId AND IsActive = true
        ];

        // Increase the price of each product by 5%
        for (PricebookEntry pbe : pricebookEntries) {
            pbe.UnitPrice = pbe.UnitPrice * 1.05;
        }

        // Update the pricebook entries with the new prices
        update pricebookEntries;

        // Call the batch to update account revenue after product price change
        UpdateAccounts batchJob = new UpdateAccounts();
        Database.executeBatch(batchJob);
    }
}
