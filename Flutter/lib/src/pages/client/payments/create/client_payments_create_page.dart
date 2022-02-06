import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:ardear_bakery/src/models/mercado_pago_document_type.dart';
import 'package:ardear_bakery/src/models/user.dart';
import 'package:ardear_bakery/src/pages/client/payments/create/client_payments_create_controller.dart';
import 'package:ardear_bakery/src/utils/my_colors.dart';

class ClientPaymentsCreatePage extends StatefulWidget {
  const ClientPaymentsCreatePage({Key key}) : super(key: key);

  @override
  _ClientPaymentsCreatePageState createState() => _ClientPaymentsCreatePageState();
}

class _ClientPaymentsCreatePageState extends State<ClientPaymentsCreatePage> {

  ClientPaymentsCreateController _con = new ClientPaymentsCreateController();

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
      appBar: AppBar(
        title: Text('การชำระเงิน'),
      ),
      body: ListView(
        children: [
          CreditCardWidget(
            cardNumber: _con.cardNumber,
            expiryDate: _con.expireDate,
            cardHolderName: _con.cardHolderName,
            cvvCode: _con.cvvCode,
            showBackView: _con.isCvvFocused,
            cardBgColor: MyColors.primaryColor,
            obscureCardNumber: true,
            obscureCardCvv: true,
            animationDuration: Duration(milliseconds: 1000),
            labelCardHolder: 'ชื่อและนามสกุล',
          ),
          CreditCardForm(
            cvvCode: '',
            expiryDate: '',
            cardHolderName: '',
            cardNumber: '',
            formKey: _con.keyForm, // Required
            onCreditCardModelChange: _con.onCreditCardModelChanged, // Required
            themeColor: Colors.red,
            obscureCvv: true,
            obscureNumber: true,
            cardNumberDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Card number',
              hintText: 'XXXX XXXX XXXX XXXX',
            ),
            expiryDateDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Expiration date',
              hintText: 'XX/XX',
            ),
            cvvCodeDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'CVV',
              hintText: 'XXX',
            ),
            cardHolderDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
          ),
          _documentInfo(),
          _buttonNext()
        ],
      ),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: _con.createCardToken,
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            )
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  'ดำเนินการต่อ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50, top: 9),
                height: 30,
                child: Icon(
                  Icons.arrow_forward_ios,
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

  Widget _documentInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Material(
              elevation: 2.0,
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7),
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
                          'เอกสาร',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14
                          ),
                        ),
                        items: _dropDownItems(_con.documentTypeList),
                        value: _con.typeDocument,
                        onChanged: (option) {
                          setState(() {
                            print('ตัวแทนจำหน่าย $option');
                            _con.typeDocument = option; 
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 15),
          Flexible(
            flex: 4,
            child: TextField(
              controller: _con.documentNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'หมายเลขเอกสาร'
              ),
            ),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<MercadoPagoDocumentType> documentType) {
    List<DropdownMenuItem<String>> list = [];
    documentType.forEach((document) {
      list.add(DropdownMenuItem(
        child: Container(
          margin: EdgeInsets.only(top: 7),
          child: Text(document.name),
        ),
        value: document.id,
      ));
    });

    return list;
  }

  void refresh() {
    setState(() {});
  }
}
