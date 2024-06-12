import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_sqlite_crud/functionality/model/product_model.dart';
import 'package:simple_sqlite_crud/functionality/services/product_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  late var _productImage = "";
  late bool _validateName = false;
  late bool _validateImage = false;
  late bool _validateDesc = false;

  final _productService = ProductService();

  File? galleryFile;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product Screen'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextField(
                controller: _productNameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter Product Name',
                  labelText: 'Product Name',
                  errorText:
                      _validateName ? 'Name Value Can\'t Be Empty' : null,
                )),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
                controller: _productDescriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter Product Description',
                  labelText: 'Product Description',
                  errorText: _validateDesc
                      ? 'Description Value Can\'t Be Empty'
                      : null,
                )),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              'Product Image',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () {
                _showPicker(context: context);
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2)),
                child: galleryFile == null
                    ? const Icon(Icons.camera_alt)
                    : Image.file(
                        galleryFile!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(
              height: 20.0,
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
                        _productNameController.text.isEmpty
                            ? _validateName = true
                            : _validateName = false;
                        _productImage.isEmpty
                            ? _validateImage = true
                            : _validateImage = false;
                        _productDescriptionController.text.isEmpty
                            ? _validateDesc = true
                            : _validateDesc = false;
                      });
                      if (_validateName == false &&
                          _validateImage == false &&
                          _validateDesc == false) {
                        print("Good Data Can Save");
                        var _product = Product();
                        _product.productName = _productNameController.text;
                        _product.productImage = _productImage;
                        _product.productDesc =
                            _productDescriptionController.text;
                        var result =
                            await _productService.saveProduct(_product);
                        Navigator.pop(context, result);
                      }
                    },
                    child: const Text('Save Details')),
                const SizedBox(
                  width: 10.0,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        textStyle: const TextStyle(fontSize: 15)),
                    onPressed: () {
                      _productNameController.text = '';
                      _productImage = "";
                      _productDescriptionController.text = '';
                    },
                    child: const Text('Clear Details'))
              ],
            )
          ]),
        ),
      ),
    );
  }

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
          _productImage = "${galleryFile.toString()}";
          print("galleryFile $galleryFile");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
