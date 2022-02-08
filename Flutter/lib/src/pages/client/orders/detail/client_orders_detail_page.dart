import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ardear_bakery/src/models/order.dart';
import 'package:ardear_bakery/src/models/product.dart';
import 'package:ardear_bakery/src/pages/client/orders/detail/client_orders_detail_controller.dart';
import 'package:ardear_bakery/src/utils/relative_time_util.dart';
import 'package:ardear_bakery/src/widgets/no_data_widget.dart';

class ClientOrdersDetailPage extends StatefulWidget {
  Order order;

  ClientOrdersDetailPage({Key key, @required this.order}) : super(key: key);

  @override
  _ClientOrdersDetailPageState createState() => _ClientOrdersDetailPageState();
}

class _ClientOrdersDetailPageState extends State<ClientOrdersDetailPage> {
  ClientOrdersDetailController _con = new ClientOrdersDetailController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orden #${_con.order?.id ?? ''}'),
        actions: [
          Container(
            margin: EdgeInsets.only(top: 18, right: 15),
            child: Text(
              'รวม : ${_con.total} บาท',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                color: Colors.grey[400],
                endIndent: 30, // DERECHA
                indent: 30, //IZQUIERDA
              ),
              SizedBox(height: 10),
              _textData('ผู้ส่ง :',
                  '${_con.order?.delivery?.name ?? 'ไม่ได้รับมอบหมาย'} ${_con.order?.delivery?.lastname ?? ''}'),
              _textData('ส่งมอบ :', '${_con.order?.address?.address ?? ''}'),
              _textData('วันที่สั่ง :',
                  '${RelativeTimeUtil.getRelativeTime(_con.order.timestamp ?? 0)}'),
              _con.order?.status == 'ผู้ส่งกำลังเดินทาง'
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
              text: 'ไม่มีสินค้า',
            ),
    );
  }

  Widget _textData(String title, String content) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          content,
          maxLines: 2,
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
            primary: Colors.blue,
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
                  'ติดตามการจัดส่ง',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50, top: 4),
                height: 30,
                child: Icon(
                  Icons.directions_car,
                  color: Colors.white,
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
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'จำนวน : ${product.quantity}',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageProduct(Product product) {
    return Container(
      width: 50,
      height: 50,
      padding: EdgeInsets.all(5),
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
