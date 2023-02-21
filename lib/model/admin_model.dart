class Admin {
  String? fullName;
  String? uid;
  List placedProduct=[];
  Admin({this.fullName,});

  Admin.fromJson(Map<String ,dynamic> json) {
    fullName=json['fullName'];
    placedProduct=json['placedProduct'];
    uid=json['uid'];
  }

  Map<String,dynamic> toJson ()=>{
    "fullName":fullName,
    "uid":uid,
    "placedProduct":placedProduct,
  };
}