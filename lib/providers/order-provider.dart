import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart-provider.dart';
import 'package:http/http.dart' as http;



class OrderItem {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.total,
    @required this.products,
    @required this.dateTime,
  });
}


class Orders with ChangeNotifier {
  List<OrderItem> _ordersItems = [];
  final String authToken;
  final String userId;

  Orders(this.authToken,this.userId,this._ordersItems);

  List<OrderItem> get orders {
    return [..._ordersItems];
  }

  Future<void> fetchDataOrders() async {
    final url = 'https://shopapp-af8c9-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrderItem> loadedData = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedData.insert(
        0,
        OrderItem(
          id: orderId,
          total: orderData['total'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CartItem(
              id: item['id'],
              title: item['title'],
              quantity: item['quantity'],
              price: item['price'],
            );
          }).toList(),
        ),
      );
    });
    _ordersItems=loadedData;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://shopapp-af8c9-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();

    final response = await http.post(
      url,
      body: json.encode({
        'total': total,
        'dateTime': timeStamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'price': cp.price,
                  'quantity': cp.quantity,
                })
            .toList(),
      }),
    );

    _ordersItems.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        total: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void clearOrdersUserLogout(){
    _ordersItems.clear();
    notifyListeners();
  }
}
