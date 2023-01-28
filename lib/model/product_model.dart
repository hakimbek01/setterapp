
class Product {
  String? content;
  List? imgUrls;
  String? id;
  String? name;
  String? price;
  String? category;
  bool? isAvailable;



  Product({this.content,this.category,this.id,this.name,this.price,this.imgUrls,this.isAvailable});

  Product.fromJson(Map<String,dynamic> json) {
    content=json['content'];
    imgUrls=json['imgUrls'];
    id=json['id'];
    name=json['name'];
    price=json['price'];
    category=json['category'];
    isAvailable=json['isAvailable'];
  }

  Map<String, dynamic> toJson() =>{
    "content":content,
    "imgUrls":imgUrls,
    "id":id,
    "name":name,
    "price":price,
    "category":category,
    "isAvailable":isAvailable
  };

}