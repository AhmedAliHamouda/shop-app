import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get items {
    return {..._cartItems};
  }

  int get itemCount {
    return _cartItems.length;
  }

  double get totalAmount {
    var total = 0.0;
    _cartItems.forEach((key, cartItem) {
      total += (cartItem.price * cartItem.quantity);
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
        productId,
        (exitingCartItem) => CartItem(
          id: exitingCartItem.id,
          title: exitingCartItem.title,
          price: exitingCartItem.price,
          quantity: exitingCartItem.quantity + 1,
        ),
      );
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void addItemFromProductDetail(
      {String productId, String title, double price, int productQuantity}) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
        productId,
        (exitingCartItem) => CartItem(
          id: exitingCartItem.id,
          title: exitingCartItem.title,
          price: exitingCartItem.price,
          quantity: exitingCartItem.quantity + productQuantity,
        ),
      );
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: productQuantity,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _cartItems.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_cartItems.containsKey(productId)) {
      return;
    }
    if(_cartItems[productId].quantity>1){

      _cartItems.update(
        productId,
            (exitingCartItem) => CartItem(
          id: exitingCartItem.id,
          title: exitingCartItem.title,
          price: exitingCartItem.price,
          quantity: exitingCartItem.quantity -1,
        ),
      );
    }else{
      _cartItems.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems = {};
    notifyListeners();
  }
}
