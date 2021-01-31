import 'package:flutter/material.dart';
import 'package:shop_app/screens/products-screen.dart';


class HomeScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: ProductsScreen(),
    );
  }
}

