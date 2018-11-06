public class InfProd{
    public Product_table__c product{get;set;} 
    public Contact contact{get;set;}
    public String e_mail{get;set;}
    public String fn{get;set;}
    public String ln{get;set;}
    public Integer count{get;set;}
    public Double total{get;set;}
    public Order_table__c order{get;set;}
    public Id ProductId{get;set;}
    public Id ContactId{get;set;}
    
    public static String ReadParams(){
        String value=ApexPages.currentPage().getParameters().get('id');
        return value;
    }
    public InfProd(){
        product=[Select Name,chrct__c,Product_Description__c,Unit_Price__c,Units_Availble__c,Image_URL__c from Product_table__c where Id=:ReadParams()];
        
    }
   
    
    public PageReference buy(){
        
        Decimal Units=product.Units_Availble__c;
        List<Contact> Contacts=new List<Contact>();
        Contacts=[Select Email,FirstName,LastName from Contact where Email=:e_mail];
        if(Contacts.size()==1){
            contact=Contacts[0];
            contact.FirstName=fn;
            contact.LastName=ln;
            update(contact);
            ContactId=contact.Id;}
        else if(Contacts.size()==0){
            contact=new Contact(Email=e_mail,FirstName=fn,LastName=ln);
            insert(contact);
            ContactId=contact.Id;}
        else{
            for(Contact con: Contacts){
                contact=con;
                contact.FirstName=fn;
                contact.LastName=ln;
                update(contact);
                ContactId=contact.Id;
            }
        }
        
        ProductId=product.Id;
        if(count>0&&count<=product.Units_Availble__c){
            order=new Order_table__c();
            order.Units__c=count;
            order.Order_Amount__c=count*product.Unit_Price__c;
            order.Product__c=ProductId;
            order.Contact__c=ContactId;
            product.Units_Availble__c=Units-count;
            total=product.Unit_Price__c*count;
            update(product);
            insert(order);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm,'Order was done successfully'));
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Enter correct Unit count'));
            total=0;
        }
        return null;
    }
    public PageReference setParams(){
        PageReference page=Page.BuyProduct;
        page.getParameters().put('id',product.Id);
        page.setRedirect(true);
        return page;
        }
     public static PageReference back(){
         Pagereference page=Page.Products;
         return page;
     }
}