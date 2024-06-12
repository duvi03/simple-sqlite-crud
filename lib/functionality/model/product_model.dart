class Product{
  int? id;
  String? productName;
  String? productImage;
  String? productDesc;

  productMap(){
    var mapping = <String,dynamic>{};
    mapping['id'] = id ?? null;
    mapping['productName'] = productName;
    mapping['productImage'] = productImage;
    mapping['productDesc'] = productDesc;
    return mapping;
  }

  @override
  String toString() {
    return 'Product{id: $id, productName: $productName, productImage: $productImage, productDesc: $productDesc}';
  }
}