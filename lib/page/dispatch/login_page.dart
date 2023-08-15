// ignore_for_file: use_build_context_synchronously, unused_import, avoid_print

import 'dart:convert';

import 'package:carpex_stok_takibi/constants/constants.dart';
import 'package:carpex_stok_takibi/controller/mainController.dart';
import 'package:carpex_stok_takibi/main.dart';
import 'package:carpex_stok_takibi/page/action_choose_page/action_choose_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorPasswordMessage = "";
  String deneme = '';
  RxBool isVisible = true.obs;

  final controller = Get.put(MainController());

  SharedPreferences? prefs;

  late TextEditingController _textEditingController1;
  late TextEditingController _textEditingController2;

  @override
  void initState() {
    super.initState();
    _textEditingController1 = TextEditingController();
    _textEditingController2 = TextEditingController();
    _loadRememberMe();
  }

  void login() async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      print("AAAAAAAAAAA ${controller.usernameController.value.toString()}");
      print("BBBBBBBBBBB ${controller.passwordController.value.toString()}");
      http.Response response = await http
          .post(Uri.parse("http://95.70.201.96:39050/api/login/"), body: {
        'username': controller.usernameController.value.toString(),
        'password': controller.passwordController.value.toString()
      });
      print("1111 ${response.body}");

      if (response.statusCode == 200) {
        if (controller.rememberMe.value == true) {
          _saveLoginInfo();
        } else {
          _clearLoginInfo();
        }

        // prefs.setString("username", controller.usernameController.value.text.toString());
        // prefs.setString("password", controller.passwordController.value.text.toString());
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async => false,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            });
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const ActionChoosePage()),
            (Route<dynamic> route) => false);

        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => const MyHomePage()),
        //     (Route<dynamic> route) => false);

        print(response.statusCode);

        print("222 ${response.body}");
      } else {
        print(response.statusCode);

        print('başarısızzzzzzzzzzzzzzzzz');
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Kullanıcı adı veya şifre hatalı. Tekrar deneyiniz!',
              style: TextStyle(fontSize: 15),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 85,
            ),
            duration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      print(e.hashCode);
      print(e.toString());
    }
  }

  _saveRememberMe(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', value);
  }

  _loadRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    controller.rememberMe.value = prefs.getBool('rememberMe')!;
    if (controller.rememberMe.value == true) {
      controller.usernameController.value = prefs.getString('username')!;
      _textEditingController1.text = prefs.getString('username')!;
      controller.passwordController.value = prefs.getString('password')!;
      _textEditingController2.text = prefs.getString('password')!;
    } else {
      controller.usernameController.value = "";
      _textEditingController1.text = "";

      controller.passwordController.value = "";
      _textEditingController2.text = "";
    }
  }

  _saveLoginInfo() async {
    prefs = await SharedPreferences.getInstance();
    prefs!
        .setString('username', controller.usernameController.value.toString());
    prefs!
        .setString('password', controller.passwordController.value.toString());
  }

  _clearLoginInfo() async {
    prefs = await SharedPreferences.getInstance();
    prefs!.remove('username');
    prefs!.remove('password');
  }

  @override
  Widget build(BuildContext context) {
    bool hasError = false;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(30)),
              child: Column(
                children: [
                  Container(
                    height: 90,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          image:
                              AssetImage("assets/images/carpex_koku_logo.png"),
                          alignment: Alignment.center),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text("Cihaz Sevk",
                            style: TextStyle(
                                fontSize: 25,
                                color: Constants.themeColor,
                                fontWeight: FontWeight.bold))),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  const Text("Kullanıcı Adınızı Giriniz",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _textEditingController1,
                    autofillHints: const [AutofillHints.username],
                    onChanged: (value) {
                      controller.usernameController.value = value;
                    },
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Kullanıcı Adı',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      //labelText: 'Kullanıcı Adı',
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Text("Şifrenizi Giriniz",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 15),
                  Obx(
                    () => TextFormField(
                      controller: _textEditingController2,
                      obscuringCharacter: isVisible.value == true ? "*" : ' ',
                      obscureText: isVisible.value == true ? true : false,
                      decoration: InputDecoration(
                        hintText: 'Şifre',
                        suffixIcon: isVisible.value == true
                            ? GestureDetector(
                                onTap: () {
                                  isVisible.value = false;
                                },
                                child: const Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                ))
                            : GestureDetector(
                                onTap: () {
                                  isVisible.value = true;
                                },
                                child: const Icon(Icons.visibility)),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        //labelText: 'Şifre',
                      ),
                      validator: (v) {
                        if (v!.length < 3) {
                          return "Şifre 3 karakterden az olamaz";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        debugPrint(value);
                        controller.passwordController.value = value;
                        setState(() {
                          hasError = false;
                          deneme = value;
                        });
                      },
                    ),
                  ),
                  // PinCodeTextField(
                  //   appContext: context,
                  //   obscureText: true,
                  //   obscuringCharacter: "*",
                  //   controller: controller.passwordController.value,
                  //   blinkWhenObscuring: true,
                  //   length: 6,
                  //   validator: (v) {
                  //     if (v!.length < 3) {
                  //       return "Şifre 3 karakterden az olamaz";
                  //     } else {
                  //       return null;
                  //     }
                  //   },
                  //   onChanged: (value) {
                  //     debugPrint(value);

                  //     setState(() {
                  //       hasError = false;
                  //       deneme = value;
                  //     });
                  //   },
                  //   onCompleted: (value) {
                  //     // Şifre girişi tamamlandığında yapılacak işlemler burada gerçekleştirilebilir
                  //     // Örneğin, şifreyi doğrulama, API isteği, oturum açma işlemi vb.
                  //     if (value != 'admin') {
                  //       setState(() {
                  //         hasError = true;
                  //         errorPasswordMessage = 'Hatalı şifre';
                  //       });
                  //     } else {
                  //       // Şifre doğru olduğunda yapılacak işlemler
                  //     }
                  //   },
                  //   keyboardType: TextInputType.text,
                  //   pinTheme: PinTheme(
                  //     shape: PinCodeFieldShape.box,
                  //     borderRadius: BorderRadius.circular(5),
                  //     fieldHeight: 50,
                  //     fieldWidth: 40,
                  //     activeFillColor: Colors.white,
                  //   ),
                  // ),
                  Visibility(
                    visible: hasError,
                    child: Text(
                      errorPasswordMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Obx(() => Checkbox(
                                value: controller.rememberMe.value,
                                onChanged: (value) {
                                  controller.rememberMe.value = value!;
                                  _saveRememberMe(value);
                                },
                              )),
                          const Text('Beni Hatırla'),
                        ],
                      ),
                      TextButton(
                        child: const Text(
                          "Temizle",
                          style:
                              TextStyle(color: Color.fromRGBO(43, 114, 176, 1)),
                        ),
                        onPressed: () {
                          controller.passwordController.value = "";
                          controller.usernameController.value = "";
                        },
                      ),
                    ],
                  ),
                  //  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                //await controller.delay(1000);
                                login();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Constants.themeColor,
                              ),
                              child: const Text("Giriş Yap")),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
