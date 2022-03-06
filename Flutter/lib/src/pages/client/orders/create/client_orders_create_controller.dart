import 'package:ardear_bakery/src/utils/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:ardear_bakery/src/models/product.dart';
import 'package:ardear_bakery/src/utils/shared_pref.dart';

class ClientOrdersCreateController {
  BuildContext context;
  Function refresh;
  SharedPref _sharedPref = new SharedPref();
  double productPrice;

  Product product;

  List<Product> selectedProducts = [];
  double total = 0;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    selectedProducts =
        Product.fromJsonList(await _sharedPref.read('order')).toList;

    getTotal();
    refresh();
  }

  void getTotal() {
    total = 0;
    selectedProducts.forEach((product) {
      total = total + (product.quantity * product.price);
    });
  }

  void addItem(Product product) {
    int index = selectedProducts.indexWhere((p) => p.id == product.id);
    selectedProducts[index].quantity = selectedProducts[index].quantity + 1;
    _sharedPref.save('order', selectedProducts);
    getTotal();
  }

  void removeItem(Product product) {
    if (product.quantity > 1) {
      int index = selectedProducts.indexWhere((p) => p.id == product.id);
      selectedProducts[index].quantity = selectedProducts[index].quantity - 1;
      _sharedPref.save('order', selectedProducts);
      getTotal();
    }
  }

  void deleteItem(Product product) {
    selectedProducts.removeWhere((p) => p.id == product.id);
    _sharedPref.save('order', selectedProducts);
    getTotal();
  }

  void clearItem(Product product) {
    selectedProducts.clear();
    _sharedPref.save('order', selectedProducts);
    getTotal();
  }

  void goToAddress() {
    if (selectedProducts.length < 1) {
      MySnackbar.show(context, 'กรุณาเลือกสินค้า');
      return;
    } else {
      Navigator.pushNamed(context, 'client/address/list');
    }
  }
}
