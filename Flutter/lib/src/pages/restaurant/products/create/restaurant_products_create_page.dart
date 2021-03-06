import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ardear_bakery/src/models/category.dart';
import 'package:ardear_bakery/src/pages/restaurant/products/create/restaurant_products_create_controller.dart';
import 'package:ardear_bakery/src/utils/my_colors.dart';

class RestaurantProductsCreatePage extends StatefulWidget {
  const RestaurantProductsCreatePage({Key key}) : super(key: key);

  @override
  _RestaurantProductsCreatePageState createState() =>
      _RestaurantProductsCreatePageState();
}

class _RestaurantProductsCreatePageState
    extends State<RestaurantProductsCreatePage> {
  RestaurantProductsCreateController _con =
      new RestaurantProductsCreateController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'สินค้าใหม่',
          style: TextStyle(color: Colors.brown),
        ),
        iconTheme: IconThemeData(
          color: MyColors.textColor, //change your color here
        ),
        backgroundColor: MyColors.primaryColor,
      ),
      body: ListView(
        children: [
          SizedBox(height: 30),
          _textFieldName(),
          _textFieldDescription(),
          _textFieldPrice(),
          _dropDownCategories(_con.categories),
          Container(
            height: 200,
            margin: EdgeInsets.only(right: 30, left: 30, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _cardImage(_con.imageFile1, 1),
                // _cardImage(_con.imageFile2, 2),
                // _cardImage(_con.imageFile3, 3),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buttonCreate(),
    );
  }

  Widget _textFieldName() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.nameController,
        maxLines: 1,
        maxLength: 180,
        decoration: InputDecoration(
            hintText: 'ชื่อสินค้า',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColors.textColor),
            suffixIcon: Icon(
              Icons.local_pizza,
              color: MyColors.textColor,
            )),
      ),
    );
  }

  Widget _textFieldPrice() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.priceController,
        keyboardType: TextInputType.phone,
        maxLines: 1,
        decoration: InputDecoration(
            hintText: 'ราคา',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColors.textColor),
            suffixIcon: Icon(
              Icons.monetization_on,
              color: MyColors.textColor,
            )),
      ),
    );
  }

  Widget _dropDownCategories(List<Category> categories) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 33, vertical: 5),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.search,
                    color: MyColors.textColor,
                  ),
                  SizedBox(width: 15),
                  Text(
                    'เลือกหมวดสินค้า',
                    style: TextStyle(color: MyColors.textColor, fontSize: 16),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButton(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_drop_down_circle,
                      color: MyColors.textColor,
                    ),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text(
                    'เลือกหมวดสินค้า',
                    style: TextStyle(color: MyColors.textColor, fontSize: 15),
                  ),
                  items: _dropDownItems(categories),
                  value: _con.idCategory,
                  onChanged: (option) {
                    setState(() {
                      _con.idCategory = option;
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

  List<DropdownMenuItem<String>> _dropDownItems(List<Category> categories) {
    List<DropdownMenuItem<String>> list = [];
    categories.forEach((category) {
      list.add(DropdownMenuItem(
        child: Text(' ' + category.name + ' '),
        value: category.id,
      ));
    });

    return list;
  }

  Widget _textFieldDescription() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.descriptionController,
        maxLines: 3,
        maxLength: 255,
        decoration: InputDecoration(
          hintText: 'คำอธิบายสินค้า',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          hintStyle: TextStyle(color: MyColors.textColor),
          suffixIcon: Icon(
            Icons.description,
            color: MyColors.textColor,
          ),
        ),
      ),
    );
  }

  Widget _cardImage(File imageFile, int numberFile) {
    return GestureDetector(
      onTap: () {
        _con.showAlertDialog(numberFile);
      },
      child: imageFile != null
          ? Card(
              elevation: 3.0,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Image.file(
                  imageFile,
                  fit: BoxFit.contain,
                ),
              ),
            )
          : Card(
              elevation: 3.0,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Image(
                  image: AssetImage('assets/img/add_image.png'),
                ),
              ),
            ),
    );
  }

  Widget _buttonCreate() {
    return Container(
      height: 60,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: ElevatedButton(
        onPressed: _con.createProduct,
        child: Text(
          'เพิ่มสินค้า',
          style: TextStyle(color: Colors.brown, fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
