import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/komponen/komponenpage.dart';
import 'package:cmmsge/views/pages/komponen/komponenwithsearch.dart';
import 'package:cmmsge/views/pages/login/loginpage.dart';
import 'package:cmmsge/views/pages/masalah/masalahwithsearch.dart';
import 'package:cmmsge/views/pages/mesin/mesinpage.dart';
import 'package:cmmsge/views/pages/mesin/mesinwithsearch.dart';
import 'package:cmmsge/views/pages/site/sitepage.dart';
import 'package:cmmsge/views/pages/site/sitewithinsearch.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "";

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
      username = sp.getString("username");
      jabatan = sp.getString("jabatan");
    });
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    cekToken();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.only(top: 45),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: CircleAvatar(
                  backgroundColor: primarycolor,
                  child: Image.asset('assets/images/icongajah.png'),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(username!.toUpperCase()), Text(jabatan!)]),
            ],
          ),
          _menu(),
          _transaksi(),
          _option()
        ],
      ),
    ));
  }

  Widget _menu() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: Text(
                'MASTER',
                style: TextStyle(fontSize: 18),
              )),
          Divider(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(
                left: 1 - .0, right: 1 - .0, top: 5.0, bottom: 5.0),
            alignment: Alignment.center,
            width: double.infinity,
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => KomponenPageSearch()));
              },
              title: (Text(
                'Komponen',
                style: TextStyle(fontSize: 18),
              )),
              leading: Icon(
                Icons.account_tree_rounded,
                color: Colors.black,
                size: 22,
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
          ),
          Divider(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(
                left: 1 - .0, right: 1 - .0, top: 5.0, bottom: 5.0),
            alignment: Alignment.center,
            width: double.infinity,
            child: ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MesinSearchPage()));
              },
              title: (Text(
                'Mesin',
                style: TextStyle(fontSize: 18),
              )),
              leading: Icon(
                Icons.precision_manufacturing_outlined,
                color: Colors.black,
                size: 22,
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
          ),
          Divider(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(
                left: 1 - .0, right: 1 - .0, top: 5.0, bottom: 5.0),
            alignment: Alignment.center,
            width: double.infinity,
            child: ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SiteSearchPage()));
              },
              title: (Text(
                'Site',
                style: TextStyle(fontSize: 18),
              )),
              leading: Icon(
                Icons.cabin_rounded,
                color: Colors.black,
                size: 22,
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
          ),
        ],
      ),
    );
  }

  Widget _transaksi() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: Text(
                'TRANSAKSI',
                style: TextStyle(fontSize: 18),
              )),
          Divider(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(
                left: 1 - .0, right: 1 - .0, top: 5.0, bottom: 5.0),
            alignment: Alignment.center,
            width: double.infinity,
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MasalahPageSearch()));
              },
              title: (Text(
                'Masalah',
                style: TextStyle(fontSize: 18),
              )),
              leading: Icon(
                Icons.warning_amber_rounded,
                color: Colors.black,
                size: 22,
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
          ),
        ],
      ),
    );
  }

  Widget _option() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
                left: 1 - .0, right: 1 - .0, top: 5.0, bottom: 5.0),
            alignment: Alignment.center,
            width: double.infinity,
            child: ListTile(
              onTap: () {
                _modalKonfirmasi();
              },
              title: (Text(
                'Keluar',
                style: TextStyle(fontSize: 18),
              )),
              leading: Icon(
                Icons.exit_to_app_rounded,
                color: Colors.black,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

// ++ BOTTOM MODAL CONFIRMATION
  void _modalKonfirmasi() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Keluar',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Apakah anda mau keluar aplikasi CMMS?',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            primary: Colors.red,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18)),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Tidak",
                              ),
                            ),
                          )),
                      SizedBox(
                        width: 55,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            exit();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            primary: Colors.white,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18)),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Ya",
                                style: TextStyle(color: primarycolor),
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void exit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
