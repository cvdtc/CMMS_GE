import 'package:cmmsge/services/models/login/LoginModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/utils/appversion.dart';
import 'package:cmmsge/views/utils/bottomnavigation.dart';
import 'package:cmmsge/views/utils/deviceinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

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
  String? uuid;

  cekuuid() async {
    // setState(() async {
    uuid = await GetDeviceID().getDeviceID(context);
    // });
  }

  @override
  initState() {
    super.initState();
    cekuuid();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _apiService.client.close();
    super.dispose();
  }

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
              // Positioned.fill(
              //     top: 20,
              //     child: Align(
              //       alignment: Alignment.topLeft,
              //       child: (Text("PT. SINAR INDOGREEN KENCANA")),
              //     )),
              Positioned(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 240,
                    height: 80,
                    child: Image.asset('assets/images/logoge.png'),
                  ),
                  Text(
                    "CMMS",
                    style: GoogleFonts.nunito(
                      textStyle: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff000912),
                        letterSpacing: 3,
                      ),
                    ),
                    // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  SizedBox(
                    height: 20,
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
                        elevation: 3.0,
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
                  SizedBox(
                    height: 22,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Device ID :  ' + uuid.toString().toUpperCase(),
                        style: TextStyle(color: primarycolor),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      SizedBox(
                        height: 25.0,
                        width: 75.0,
                        child: ElevatedButton(
                            onPressed: uuid == null
                                ? () {}
                                : () {
                                    Clipboard.setData(ClipboardData(text: uuid))
                                        .then((value) => Fluttertoast.showToast(
                                            msg: 'ID tersalin!',
                                            backgroundColor: Colors.green));
                                  },
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              primary: Colors.green,
                            ),
                            child: Ink(
                              child: Container(
                                width: 75,
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  uuid == null ? 'Wait' : "Salin",
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  Text('Versi : ' + appVersion.versionnumber.toString())
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
    var username = _tecUsername.text.toString();
    var password = _tecPassword.text.toString();
    if (username == "" || password == "") {
      ReusableClasses().modalbottomWarning(
          context,
          "Tidak Valid",
          'pastikan username dan password sudah terisi!',
          'f400',
          'assets/images/sorry.png');
    } else {
      LoginModel dataparams = LoginModel(
          username: username,
          password: password,
          device: 'mobile',
          uuid: uuid,
          appversion: appVersion.versionnumber);
      _apiService.LoginApp(dataparams).then((isSuccess) async {
        if (isSuccess) {
          setState(() {
            _isLoading = false;
          });
          return Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BottomNavigation(
                        numberOfPage: 0,
                      )));
        } else {
          ReusableClasses().modalbottomWarning(
              context,
              'GAGAL!',
              _apiService.responseCode.messageApi,
              'f400',
              'assets/images/sorry.png');
        }
      }).onError((error, stackTrace) {
        return ReusableClasses().modalbottomWarning(
            context,
            'Koneksi Bermasalah!',
            'Pastikan Koneksi anda stabil terlebih dahulu, apabila masih terkendala hubungi IT.' +
                error.toString() +
                stackTrace.toString(),
            'f500',
            'assets/images/sorry.png');
      });
    }
    return;
  }
}
