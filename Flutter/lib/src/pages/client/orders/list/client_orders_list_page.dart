import 'package:ardear_bakery/src/utils/relative_time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ardear_bakery/src/models/order.dart';
import 'package:ardear_bakery/src/pages/client/orders/list/client_orders_list_controller.dart';
import 'package:ardear_bakery/src/utils/my_colors.dart';
import 'package:ardear_bakery/src/widgets/no_data_widget.dart';

class ClientOrdersListPage extends StatefulWidget {
  const ClientOrdersListPage({Key key}) : super(key: key);

  @override
  _ClientOrdersListPageState createState() => _ClientOrdersListPageState();
}

class _ClientOrdersListPageState extends State<ClientOrdersListPage>
    with AutomaticKeepAliveClientMixin<ClientOrdersListPage> {
  ClientOrdersListController _con = new ClientOrdersListController();

  @override
  void initState() {
    super.initState();
    refresh();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _con.status?.length,
      child: Scaffold(
        key: _con.key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            title: Text(
              'ประวัติคำสั่งซื้อ',
              style: TextStyle(color: MyColors.textColor),
            ),
            iconTheme: IconThemeData(
              color: MyColors.textColor,
            ),
            backgroundColor: MyColors.primaryColor,
            bottom: TabBar(
              indicatorColor: Colors.black,
              indicatorWeight: 3,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              tabs: List<Widget>.generate(_con.status.length, (index) {
                return Tab(
                  child: Text(_con.status[index] ?? ''),
                );
              }),
            ),
          ),
        ),
        body: TabBarView(
          children: _con.status.map((String status) {
            return FutureBuilder(
                future: _con.getOrders(status),
                builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      return RefreshIndicator(
                        child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_, index) {
                              return _cardOrder(snapshot.data[index]);
                            }),
                        onRefresh: _getData,
                      );
                    } else {
                      return NoDataWidget(text: 'ไม่มีประวัติ');
                    }
                  } else {
                    return NoDataWidget(text: 'ไม่มีประวัติ');
                  }
                });
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: refresh,
          tooltip: 'refresh',
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;

  Future<void> _getData() async {
    setState(() {
      _cardOrder;
    });
  }

  Widget _cardOrder(Order order) {
    return GestureDetector(
      onTap: () {
        _con.openBottomSheet(order);
      },
      child: Container(
        height: 155,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Card(
          elevation: 3.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Positioned(
                  child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Order #${order.id}',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: 'NimbusSans'),
                  ),
                ),
              )),
              Container(
                margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      child: Text(
                          'เวลาที่สั่งซื้อ : ${RelativeTimeUtil.getRelativeTime(order.timestamp ?? 0)}'),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'ผู้ส่ง : ${order.delivery?.name ?? 'รอยืนยันออเดอร์'} ${order.delivery?.lastname ?? ''}',
                        style: TextStyle(fontSize: 13),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'ปลายทาง : ${order.address?.address ?? ''}',
                        style: TextStyle(fontSize: 13),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {}); // CTRL + S
  }
}
