import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart-provider.dart';
import 'package:shop_app/providers/order-provider.dart';
import 'package:shop_app/widgets/cart-item.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = 'cart-screen';
  @override
  Widget build(BuildContext context) {
    final cartItem = Provider.of<Cart>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Column(
        children: [
          Card(
            elevation: 5.0,
            margin: EdgeInsets.all(15.0),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Chip(
                    label: Text(
                      '\$${cartItem.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  OrderButton(cartItem: cartItem),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItem.items.length,
              itemBuilder: (context, index) {
                return CartItemProduct(
                  productId: cartItem.items.keys.toList()[index],
                  id: cartItem.items.values.toList()[index].id,
                  title: cartItem.items.values.toList()[index].title,
                  price: cartItem.items.values.toList()[index].price,
                  quantity: cartItem.items.values.toList()[index].quantity,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    @required this.cartItem,
  });

  final Cart cartItem;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

  var _isLoading=false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cartItem.totalAmount <=0 || _isLoading) ?null: ()  async {
        setState(() {
          _isLoading=true;
        });
         await Provider.of<Orders>(context, listen: false).addOrder(
            widget.cartItem.items.values.toList(), widget.cartItem.totalAmount);
        setState(() {
          _isLoading=false;
        });
        widget.cartItem.clearCart();

      },
      child:_isLoading ? CupertinoActivityIndicator(): Text(
        'Order Now',
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 15.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
