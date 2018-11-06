public class ProductsTriggerHandler {
    public static void beforeInsert(List<Product_table__c> products){
        for(Product_table__c prod:products){
                if(prod.Added_Date__c==null){
                    prod.Added_Date__c=Date.today();
                }
            if(prod.Product_Description__c==null){
                prod.Product_Description__c='No Description';
            }
            }
        List<Warehouse__c> whs=new List<Warehouse__c>();
        Map<Integer,Id> whs_Id=new Map<Integer,Id>();
        List<OrgConfiguration__c> period=new List<OrgConfiguration__c>();
        period=[Select PeriodTerm__c from OrgConfiguration__c];
        Decimal term=0;
        if(period.size()>0){
            term=period[0].PeriodTerm__c;
        }
        else term=60;
        List<Warehouse__c> inserted=new List<Warehouse__c>();
        List<Integer> index=new List<Integer>();
        for(Integer i=0;i<products.size();i++){
            Date add=products[i].Added_Date__c;
            whs=Database.query('Select Period_Start__c,Period_End__c from Warehouse__c where Period_Start__c<=:add and Period_End__c>=:add');
            if(whs.size()>0){
                whs_Id.put(i,whs[0].Id);
            }
            else {
                Warehouse__c wh=new Warehouse__c();
                Date EndDate=add+(Integer)term;
                wh.Name='Warehouse'+' '+add+' '+EndDate;
                wh.Period_Start__c=add;
                wh.Period_End__c=EndDate;
                inserted.add(wh);
                index.add(i);
            }
        }
        insert inserted;
        List<Id> insertedId=new List<Id>();
        for(Warehouse__c ware:inserted){
            insertedId.add(ware.Id);
        }
        for(Integer i=0;i<inserted.size();i++){
            whs_Id.put(index[i],insertedId[i]);
        }
        for(Integer i=0;i<products.size();i++){
            products[i].Warehouse__c=whs_Id.get(i);
        }
        
    }
}