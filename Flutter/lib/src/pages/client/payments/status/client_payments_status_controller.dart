import 'package:ardear_bakery/src/models/product.dart';
import 'package:flutter/material.dart';
import 'package:ardear_bakery/src/models/user.dart';
import 'package:ardear_bakery/src/provider/push_notifications_provider.dart';
import 'package:ardear_bakery/src/provider/users_provider.dart';
import 'package:ardear_bakery/src/utils/shared_pref.dart';

class ClientPaymentsStatusController {
  BuildContext context;
  Function refresh;
  String errorMessage;
  List<Product> selectedProducts = [];
  PushNotificationsProvider pushNotificationsProvider =
      new PushNotificationsProvider();

  User user;
  SharedPref _sharedPref = new SharedPref();
  UsersProvider usersProvider = new UsersProvider();
  List<String> tokens = [];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    Map<String, dynamic> arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    user = User.fromJson(await _sharedPref.read('user'));
    usersProvider.init(context, sessionUser: user);

    tokens = await usersProvider.getAdminsNotificationTokens();
    sendNotification();
    resetValues();
    refresh();
  }

  void resetValues() {
    selectedProducts.clear();
    refresh();
  }

  void sendNotification() {
    List<String> registration_id = [];
    tokens.forEach((t) {
      if (t != null) {
        registration_id.add(t);
      }
    });

    Map<String, dynamic> data = {'click_action': 'FLUTTER_NOTIFICATION_CLICK'};

    pushNotificationsProvider.sendMessageMultiple(
        registration_id, data, 'คำสั่งซื้อสำเร็จ', 'ลูกค้าได้ทำการสั่งซื้อ');
  }

  void finishShopping() {
    selectedProducts = [];
    selectedProducts.clear();
    selectedProducts = [];
    Navigator.pushNamedAndRemoveUntil(
        context, 'client/products/list', (route) => false);
  }
}
