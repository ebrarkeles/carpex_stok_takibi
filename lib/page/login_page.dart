// ignore_for_file: use_build_context_synchronously, unused_import

import 'dart:convert';

import 'package:carpex_stok_takibi/constants/constants.dart';
import 'package:carpex_stok_takibi/main.dart';
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
  final String _errorMessage = '';
  String errorPasswordMessage = "";
  String deneme = '';
  RxBool isVisible = true.obs;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      print("AAAAAAAAAAA ${usernameController.text.toString()}");
      print("BBBBBBBBBBB ${passwordController.text.toString()}");
      http.Response response = await http
          .post(Uri.parse("http://95.70.201.96:39050/api/login/"), body: {
        'username': usernameController.text.toString(),
        'password': passwordController.text.toString()
      });
      print("1111 ${response.body}");

      if (response.statusCode == 200) {
        print("222 ${response.body}");
        prefs.setString("username", usernameController.text.toString());
        prefs.setString("password", passwordController.text.toString());
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
        await Future.delayed(Duration(seconds: 1));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const MyHomePage()),
            (Route<dynamic> route) => false);
      } else {
        print('başarısız');
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
            duration: Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasError = false;

    return SafeArea(
      child: Scaffold(
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
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: 'Kullanıcı Adı',
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text("Şifrenizi Giriniz",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 15),
                  Obx(
                    () => TextFormField(
                      controller: passwordController,
                      obscuringCharacter: isVisible.value == true ? "*" : ' ',
                      obscureText: isVisible.value == true ? true : false,
                      decoration: InputDecoration(
                        suffixIcon: isVisible.value == true
                            ? GestureDetector(
                                onTap: () {
                                  isVisible.value = false;
                                },
                                child: Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                ))
                            : GestureDetector(
                                onTap: () {
                                  isVisible.value = true;
                                },
                                child: Icon(Icons.visibility)),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        labelText: 'Şifre',
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
                  //   controller: passwordController,
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
                  const SizedBox(height: 25),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  //   child: Text(
                  //     hasError
                  //         ? "*Lütfen tüm hücreleri düzgün bir şekilde doldurun"
                  //         : "",
                  //     style: const TextStyle(
                  //       color: Colors.red,
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.w400,
                  //     ),
                  //   ),
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.themeColor),
                          onPressed: () {
                            login();
                          },
                          child: const Text('Giriş Yap'),
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 10),
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          child: const Text(
                            "Temizle",
                            style: TextStyle(
                                color: Color.fromRGBO(43, 114, 176, 1)),
                          ),
                          onPressed: () {
                            passwordController.clear();
                            usernameController.clear();
                          },
                        ),
                      ),
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
