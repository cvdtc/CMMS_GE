import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/komponen/list.dart';
import 'package:cmmsge/views/pages/mesin/mesinpage.dart';
import 'package:cmmsge/views/pages/site/sitepage.dart';
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
                  child: Text(
                    'CMMS',
                    style: TextStyle(fontSize: 12),
                  ),
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
          _transaksi()
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => KomponenPage()));
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
                    MaterialPageRoute(builder: (context) => MesinPage()));
              },
              title: (Text(
                'Mesin',
                style: TextStyle(fontSize: 18),
              )),
              leading: Icon(
                Icons.alt_route_rounded,
                color: Colors.black,
                size: 22,
              ),
              trailing: Icon(Icons.precision_manufacturing_outlined),
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
                    MaterialPageRoute(builder: (context) => SitePage()));
              },
              title: (Text(
                'Site',
                style: TextStyle(fontSize: 18),
              )),
              leading: Icon(
                Icons.alt_route_rounded,
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
              onTap: () {},
              title: (Text(
                'Masalah',
                style: TextStyle(fontSize: 18),
              )),
              leading: Icon(
                Icons.settings_input_component_rounded,
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
}
