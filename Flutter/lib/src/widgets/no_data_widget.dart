import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  String text;

  NoDataWidget({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/img/no_items.png'),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 50), child: Text(text))
        ],
      ),
    );
  }
}


class NoAddressWidget extends StatelessWidget {
  String text;

  NoAddressWidget({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 60, left: 120),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/img/no_items.png'),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 50), child: Text(text))
        ],
      ),
    );
  }
}