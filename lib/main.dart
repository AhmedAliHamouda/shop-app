import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart-provider.dart';
import 'package:shop_app/providers/order-provider.dart';
import 'package:shop_app/providers/products-provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart-screen.dart';
import 'package:shop_app/screens/edit-product-screen.dart';
import 'package:shop_app/screens/orders-screen.dart';
import 'package:shop_app/screens/product-detail-screen.dart';
import 'package:shop_app/screens/products-screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user-products-screen.dart';
import 'package:shop_app/widgets/custom-route-animation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
   runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: null,
          update: (context, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: null,
          update: (context, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
              accentColor: Colors.redAccent,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android:CustomPageTransitionBuilder(),
                TargetPlatform.iOS:CustomPageTransitionBuilder(),
              }),
            ),
            title: ' MyShop ',
            home: authData.isAuth
                ? ProductsScreen()
                : FutureBuilder(
                    future: authData.autoLogin(),
                    builder: (ctx, authSnapshot) =>
                        authSnapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            //initialRoute: authData.isAuth ? ProductsScreen.routeName : AuthScreen.routeName  ,
            routes: {
              AuthScreen.routeName: (context) => AuthScreen(),
              ProductsScreen.routeName: (context) => ProductsScreen(),
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              UserProductsScreen.routeName: (context) => UserProductsScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen(),
            },
          );
        },
      ),
    );
  }
}
