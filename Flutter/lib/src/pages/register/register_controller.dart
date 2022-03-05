import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ardear_bakery/src/models/response_api.dart';
import 'package:ardear_bakery/src/models/user.dart';
import 'package:ardear_bakery/src/provider/users_provider.dart';
import 'package:ardear_bakery/src/utils/my_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RegisterController {
  BuildContext context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController lastnameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPassswordController =
      new TextEditingController();

  UsersProvider usersProvider = new UsersProvider();

  PickedFile pickedFile;
  File imageFile;
  Function refresh;

  ProgressDialog _progressDialog;

  bool isEnable = true;

  // ignore: missing_return
  Future init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
    usersProvider.init(context);
    _progressDialog = ProgressDialog(context: context);
  }

  void register() async {
    String email = emailController.text.trim();
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPassswordController.text.trim();

    if (email.isEmpty ||
        name.isEmpty ||
        lastname.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      MySnackbar.show(context, 'กรุณากรอกข้อมูลให้ครบ');
      return;
    }

    if (confirmPassword != password) {
      MySnackbar.show(context, 'รหัสผ่านไม่ตรงกัน');
      return;
    }

    if (password.length < 6) {
      MySnackbar.show(context, 'รหัสผ่านไม่ต่ำกว่า 6 ตัว');
      return;
    }

    if (imageFile == null) {
      MySnackbar.show(context, 'กรุณาใส่รูป');
      return;
    }

    _progressDialog.show(max: 100, msg: 'กำลังสร้างบัญชี...');
    isEnable = false;

    User user = new User(
        email: email,
        name: name,
        lastname: lastname,
        phone: phone,
        password: password);

    Stream stream = await usersProvider.createWithImage(user, imageFile);
    stream.listen((res) {
      _progressDialog.close();

      // ResponseApi responseApi = await usersProvider.create(user);
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      MySnackbar.show(context, responseApi.message);

      if (responseApi.success == false) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushReplacementNamed(context, 'login');
        });
      } else {
        Navigator.pushReplacementNamed(context, 'login');
        isEnable = true;
      }
    });
  }

  Future selectImage(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog() {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery);
        },
        child: Text('คลังภาพ'));

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera);
        },
        child: Text('กล้อง'));

    AlertDialog alertDialog = AlertDialog(
      title: Text('เลือกรูป'),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void back() {
    Navigator.pop(context);
  }
}
