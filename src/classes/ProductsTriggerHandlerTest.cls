@isTest
public class ProductsTriggerHandlerTest {
    @isTest static void beforeInsertTest(){
        List<Product_table__c> products=new List<Product_table__c>();
        for(Integer i=0;i<10;i++){
            products.add(new Product_table__c(Name='test'));
        }
        insert products;
        ProductsTriggerHandler.beforeInsert(products);
        update products;
        List<Product_table__c> pr=new List<Product_table__c>();
        pr=[Select Name,Added_Date__c,Warehouse__c from Product_table__c];
        System.assertEquals(date.today(), pr[0].Added_Date__c);
        List<Warehouse__c> wh=new List<Warehouse__c>();
        wh=[Select Name,Period_Start__c,Period_End__c from Warehouse__c];
        System.assertEquals(date.today(), wh[0].Period_Start__c);
        System.assertEquals(date.today()+60, wh[0].Period_End__c);
        System.assertEquals('Warehouse'+' '+date.today()+' '+(date.today()+60), wh[0].Name);
        Id whId=pr[0].Warehouse__c;
        System.assert(wh[0].Id==whId);
        List<Product_table__c> newProd=new List<Product_table__c>();
        newProd.add(new Product_table__c(Name='newProd',Added_date__c=date.today()));
        insert newProd;
        ProductsTriggerHandler.beforeInsert(newProd);
        update newProd;
        pr=[Select Name,Added_Date__c,Warehouse__c from Product_table__c where Name='newProd'];
        System.assertEquals(whId,pr[0].Warehouse__c);
        products[0].Added_Date__c=date.today()+61;
        update products[0];
        pr=[Select Name,Added_Date__c,Warehouse__c from Product_table__c where Added_Date__c=:date.today()+61];
        wh=[Select Name,Period_Start__c,Period_End__c from Warehouse__c where Id=:pr[0].Warehouse__c];
        System.assertEquals(date.today()+61+60, wh[0].Period_End__c);
    }
}