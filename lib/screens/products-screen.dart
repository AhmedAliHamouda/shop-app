import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart-provider.dart';
import 'package:shop_app/providers/products-provider.dart';
import 'package:shop_app/screens/cart-screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/main-drawer.dart';
import 'package:shop_app/widgets/products-grid.dart';

enum MenuOptions {
  myFavorites,
  allProducts,
}

class ProductsScreen extends StatefulWidget {
  static const String routeName = 'products-screen';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  var _showFavorites = false;
  var _isInit = true;
  var _isLoading = false;
  var userNameTest;

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) {
  //     if(_isInit){
  //       setState(() {
  //         _isLoading=true;
  //       });
  //
  //       Provider.of<Products>(context,listen: false).fetchData().then((_) {
  //         setState(() {
  //           _isLoading=false;
  //         });
  //       }).catchError((_){
  //         setState(() {
  //           _isLoading=false;
  //         });
  //       });
  //     }
  //     _isInit=false;
  //
  //   });
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchData().then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    Provider.of<Auth>(context, listen: false).getUserName();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (MenuOptions selectedValue) {
              setState(
                () {
                  if (selectedValue == MenuOptions.myFavorites) {
                    _showFavorites = true;
                  } else {
                    _showFavorites = false;
                  }
                },
              );
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('My Favorites'),
                value: MenuOptions.myFavorites,
              ),
              PopupMenuItem(
                child: Text('All Products'),
                value: MenuOptions.allProducts,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, child) {
              return Badge(
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      CartScreen.routeName,
                    );
                  },
                ),
                value: cartData.itemCount.toString(),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showFavorites),
      drawer: MainDrawer(),
    );
  }
}
