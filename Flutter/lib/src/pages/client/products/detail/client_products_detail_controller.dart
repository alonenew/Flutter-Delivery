import 'package:flutter/material.dart';
import 'package:ardear_bakery/src/models/product.dart';
import 'package:ardear_bakery/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClientProductsDetailController {

  BuildContext context;
  Function refresh;

  Product product;

  int counter = 1;
  double productPrice;

  SharedPref _sharedPref = new SharedPref();

  List<Product> selectedProducts = [];

  Future init(BuildContext context, Function refresh, Product product) async {
    this.context = context;
    this.refresh = refresh;
    this.product = product;
    productPrice = product.price;

    // _sharedPref.remove('order');
    selectedProducts = Product.fromJsonList(await _sharedPref.read('order')).toList;

    selectedProducts.forEach((p) {
    });

    refresh();
  }

  void addToBag() {
    int index = selectedProducts.indexWhere((p) => p.id == product.id);

    if (index == -1) { // PRODUCTOS SELECCIONADOS NO EXISTE ESE PRODUCTO
      if (product.quantity == null) {
        product.quantity = 1;
      }

      selectedProducts.add(product);
    }
    else {
      selectedProducts[index].quantity = counter;
    }

    _sharedPref.save('คำสั่งซื้อ', selectedProducts);
    Fluttertoast.showToast(msg: 'เพิ่มสินค้า');
  }

  void addItem() {
    counter = counter + 1;
    productPrice = product.price * counter;
    product.quantity = counter;
    refresh();
  }

  void removeItem() {
    if (counter > 1) {
      counter = counter - 1;
      productPrice = product.price * counter;
      product.quantity = counter;
      refresh();
    }
  }

  void close() {
    Navigator.pop(context);
  }

}