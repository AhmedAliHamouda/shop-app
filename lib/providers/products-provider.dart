import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/http-exception.dart';
import '../providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._productsItems);
  List<Product> _productsItems = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  List<Product> favoritesProducts = [];

  List<Product> get items {
    return [..._productsItems];
  }

  List<Product> get favoriteItems {
    //notifyListeners();
    favoritesProducts =
        _productsItems.where((prodItem) => prodItem.isFavorite).toList();
    return favoritesProducts;
  }

  Product findById(String id) {
    return _productsItems.firstWhere((product) => product.id == id);
  }

  void removeById(String id) {
    notifyListeners();
    return favoritesProducts.removeWhere((prod) => prod.id == id);
  }

  Future<void> fetchData([ bool filterByUser=false]) async {
    final filterShownProducts= filterByUser ? 'orderBy="creatorId"&equalTo="$userId"': '';
    final urlProducts =
        'https://shopapp-af8c9-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterShownProducts';
    final urlFavorites =
        'https://shopapp-af8c9-default-rtdb.firebaseio.com/userFavoites/$userId.json?auth=$authToken';
    try {
      final responseData = await http.get(urlProducts);
      final extractedData =
          json.decode(responseData.body) as Map<String, dynamic>;
      final favoritesResponse = await http.get(urlFavorites);
      final favoritesData = json.decode(favoritesResponse.body);
      final List<Product> loadedData = [];
      extractedData.forEach((productId, productData) {
        loadedData.insert(
            0,
            Product(
              id: productId,
              title: productData['title'],
              description: productData['description'],
              imageUrl: productData['imageUrl'],
              price: productData['price'],
              isFavorite: favoritesData == null
                  ? false
                  : favoritesData[productId] ?? false,
            ));
      });
      _productsItems = loadedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addNewProduct(Product product) async {
    final url =
        'https://shopapp-af8c9-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    final response = await http.post(
      url,
      body: json.encode({
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'creatorId': userId,
      }),
    );

    final String productId = json.decode(response.body)['name'];
    final newProduct = Product(
      id: productId,
      title: product.title,
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
    );
    //_productsItems.add(newProduct);
    _productsItems.insert(0, newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _productsItems.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final urlById =
          'https://shopapp-af8c9-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(urlById,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
          }));
      _productsItems[productIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final urlById =
        'https://shopapp-af8c9-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex =
        _productsItems.indexWhere((prod) => prod.id == id);
    var existingProduct = _productsItems[existingProductIndex];
    //_productsItems.removeWhere((prod) => prod.id == id);
    _productsItems.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(urlById);
    if (response.statusCode >= 400) {
      _productsItems.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException(' Can\'t Delete Item.');
    }
    existingProduct = null;
  }
}
