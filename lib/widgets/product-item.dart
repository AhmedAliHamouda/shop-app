import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart-provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products-provider.dart';
import 'package:shop_app/screens/product-detail-screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  //
  // ProductItem({
  //   this.id,
  //   this.title,
  //   this.imageUrl,
  // });

  @override
  Widget build(BuildContext context) {
    final productItem = Provider.of<Product>(context, listen: false);
    final products = Provider.of<Products>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData=Provider.of<Auth>(context,listen: false);
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(15.0),
        bottomLeft: Radius.circular(15.0),
      )),
      elevation: 5.0,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
        ),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                ProductDetailScreen.routeName,
                arguments: productItem.id,
              );
            },
            child: Hero(
              tag: productItem.id,
              child: FadeInImage(
                placeholder: AssetImage('images/loading.gif'),
                image: NetworkImage(productItem.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (context, productItem, child) => IconButton(
                icon: Icon(productItem.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  products.removeById(productItem.id);
                  productItem.toggleFavoriteStatue(authData.token,authData.userId);
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            title: Text(
              productItem.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                cart.addItem(
                    productItem.id, productItem.title, productItem.price);

                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text('Item Added To Cart!'),
                    action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          cart.removeSingleItem(productItem.id);
                        }),
                  ),
                );
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
