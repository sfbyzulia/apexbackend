trigger CalculMontant on Order (before update) {
    for (Order newOrder : Trigger.new) {
        // Check that TotalAmount and ShipmentCost__c are not null before doing the calculation
        Decimal totalAmount = (newOrder.TotalAmount != null) ? newOrder.TotalAmount : 0;
        Decimal shipmentCost = (newOrder.ShipmentCost__c != null) ? newOrder.ShipmentCost__c : 0;
        
        // Calculate the net amount
        newOrder.NetAmount__c = totalAmount - shipmentCost;
        
        System.debug('Calculated NetAmount__c: ' + newOrder.NetAmount__c);
    }
}
