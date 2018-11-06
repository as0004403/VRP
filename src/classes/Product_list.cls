public class Product_list{
    public List<Product_table__c> Products{get;set;}
    public List<String> link_description{get;set;}
    public List<URLclass> productionInfo{get;set;}
    public List<String> link_more{get;set;}
    public List<String> description{get;set;}
    public List<Id> ProductId{get;set;}
    public Product_list(){
        Products=new List<Product_table__c>();
        Products=[Select Name,Image_URL__c,Product_Description__c,Unit_price__c,chrct__c,d_link__c from Product_table__c];
        productionInfo=new List<URLclass>();
        link_more=new List<String>();
        description=new List<String>();
        ProductId=new List<Id>();
        for(Integer i=0;i<Products.size();i++){  
            if(Products[i].Product_Description__c==null){
                description.add(' ');
                link_more.add('');
            }
            if(Products[i].Product_Description__c.length()>100){
                String str_descr=(String)Products[i].Product_Description__c.left(100);
                str_descr+='...';
                description.add(str_descr);
                link_more.add('more');
                }
           
            
            else if(Products[i].Product_Description__c.length()>0){
                 description.add((String)Products[i].Product_Description__c) ; 
                 link_more.add('');
                }
            ProductId.add(Products[i].Id);
            }
        
        
        for(Integer i=0;i<Products.size();i++){
            
            productionInfo.add(new URLclass(Products[i],(String)Products[i].Image_URL__c,description[i],setParams((String)ProductId[i]),setParamsForBuy((String)ProductId[i]),link_more[i]));
        }
    }
    public static PageReference setParams(String prod){
        PageReference page=Page.InfoPage;
        page.getParameters().put('id',prod);
        page.setRedirect(true);
        return page;
    }

   public static PageReference setParamsForBuy(String prod){
        PageReference page=Page.BuyProduct;
        page.getParameters().put('id',prod);
        page.setRedirect(true);
        return page;
    }
    public class URLclass{
        public Product_table__c Prod{get;set;}
        public String imgURL{get;set;}
        public String descr{get;set;}
        public PageReference buy{get;set;}
        public PageReference Info{get;set;}
        public String more{get;set;}
        public URLclass(Product_table__c Prod,String imgURL,String descr,PageReference Info,PageReference buy,String more){
            this.Prod=Prod;
            this.imgURL=imgURL;
            this.descr=descr;
            this.Info=Info;
            this.buy=buy;
            this.more=more;
        }
       
    }
}