
class Product {
  String? content;
  List? imgUrls;
  String? id;
  String? name;
  String? price;
  String? category;
  bool? isAvailable;
  int? buyCount;
  String? date;
  bool? removeVisiable;


  Product({this.date,this.removeVisiable,this.content,this.buyCount,this.category,this.id,this.name,this.price,this.imgUrls,this.isAvailable});

  Product.fromJson(Map<String,dynamic> json) {
    removeVisiable=json['removeVisiable'];
    date=json['date'];
    content=json['content'];
    imgUrls=json['imgUrls'];
    id=json['id'];
    name=json['name'];
    price=json['price'];
    category=json['category'];
    isAvailable=json['isAvailable'];
    buyCount=json['buyCount'];
  }

  Map<String, dynamic> toJson() => {
    "removeVisiable":removeVisiable,
    "content":content,
    "date":date,
    "imgUrls":imgUrls,
    "buyCount":buyCount,
    "id":id,
    "name":name,
    "price":price,
    "category":category,
    "isAvailable":isAvailable
  };

}