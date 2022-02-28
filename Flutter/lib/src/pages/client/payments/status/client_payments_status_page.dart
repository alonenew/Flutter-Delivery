import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:ardear_bakery/src/pages/client/payments/status/client_payments_status_controller.dart';
import 'package:ardear_bakery/src/utils/my_colors.dart';
import 'package:lottie/lottie.dart';

class ClientPaymentsStatusPage extends StatefulWidget {
  const ClientPaymentsStatusPage({Key key}) : super(key: key);

  @override
  _ClientPaymentsStatusPageState createState() =>
      _ClientPaymentsStatusPageState();
}

class _ClientPaymentsStatusPageState extends State<ClientPaymentsStatusPage> {
  ClientPaymentsStatusController _con = new ClientPaymentsStatusController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _clipPathOval(),
          _lottieAnimation(),
          _textCardStatus(),
          
        ],
      ),
      bottomNavigationBar: Container(
        height: 100,
        child: _buttonNext(),
      ),
    );
  }

  Widget _lottieAnimation() {
    return Container(
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.05, left: 50, top: 50),
      child: Lottie.asset('assets/json/cooking.json', height: 300),
    );
  }

  Widget _textCardStatus() {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Text(
          'ตรวจสอบสถานะสั่งซื้อ',
          style: TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        ));
  }

  Widget _clipPathOval() {
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        margin: EdgeInsets.only(top: 30),
        height: 250,
        width: double.infinity,
        color: MyColors.primaryColor,
        child: SafeArea(
          child: Column(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 120,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'ได้รับคำสั่งซื้อแล้ว',
                style: TextStyle(
                    color: MyColors.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 36),
              )
            ],
          ),
        ),
      ),
    );
  }

  

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: _con.finishShopping,
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  'ออกจากหน้านี้',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: MyColors.textColor),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50, top: 2),
                height: 30,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: MyColors.textColor,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
