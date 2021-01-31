import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart-provider.dart';
import 'package:shop_app/providers/products-provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = 'product-detail-screen';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int numOfProducts = 1;

  Widget buildOutLineButton(IconData iconData, Function onPress) {
    return Container(
      height: 30,
      width: 30,
      child: OutlineButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: onPress,
        child: Container(
            child: Icon(
          iconData,
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(context).findById(productId);
    final products = Provider.of<Products>(context);
    final currentProduct = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SafeArea(
        // child: CustomScrollView(
        //   slivers: [
        //     SliverAppBar(
        //       expandedHeight: (MediaQuery.of(context).size.height -
        //           AppBar().preferredSize.height -
        //           MediaQuery.of(context).padding.top) *
        //           0.6,
        //       pinned: true,
        //       flexibleSpace: FlexibleSpaceBar(title: Text(product.title),centerTitle: true,background:Stack(
        //         children: [
        //           ClipPath(
        //             clipper: ClippingTest(),
        //             child: Container(
        //               height: (MediaQuery.of(context).size.height -
        //                   AppBar().preferredSize.height -
        //                   MediaQuery.of(context).padding.top) *
        //                   0.6,
        //               //width: (MediaQuery.of(context).size.width - MediaQuery.of(context).padding.right-MediaQuery.of(context).padding.left),
        //               //height: 400,
        //               width: double.infinity,
        //               child: Hero(
        //                 tag: product.id,
        //                 child: Image.network(
        //                   product.imageUrl,
        //                   fit: BoxFit.cover,
        //                 ),
        //               ),
        //             ),
        //           ),
        //           Positioned(
        //             bottom: 30.0,
        //             right: 30.0,
        //             child: CircleAvatar(
        //               radius: 30.0,
        //               child: IconButton(
        //                 iconSize: 35.0,
        //                 icon: Icon(Icons.favorite),
        //                 onPressed: () {
        //                   setState(() {
        //                     product.toggleFavoriteStatue(
        //                         authData.token, authData.userId);
        //                     products.removeById(product.id);
        //                   });
        //                 },
        //                 color: product.isFavorite
        //                     ? Theme.of(context).accentColor
        //                     : Colors.white,
        //               ),
        //             ),
        //           ),
        //           Positioned(
        //             left: MediaQuery.of(context).size.width / 2.5,
        //             bottom: 1.0,
        //             child: Text(
        //               '\$${product.price}',
        //               style: TextStyle(
        //                 color: Colors.blueGrey,
        //                 fontSize: 25.0,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //               textAlign: TextAlign.center,
        //             ),
        //           ),
        //         ],
        //       ),
        //       ),
        //
        //     ),
        //     SliverList(
        //       delegate: SliverChildListDelegate(
        //         [
        //           SizedBox(
        //             height: 10.0,
        //           ),
        //           Container(
        //             padding: EdgeInsets.symmetric(horizontal: 25.0),
        //             width: double.infinity,
        //             child: Text(
        //               product.description,
        //               textAlign: TextAlign.center,
        //               softWrap: true,
        //               style: TextStyle(
        //                 fontSize: 17.0,
        //                 //fontStyle: FontStyle.italic,
        //                 fontWeight: FontWeight.w600,
        //                 color: Colors.grey[700],
        //               ),
        //             ),
        //           ),
        //           SizedBox(
        //             height: 20,
        //           ),
        //           Container(
        //             //alignment: Alignment.center,
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 buildOutLineButton(Icons.remove, () {
        //                   setState(() {
        //                     if (numOfProducts > 1) {
        //                       numOfProducts--;
        //                     }
        //                   });
        //                 }),
        //                 Container(
        //                   margin: EdgeInsets.symmetric(horizontal: 10.0),
        //                   child: Text(
        //                     //if our item less than 10 it show 01 02 like that
        //                     numOfProducts.toString().padLeft(2, '0'),
        //                     style: TextStyle(fontSize: 20.0),
        //                   ),
        //                 ),
        //                 buildOutLineButton(Icons.add, () {
        //                   setState(() {
        //                     numOfProducts++;
        //                   });
        //                 }),
        //               ],
        //             ),
        //           ),
        //           SizedBox(height: 100.0),
        //
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: ClippingTest(),
                    child: Container(
                      height: (MediaQuery.of(context).size.height -
                              AppBar().preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.6,
                      //width: (MediaQuery.of(context).size.width - MediaQuery.of(context).padding.right-MediaQuery.of(context).padding.left),
                      //height: 400,
                      width: double.infinity,
                      child: Hero(
                        tag: product.id,
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30.0,
                    right: 30.0,
                    child: CircleAvatar(
                      radius: 30.0,
                      child: IconButton(
                        iconSize: 35.0,
                        icon: Icon(Icons.favorite),
                        onPressed: () {
                          setState(() {
                            product.toggleFavoriteStatue(
                                authData.token, authData.userId);
                            products.removeById(product.id);
                          });
                        },
                        color: product.isFavorite
                            ? Theme.of(context).accentColor
                            : Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2.5,
                    bottom: 1.0,
                    child: Text(
                      '\$${product.price}',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Positioned(
                  //     left: 20.0,
                  //     top: 20.0,
                  //     child: CircleAvatar(
                  //       backgroundColor: Colors.black54,
                  //       child: IconButton(
                  //         icon: Icon(Icons.arrow_back),
                  //         onPressed: () {},
                  //       ),
                  //     ))
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                width: double.infinity,
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 17.0,
                    //fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                //alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildOutLineButton(Icons.remove, () {
                      setState(() {
                        if (numOfProducts > 1) {
                          numOfProducts--;
                        }
                      });
                    }),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        //if our item less than 10 it show 01 02 like that
                        numOfProducts.toString().padLeft(2, '0'),
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    buildOutLineButton(Icons.add, () {
                      setState(() {
                        numOfProducts++;
                      });
                    }),
                  ],
                ),
              ),
              SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(20.0),
        height: 80,
        color: Colors.blueGrey[50],
        child: Row(
          children: [
            Icon(
              Icons.shopping_cart,
              size: 35,
              color: Colors.blueGrey,
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: FlatButton(
                //padding: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                color: Colors.blueGrey,
                onPressed: () {
                  currentProduct.addItemFromProductDetail(
                    productId: product.id,
                    title: product.title,
                    price: product.price,
                    productQuantity: numOfProducts,
                  );
                  Flushbar(
                    flushbarPosition: FlushbarPosition.BOTTOM,
                    flushbarStyle: FlushbarStyle.GROUNDED,
                    title: 'Great!',
                    message: ' Your Item Add to Cart!',
                    duration: Duration(seconds: 2),
                  ).show(context);
                },
                child: Text(
                  'Add To Cart',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClippingTest extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    path.quadraticBezierTo(
        5, size.height - 50, size.width / 5.0, size.height - 50);
    path.lineTo(size.width - 80.0, size.height - 50);
    path.quadraticBezierTo(
        size.width - 5, size.height - 50, size.width, size.height - 150);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
