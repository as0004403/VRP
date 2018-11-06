trigger ProductsTrigger on Product_table__c (before insert,before update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            ProductsTriggerHandler.beforeInsert(Trigger.New);
        }
        if(Trigger.isUpdate){
            List<Product_table__c> products=new List<Product_table__c>();
            for(Integer i=0;i<Trigger.size;i++){
                if(Trigger.New[i].Added_Date__c!=Trigger.Old[i].Added_Date__c){
                    products.add(Trigger.New[i]);
                }
            }
            ProductsTriggerHandler.beforeInsert(products);
        }
    }
}