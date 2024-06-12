import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_sqlite_crud/functionality/model/product_model.dart';
import 'package:simple_sqlite_crud/functionality/screen/add_product_screen.dart';
import 'package:simple_sqlite_crud/functionality/screen/view_product_screen.dart';
import 'package:simple_sqlite_crud/functionality/services/product_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Product> _productList = <Product>[];
  final _productService = ProductService();

  getAllProductDetails() async {
    var products = await _productService.readAllProduct();
    _productList = <Product>[];
    products.forEach((products) {
      setState(() {
        var productModel = Product();
        productModel.id = products['id'];
        productModel.productName = products['productName'];
        productModel.productImage = products['productImage'];
        productModel.productDesc = products['productDesc'];
        _productList.add(productModel);
      });
    });
  }

  @override
  void initState() {
    getAllProductDetails();
    super.initState();
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text("CRUD SQFlite"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          padding: const EdgeInsets.all(8.0),
          itemCount: _productList.length,
          itemBuilder: (context, index) {
            String imageString = _productList[index].productImage ?? "";
            var splitImage = imageString
                .split(':')
                .sublist(1)
                .join(':')
                .trim()
                .replaceAll("'", "");

            File image = File(splitImage);
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewProductScreen(
                      product: _productList[index],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(color: Colors.grey.shade100, width: 1),
                    color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Image.file(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      _productList[index].productName ?? "",
                      style:
                          const TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddProductScreen())).then((data) {
            if (data != null) {
              getAllProductDetails();
              _showSuccessSnackBar('Product Detail Added Success');
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
