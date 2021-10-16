import 'package:cmmsge/services/models/login/LoginModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableCalass.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/utils/bottomnavigation.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ! Initialize Variable
  // * please all variable drop here!
  // * and make sure variable have value don't let variable null
  bool _isLoading = false,
      _passtype = true,
      _fieldUsername = true,
      _fieldPassword = true;
  TextEditingController _tecUsername = TextEditingController(text: "");
  TextEditingController _tecPassword = TextEditingController(text: "");
  ApiService _apiService = ApiService();

  // * method for show or hide password
  void _toggle() {
    setState(() {
      _passtype = !_passtype;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: backgroundcolor,
          padding: EdgeInsets.all(25.0),
          width: double.infinity,
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.passthrough,
            children: [
              Positioned.fill(
                  top: 20,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: (Text("PT. SINAR INDOGREEN KENCANA")),
                  )),
              Positioned(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 175,
                    height: 100,
                    child: Image.asset('assets/images/logoge.png'),
                  ),
                  Text(
                    "[ CMMS ]",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _TextEditingUsername(),
                  SizedBox(height: 10),
                  _TextEditingPassword(),
                  SizedBox(
                    height: 35,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        LoginClick();
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        primary: thirdcolor,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18)),
                        child: Container(
                          width: 325,
                          height: 45,
                          alignment: Alignment.center,
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      )),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  // * widget for text editing username
  Widget _TextEditingUsername() {
    return TextFormField(
        controller: _tecUsername,
        decoration: InputDecoration(
          focusColor: thirdcolor,
          icon: Icon(Icons.people_alt_outlined),
          labelText: 'Username',
          hintText: 'Masukkan Username',
          suffixIcon: Icon(Icons.check_circle),
        ));
  }

  // * widget for text editing password
  Widget _TextEditingPassword() {
    return TextFormField(
        controller: _tecPassword,
        obscureText: _passtype,
        decoration: InputDecoration(
          icon: Icon(Icons.password),
          labelText: 'Password',
          hintText: 'Masukkan Password',
          suffixIcon: IconButton(
            onPressed: _toggle,
            icon: new Icon(
                _passtype ? Icons.remove_red_eye : Icons.visibility_off),
          ),
        ));
  }

  // * class for login button action and response
  void LoginClick() {
    print('hii');
    var username = _tecUsername.text.toString();
    var password = _tecPassword.text.toString();
    if (username == "" || password == "") {
      ReusableClass().modalbottomWarning(
          context,
          "Tidak Valid",
          'pastikan username dan password sudah terisi!',
          'f400',
          'assets/iamges/sorry.png');
    } else {
      LoginModel dataparams =
          LoginModel(username: username, password: password, tipe: 'mobile');
      _apiService.LoginApp(dataparams).then((isSuccess) {
        setState(() {
          _isLoading = false;
        });
        if (isSuccess) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => BottomNavigation()));
        } else {
          ReusableClass().modalbottomWarning(
              context,
              'Login Gagal!',
              '${_apiService.responseCode.messageApi}',
              '400',
              'assets/images/sorry');
        }
        return;
      });
    }
    return;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
