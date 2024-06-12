import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_sqlite_crud/functionality/model/product_model.dart';
import 'package:simple_sqlite_crud/functionality/screen/home_screen.dart';
import 'package:simple_sqlite_crud/functionality/screen/update_product_screen.dart';
import 'package:simple_sqlite_crud/functionality/services/product_service.dart';

class ViewProductScreen extends StatefulWidget {
  final Product product;

  const ViewProductScreen({super.key, required this.product});

  @override
  State<ViewProductScreen> createState() => _ViewProductScreenState();
}

class _ViewProductScreenState extends State<ViewProductScreen> {
  final _productService = ProductService();

  getAllProductDetails() async {
    var products = await _productService.readAllProduct();
    products.forEach((products) {
      setState(() {
        var productModel = Product();
        productModel.id = products['id'];
        productModel.productName = products['productName'];
        productModel.productImage = products['productImage'];
        productModel.productDesc = products['productDesc'];
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
    String imageString = widget.product.productImage ?? "";
    var splitImage =
        imageString.split(':').sublist(1).join(':').trim().replaceAll("'", "");

    File image = File(splitImage);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Product Name',
                    style: TextStyle(
                        color: Colors.teal,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(widget.product.productName ?? '',
                      style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 400,
              width: 500,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: Image.file(
                image,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Description',
                    style: TextStyle(
                        color: Colors.teal,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                const SizedBox(
                  height: 10,
                ),
                Text(widget.product.productDesc ?? '',
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.teal,
                        textStyle: const TextStyle(fontSize: 15)),
                    onPressed: () async {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateProductScreen(
                                      product: widget.product,
                                    ))).then((data) {
                          if (data != null) {
                            getAllProductDetails();
                            _showSuccessSnackBar(
                                'Product Detail Updated Success');
                          }
                        });
                      });
                    },
                    child: const Text('Update')),
                const SizedBox(
                  width: 10.0,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      textStyle: const TextStyle(fontSize: 15)),
                  onPressed: () {
                    setState(() {
                      _deleteFormDialog(context, widget.product.id);
                    });
                  },
                  child: const Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _deleteFormDialog(BuildContext context, productId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are You Sure to Delete',
              style: TextStyle(color: Colors.teal, fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red),
                  onPressed: () async {
                    var result = await _productService.deleteProduct(productId);
                    if (result != null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyHomePage()),
                          result: result);
                    }
                  },
                  child: const Text('Delete')),
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          );
        });
  }
}
