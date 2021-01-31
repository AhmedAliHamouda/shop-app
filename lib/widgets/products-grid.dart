import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products-provider.dart';
import 'package:shop_app/widgets/product-item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFav;

  ProductsGrid(this.showFav);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFav ? productsData.favoriteItems : productsData.items;
    return productsData.items.isEmpty
        ? Center(
            child: Text('NO Products Added Yet!'),
          )
        : GridView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemBuilder: (context, index) {
              return ChangeNotifierProvider.value(
                value: products[index],
                child: ProductItem(
                    // id: products[index].id,
                    // title: products[index].title,
                    // imageUrl: products[index].imageUrl,
                    ),
              );
            },
          );
  }
}
