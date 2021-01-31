import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order-provider.dart';
import 'package:shop_app/widgets/main-drawer.dart';
import 'package:shop_app/widgets/order-item.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = 'order-screen';
  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),

      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchDataOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => orderData.orders.isEmpty
                    ? Center(
                        child: Text('No Orders Added Yet !'),
                      )
                    : ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (ctx, index) =>
                            OrderItemProducts(orderData.orders[index]),
                      ),
              );
            }
          }
        },
      ),

      // body: _isLoading ? Center(child: CircularProgressIndicator()):ListView.builder(
      //   itemCount: orderData.orders.length,
      //   itemBuilder:(context,index){
      //     return OrderItemProducts(orderData.orders[index]);
      //   },
      // ),
      drawer: MainDrawer(),
    );
  }
}
