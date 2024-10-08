public without sharing class MyTeamOrdersController {
    public decimal SumOrders{
        get{
            // Assuming there's a User field or custom logic to group orders by team
            AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE OwnerId = :UserInfo.getUserId()];
            return (decimal)groupedResults.get('total');
        }
        set;
    }
}
