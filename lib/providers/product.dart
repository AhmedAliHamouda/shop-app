import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatue(String authToken,String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final urlById =
        'https://shopapp-af8c9-default-rtdb.firebaseio.com/userFavoites/$userId/$id.json?auth=$authToken';
    try {
      final response = await http.put(
        urlById,
        body: json.encode(
          isFavorite,
        ),
      );
      if(response.statusCode>=400){
        isFavorite=oldStatus;
      }
      notifyListeners();
    } catch (error) {
      isFavorite=oldStatus;
      notifyListeners();
    }
  }
}
