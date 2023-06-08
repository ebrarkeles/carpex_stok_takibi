import 'package:carpex_stok_takibi/main.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';
  String errorPasswordMessage = "";

  void _login() {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (username == 'admin' && password == '123456') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } else {
      setState(() {
        _errorMessage =
            'Hatalı kullanıcı adı veya şifre. Lütfen kontrol ediniz.';
      });
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
                        child: Text("Cihaz Gönderme Uygulaması",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold))),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    const Text("Kullanıcı Adınızı Giriniz",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        labelText: 'Kullanıcı Adı',
                      ),
                    ),
                    const SizedBox(height: 33),
                    const Text("Şifrenizi Giriniz",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 25),
                    PinCodeTextField(
                      appContext: context,
                      obscureText: true,
                      obscuringCharacter: "*",
                      controller: _passwordController,
                      blinkWhenObscuring: true,
                      length: 6,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "Şifre 3 basamaktan az olamaz";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        debugPrint(value);

                        setState(() {
                          hasError = false;
                        });
                      },
                      onCompleted: (value) {
                        // Şifre girişi tamamlandığında yapılacak işlemler burada gerçekleştirilebilir
                        // Örneğin, şifreyi doğrulama, API isteği, oturum açma işlemi vb.
                        if (value != '123456') {
                          setState(() {
                            hasError = true;
                            errorPasswordMessage = 'Hatalı şifre';
                          });
                        } else {
                          // Şifre doğru olduğunda yapılacak işlemler
                        }
                      },
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                      ),
                    ),
                    Visibility(
                      visible: hasError,
                      child: Text(
                        errorPasswordMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        hasError
                            ? "*Lütfen tüm hücreleri düzgün bir şekilde doldurun"
                            : "",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(350, 45)),
                        onPressed: () {
                          _login();
                        },
                        child: Text('Giriş Yap'),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: const Text("Clear"),
                        onPressed: () {
                          _passwordController.clear();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
