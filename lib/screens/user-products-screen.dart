import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products-provider.dart';
import 'package:shop_app/screens/edit-product-screen.dart';
import 'package:shop_app/widgets/main-drawer.dart';
import 'package:shop_app/widgets/user-product-item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user-product-screen';

  Future<void> refreshProducts(BuildContext context) async {
    final productsData = Provider.of<Products>(context, listen: false);
    if (productsData.items.isEmpty) {
      return;
    } else {
      await productsData.fetchData(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (context,productsData,_)=> Padding(
                        padding: EdgeInsets.all(10.0),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (context, index) {
                            return UserProductItem(
                              id: productsData.items[index].id,
                              title: productsData.items[index].title,
                              imageUrl: productsData.items[index].imageUrl,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
