@isTest
public class Info_and_buy_testClass {
    @isTest static void buybuttonTest(){
        Product_table__c prod=testProd('test_good',10,25,date.today());
        insert prod;
        Infprod dat=setData(prod,'cc@cc.com','Alex','Demchik',3); 
        Contact con=new Contact(Email='cc@cc.com', LastName='bbb');
        insert con; 
        dat.buy();
        Contact totalContact=[Select LastName,FirstName From Contact where Email='cc@cc.com'];
        Product_table__c testProduct=[Select Units_Availble__c from Product_table__c];
        List<Order_table__c> order=[Select Name,Order_amount__c,Product__c,Contact__c from Order_table__c];
        System.assertEquals('Demchik', totalContact.LastName);
        System.assertEquals('Alex', totalContact.FirstName);
        System.assertEquals(7, testProduct.Units_Availble__c);
        System.assertEquals(1,order.size());
        System.assertEquals('test_good 75', order[0].Name);
        System.assertEquals(totalContact.Id, order[0].Contact__c);
    }
    @isTest static void buybuttonNegative(){
        Product_table__c prod=testProd('test_good',10,25,date.today());
        insert prod;
        Infprod dat=setData(prod,'cc@cc.com','Alex','Demchik',12); 
        dat.buy();
        Product_table__c testProduct=[Select Units_Availble__c from Product_table__c];
        Contact totalContact=[Select Email,LastName,FirstName From Contact];
        List<Order_table__c> order = new List<Order_table__c>();
        order=[Select Name,Order_amount__c,Product__c,Contact__c from Order_table__c];
        System.assertEquals('cc@cc.com Demchik', totalContact.Email+' '+totalContact.LastName);
        System.assertNotEquals(1, order.size(), 'Unit count must be less than'+prod.Units_Availble__c);
        System.assertEquals(10, testProduct.Units_Availble__c);
    }
    @isTest static void ReadParamsAndBackTest(){
        Product_table__c prod=testProd('test_good',10,25,date.today());
        insert prod;
        PageReference page=Product_list.setParams(prod.Id);
        Test.setCurrentPage(page);
        String id=InfProd.ReadParams();
        PageReference back=InfProd.back();
        System.assertEquals('/apex/products', back.getUrl());
        System.assertEquals(prod.Id, id);
    }
     public static Product_table__c testProd(String Name, Integer UnitsNumber,Integer Price,Date add){
        Product_table__c pr=new Product_table__c();
        pr.Name=Name;
        pr.Units_Availble__c=UnitsNumber;
        pr.Unit_Price__c=Price;
        pr.Added_Date__c=add;
        return pr;
    }
    static InfProd setData(Product_table__c prod,String email, String fn, String ln,Integer count){
        PageReference page=Product_list.setParamsForBuy(prod.Id);
        Test.setCurrentPage(page);
        Infprod dat=new InfProd(); 
        dat.e_mail=email;
        dat.fn=fn;
        dat.ln=ln;
        dat.count=count;
        return dat;
    }
}