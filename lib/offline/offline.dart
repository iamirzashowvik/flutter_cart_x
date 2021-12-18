import 'dart:convert';

import 'package:flutter_cart/flutter_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineCart {
  var cart = FlutterCart();
  var carString = [];
  makeOffline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    carString = [];
    for (var i = 0; i < cart.cartItem.length; i++) {
      var obj = {
        "productId": cart.cartItem[i].productId,
        "unitPrice": cart.cartItem[i].unitPrice,
        "quantity": cart.cartItem[i].quantity,
        "productName": cart.cartItem[i].productName,
        "uniqueCheck": cart.cartItem[i].uniqueCheck,
        "productDetailsObject": cart.cartItem[i].productDetails
      };
      carString.add(obj);
    }
    await prefs.setString('offlineCart', jsonEncode(carString).toString());
  }

  addProducts(String productID, int priceof1, int quantity, String productName,
      dynamic uniqueCheck, dynamic productDetails) async {
    cart.addToCart(
        productId: productID,
        unitPrice: priceof1,
        quantity: quantity,
        productName: productName,
        uniqueCheck: uniqueCheck,
        productDetailsObject: productDetails);
  }

  getFromOffline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String offlineCartString = prefs.getString('offlineCart') ?? '';
    if (offlineCartString.isNotEmpty) {
      var data = jsonDecode(offlineCartString);
      for (var i = 0; i < data.length; i++) {
        addProducts(
            data[i]['productId'],
            data[i]['unitPrice'],
            data[i]['quantity'],
            data[i]['productName'],
            data[i]['uniqueCheck'],
            data[i]['productDetailsObject']);
      }
    }
  }

  deleteHoleCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('offlineCart', '');
  }
}
