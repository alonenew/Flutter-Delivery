import 'package:flutter/material.dart';
import 'package:ardear_bakery/src/models/mercado_pago_payment.dart';
import 'package:ardear_bakery/src/models/user.dart';
import 'package:ardear_bakery/src/provider/push_notifications_provider.dart';
import 'package:ardear_bakery/src/provider/users_provider.dart';
import 'package:ardear_bakery/src/utils/shared_pref.dart';

class ClientPaymentsStatusController {
  BuildContext context;
  Function refresh;

  MercadoPagoPayment mercadoPagoPayment;

  String errorMessage;

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

    mercadoPagoPayment = MercadoPagoPayment.fromJsonMap(arguments);

    if (mercadoPagoPayment.status == 'rejected') {
      createErrorMessage();
    }

    user = User.fromJson(await _sharedPref.read('user'));
    usersProvider.init(context, sessionUser: user);

    tokens = await usersProvider.getAdminsNotificationTokens();
    sendNotification();
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
    Navigator.pushNamedAndRemoveUntil(
        context, 'client/products/list', (route) => false);
  }

  void createErrorMessage() {
    if (mercadoPagoPayment.statusDetail ==
        'cc_rejected_bad_filled_card_number') {
      errorMessage = 'ตรวจสอบหมายเลขบัตร';
    } else if (mercadoPagoPayment.statusDetail ==
        'cc_rejected_bad_filled_date') {
      errorMessage = 'ตรวจสอบวันหมดอายุ';
    } else if (mercadoPagoPayment.statusDetail ==
        'cc_rejected_bad_filled_other') {
      errorMessage = 'ตรวจสอบรายละเอียดบัตร';
    } else if (mercadoPagoPayment.statusDetail ==
        'cc_rejected_bad_filled_security_code') {
      errorMessage = 'ตรวจสอบรหัสความปลอดภัยของบัตร';
    } else if (mercadoPagoPayment.statusDetail == 'cc_rejected_blacklist') {
      errorMessage = 'ไม่สามารถชำระเงินของคุณได้';
    } else if (mercadoPagoPayment.statusDetail ==
        'cc_rejected_call_for_authorize') {
      errorMessage =
          'คุณต้องอนุญาต ${mercadoPagoPayment.paymentMethodId} ก่อนการชำระเงิน.';
    } else if (mercadoPagoPayment.statusDetail == 'cc_rejected_card_disabled') {
      errorMessage =
          'กรุณา ${mercadoPagoPayment.paymentMethodId} เปิดใช้งานบัตรของคุณหรือใช้วิธีการชำระเงินอื่น';
    } else if (mercadoPagoPayment.statusDetail == 'cc_rejected_card_error') {
      errorMessage = 'ไม่สามารถชำระเงินของคุณได้';
    } else if (mercadoPagoPayment.statusDetail == 'cc_rejected_card_error') {
      errorMessage = 'ไม่สามารถชำระเงินของคุณได้';
    } else if (mercadoPagoPayment.statusDetail ==
        'cc_rejected_duplicated_payment') {
      errorMessage = 'คุณได้ชำระเงินแล้ว';
    } else if (mercadoPagoPayment.statusDetail == 'cc_rejected_high_risk') {
      errorMessage = 'เลือกช่องทางการชำระอื่น เช่นเงินสด';
    } else if (mercadoPagoPayment.statusDetail ==
        'cc_rejected_insufficient_amount') {
      errorMessage = 'คุณ ${mercadoPagoPayment.paymentMethodId} มียอดเงินไม่พอ';
    } else if (mercadoPagoPayment.statusDetail ==
        'cc_rejected_invalid_installments') {
      errorMessage =
          '${mercadoPagoPayment.paymentMethodId} ไม่สามารถชำระเงิน ${mercadoPagoPayment.installments} ค่าธรรมเนียม.';
    } else if (mercadoPagoPayment.statusDetail == 'cc_rejected_max_attempts') {
      errorMessage = 'เกิดขีดจำกัดที่ทำรายการ';
    } else if (mercadoPagoPayment.statusDetail == 'cc_rejected_other_reason') {
      errorMessage = 'บัตรอื่นหรือวิธีการชำระเงินอื่น เช่นเงินสด';
    }
  }
}
