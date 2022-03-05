import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ardear_bakery/src/models/order.dart';
import 'package:ardear_bakery/src/models/product.dart';
import 'package:ardear_bakery/src/models/user.dart';
import 'package:ardear_bakery/src/pages/restaurant/orders/detail/restaurant_orders_detail_controller.dart';
import 'package:ardear_bakery/src/utils/my_colors.dart';
import 'package:ardear_bakery/src/utils/relative_time_util.dart';
import 'package:ardear_bakery/src/widgets/no_data_widget.dart';

class RestaurantOrdersDetailPage extends StatefulWidget {
  Order order;

  RestaurantOrdersDetailPage({Key key, @required this.order}) : super(key: key);

  @override
  _RestaurantOrdersDetailPageState createState() =>
      _RestaurantOrdersDetailPageState();
}

class _RestaurantOrdersDetailPageState
    extends State<RestaurantOrdersDetailPage> {
  RestaurantOrdersDetailController _con =
      new RestaurantOrdersDetailController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        iconTheme: IconThemeData(
          color: MyColors.textColor, //change your color here
        ),
        title: Text('Order #${_con.order?.id ?? ''}',
            style: TextStyle(color: MyColors.textColor)),
        actions: [
          Container(
            margin: EdgeInsets.only(top: 18, right: 15),
            child: Text(
              'รวม: ${_con.total} บาท',
              style: TextStyle(
                  color: MyColors.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Divider(
                color: Colors.black,
                endIndent: 30,
                indent: 30,
              ),
              SizedBox(height: 10),
              _textDescription(),
              SizedBox(height: 10),
              _con.order.status != 'กำลังดำเนินการ'
                  ? _deliveryData()
                  : Container(),
              _con.order.status == 'กำลังดำเนินการ'
                  ? _dropDown(_con.users)
                  : Container(),
              _textData('ชื่อลูกค้า:',
                  '${_con.order.client?.name ?? ''} ${_con.order.client?.lastname ?? ''}'),
              _textData(
                  'ที่อยู่ลูกค้า : ', '${_con.order.address?.address ?? ''}'),
              _textData('เวลาที่สั่งซื้อ : ',
                  '${RelativeTimeUtil.getRelativeTime(_con.order.timestamp ?? 0)}'),
              _con.order.status == 'กำลังดำเนินการ'
                  ? _buttonNext()
                  : Container()
            ],
          ),
        ),
      ),
      body: _con.order.products.length > 0
          ? ListView(
              children: _con.order.products.map((Product product) {
                return _cardProduct(product);
              }).toList(),
            )
          : NoDataWidget(
              text: 'ไม่มีสินค้าเพิ่ม',
            ),
    );
  }

  Widget _textDescription() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        _con.order == 'รายการสั่งซื้อ' ? 'มอบหมายคนส่งของ' : 'เลือกพนักงานส่ง',
        style: TextStyle(
            fontStyle: FontStyle.italic,
            color: MyColors.textColor,
            fontSize: 16),
      ),
    );
  }

  Widget _dropDown(List<User> users) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: EdgeInsets.all(0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButton(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_drop_down_circle,
                      color: MyColors.primaryColor,
                    ),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text(
                    'เลือกพนักงานส่ง',
                    style: TextStyle(color: MyColors.textColor, fontSize: 16),
                  ),
                  items: _dropDownItems(users),
                  value: _con.idDelivery,
                  onChanged: (option) {
                    setState(() {
                      _con.idDelivery = option;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _deliveryData() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Container(
            height: 70,
            width: 70,
            child: FadeInImage(
              image: _con.order.delivery?.image != null
                  ? NetworkImage(_con.order.delivery.image)
                  : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
          ),
          SizedBox(width: 5),
          Text(
            '${_con.order.delivery?.name ?? ''} ${_con.order.delivery?.lastname ?? ''}',
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<User> users) {
    List<DropdownMenuItem<String>> list = [];
    users.forEach((user) {
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              child: FadeInImage(
                image: user.image != null
                    ? NetworkImage(user.image)
                    : AssetImage('assets/img/no-image.png'),
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/img/no-image.png'),
              ),
            ),
            SizedBox(width: 5),
            Text(user.name)
          ],
        ),
        value: user.id,
      ));
    });

    return list;
  }

  Widget _textData(String title, String content) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Text(
          content,
          maxLines: 2,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 20),
      child: ElevatedButton(
        onPressed: _con.updateOrder,
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
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  'จัดส่งคำสั่งซื้อ',
                  style: TextStyle(
                      color: MyColors.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50, top: 4),
                height: 30,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardProduct(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _imageProduct(product),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product?.name ?? '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'จำนวนสินค้า : ${product.quantity}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageProduct(Product product) {
    return Container(
      width: 100,
      height: 100,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.grey[200]),
      child: FadeInImage(
        image: product.image1 != null
            ? NetworkImage(product.image1)
            : AssetImage('assets/img/no-image.png'),
        fit: BoxFit.contain,
        fadeInDuration: Duration(milliseconds: 50),
        placeholder: AssetImage('assets/img/no-image.png'),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
