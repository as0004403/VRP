@isTest
public class Product_listTest {
    @isTest static void setParamsTest(){
        Product_table__c prod=new Product_table__c();
        prod.Name='good';
        insert prod;
        Id prodId=prod.Id;
        
        PageReference page=Product_list.setParams(prodId);
        System.assertEquals('/apex/infopage?id='+prodId, page.getUrl());
    }
    @isTest static void objCreating(){
        Product_table__c prod=new Product_table__c();
        prod.Name='good';
        insert prod;
        Product_list prList=new Product_list();
        List<Product_table__c> pr=new List<Product_table__c>();
        pr=prList.Products;
        System.assertEquals('good', pr[0].Name);
        System.assertEquals('', prList.link_more[0]);
        System.assertEquals('No Description',prList.description[0]);
        
        System.assertEquals(pr[0].Image_URL__c, prList.productionInfo[0].imgURL);
    }
}