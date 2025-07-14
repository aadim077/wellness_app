import "package:dio/dio.dart";
import 'package:flutter/material.dart';

// Dummy Product Model (you should replace it with your actual model)
class ProductModel {
  final int id;
  final String title;

  ProductModel({required this.id, required this.title});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
    );
  }
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final Dio dio = Dio();
  bool _isLoading = true;
  List<ProductModel> _productList = [];

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    try {
      final Response response = await dio.get('https://dummyjson.com/products');
      if (response.statusCode == 200) {
        List<dynamic> dynamicList = response.data['products'];
        setState(() {
          _productList =
              dynamicList.map((e) => ProductModel.fromJson(e)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error while fetching product: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _productList.length,
        itemBuilder: (ctx, i) {
          final product = _productList[i];
          return ListTile(
            title: Text(product.title),
            subtitle: Text('ID: ${product.id}'),
          );
        },
      ),
    );
  }
}
