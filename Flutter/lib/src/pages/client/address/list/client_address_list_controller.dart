import 'package:ardear_bakery/src/models/order.dart';
import 'package:ardear_bakery/src/models/product.dart';
import 'package:ardear_bakery/src/models/response_api.dart';
import 'package:flutter/material.dart';
import 'package:ardear_bakery/src/models/address.dart';
import 'package:ardear_bakery/src/models/user.dart';
import 'package:ardear_bakery/src/provider/address_provider.dart';
import 'package:ardear_bakery/src/provider/orders_provider.dart';
import 'package:ardear_bakery/src/utils/shared_pref.dart';

class ClientAddressListController {
  BuildContext context;
  Function refresh;

  List<Address> address = [];
  AddressProvider _addressProvider = new AddressProvider();
  User user;
  SharedPref _sharedPref = new SharedPref();

  int radioValue = 0;

  bool isCreated;

  Map<String, dynamic> dataIsCreated;

  OrdersProvider _ordersProvider = new OrdersProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _addressProvider.init(context, user);
    _ordersProvider.init(context, user);

    refresh();
  }

  void showAlertDialog() {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("ยกเลิก"),
      onPressed: back,
    );
    Widget continueButton = ElevatedButton(
      child: Text("ยืนยัน"),
      onPressed: createOrder,
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ยืนยันรายการสั่งซื้อ"),
      content: Text("คุณต้องการสั่งซื้อหรือไม่"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void back() {
    Navigator.pop(context);
  }

  void createOrder() async {
    Address a = Address.fromJson(await _sharedPref.read('address') ?? {});
    List<Product> selectedProducts =
        Product.fromJsonList(await _sharedPref.read('order')).toList;
    Order order = new Order(
        idClient: user.id, idAddress: a.id, products: selectedProducts);
    ResponseApi responseApi = await _ordersProvider.create(order);

    Navigator.pushNamed(context, 'client/payments/status');
  }

  void handleRadioValueChange(int value) async {
    radioValue = value;
    _sharedPref.save('address', address[value]);

    refresh();
  }

  Future<List<Address>> getAddress() async {
    address = await _addressProvider.getByUser(user.id);

    Address a = Address.fromJson(await _sharedPref.read('address') ?? {});
    int index = address.indexWhere((ad) => ad.id == a.id);

    if (index != -1) {
      radioValue = index;
    }

    return address;
  }

  void goToNewAddress() async {
    var result = await Navigator.pushNamed(context, 'client/address/create');

    if (result != null) {
      if (result) {
        refresh();
      }
    }
  }
}
