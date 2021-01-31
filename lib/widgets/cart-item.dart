import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart-provider.dart';

class CartItemProduct extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItemProduct(
      {this.id, this.title, this.price, this.quantity, this.productId});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (dir) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Are you Sure ?'),
                content: Text('Do you want to remove  This item from your Cart ?'),
                actions: [
                  FlatButton(onPressed: () { Navigator.pop(context,false);}, child: Text('No')),
                  FlatButton(onPressed: () {Navigator.pop(context,true);}, child: Text('Yes')),
                ],
              );
            });
      },
      onDismissed: (dir) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        padding: EdgeInsets.only(right: 20.0),
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40.0,
        ),
      ),
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              child: Padding(
                padding: EdgeInsets.all(7.0),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle:
                Text(' Total : \$${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text(' x $quantity'),
          ),
        ),
      ),
    );
  }
}
