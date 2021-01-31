import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/order-provider.dart';
import 'package:shop_app/screens/orders-screen.dart';
import 'package:shop_app/screens/products-screen.dart';
import 'package:shop_app/screens/user-products-screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> userData =
        Provider.of<Auth>(context, listen: false).userData;
    return Drawer(
      child: Column(
        children: [
          // AppBar(
          //   title: Text(userName == null ? 'Error!':userName),
          //   automaticallyImplyLeading: false,
          // ),

          Container(
            padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:userData['userImageUrl']==null ?AssetImage('images/user.png'): NetworkImage(userData['userImageUrl']),
                  backgroundColor: Colors.white,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  userData['userName'] == null
                      ? 'Error!'
                      : userData['userName'],
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                )
              ],
            ),
          ),
          Divider(),
          ListTileDrawer(
            text: 'Shop',
            iconData: Icons.shop,
            onTapped: () {
              Navigator.pushReplacementNamed(context, ProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTileDrawer(
            text: ' Orders',
            iconData: Icons.payment,
            onTapped: () {
              Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTileDrawer(
            text: ' Manage Products',
            iconData: Icons.payment,
            onTapped: () {
              Navigator.pushReplacementNamed(
                  context, UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTileDrawer(
            text: ' LogOut',
            iconData: Icons.exit_to_app,
            onTapped: () {
              Navigator.pushReplacementNamed(context, '/');
              Provider.of<Auth>(context, listen: false).logout();
              Provider.of<Orders>(context, listen: false)
                  .clearOrdersUserLogout();
            },
          ),
        ],
      ),
    );
  }
}

class ListTileDrawer extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Function onTapped;
  ListTileDrawer({this.text, this.iconData, this.onTapped});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        iconData,
        //size: 26.0,
      ),
      title: Text(
        text,
        //style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      onTap: onTapped,
    );
  }
}
