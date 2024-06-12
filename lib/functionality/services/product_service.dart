
import 'package:simple_sqlite_crud/functionality/db_helper/repository.dart';
import 'package:simple_sqlite_crud/functionality/model/product_model.dart';

class ProductService {
  late Repository _repository;

  ProductService() {
    _repository = Repository();
  }

  saveProduct(Product product) async {
    return await _repository.insertData('product', product.productMap());
  }

  readAllProduct() async {
    return await _repository.readData('product');
  }

  updateProduct(Product product) async{
    return await _repository.updateData('product', product.productMap());
  }

  deleteProduct(productId) async {
    return await _repository.deleteDataById("product", productId);
  }
}
