
class Product {
  String? content;
  List? imgUrls;
  String? id;
  String? name;
  String? price;
  String? category;



  Product({this.content,this.category,this.id,this.name,this.price,this.imgUrls});

  Product.fromJson(Map<String,dynamic> json) {
    content=json['content'];
    imgUrls=json['imgUrls'];
    id=json['userId'];
    name=json['name'];
    price=json['price'];
    category=json['category'];
  }

  Map<String, dynamic> toJson() =>{
    "content":content,
    "imgUrls":imgUrls,
    "userId":id,
    "name":name,
    "price":price,
    "category":category
  };

}