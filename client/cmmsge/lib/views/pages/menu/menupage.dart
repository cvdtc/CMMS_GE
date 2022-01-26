import 'package:cmmsge/views/pages/dashboard/child/scheduleDashboard.dart';
import 'package:cmmsge/views/pages/komponen/komponenwithsearch.dart';
import 'package:cmmsge/views/pages/masalah/masalahwithsearch.dart';
import 'package:cmmsge/views/pages/mesin/mesinwithsearch.dart';
import 'package:cmmsge/views/pages/schedule/schedulewithsearch.dart';
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
        children: [_menu(), _transaksi()],
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
          // ! Menu Komponen ditutup karena tidak dipakai
          // Container(
          //   padding: EdgeInsets.only(
          //       left: 1 - .0, right: 1 - .0, top: 5.0, bottom: 5.0),
          //   alignment: Alignment.center,
          //   width: double.infinity,
          //   child: ListTile(
          //     onTap: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => KomponenPageSearch()));
          //     },
          //     title: (Text(
          //       'Komponen',
          //       style: TextStyle(
          //           fontSize: 18,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.blue),
          //     )),
          //     leading: CircleAvatar(
          //         backgroundColor: Colors.blue,
          //         child: Icon(
          //           Icons.account_tree_rounded,
          //           color: Colors.white,
          //           size: 22,
          //         )),
          //     trailing: Icon(
          //       Icons.arrow_forward_ios_rounded,
          //       color: Colors.blue,
          //     ),
          //   ),
          // ),
          // Divider(
          //   height: 5,
          // ),
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
                        builder: (context) => MesinSearchPage(
                            transaksi: 'menu', flag_activity: '')));
              },
              title: (Text(
                'Mesin',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              )),
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.precision_manufacturing_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.green,
              ),
            ),
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
                        builder: (context) => SiteSearchPage(
                              tipetransaksi: 'menu',
                            )));
              },
              title: (Text(
                'Site',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              )),
              leading: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.cabin_rounded,
                    color: Colors.white,
                    size: 22,
                  )),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.red,
              ),
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
                        builder: (context) => MasalahPageSearch(
                              jenisActivity: 0,
                            )));
              },
              title: (Text('Pre Activity',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold))),
              leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.schedule_send,
                    color: Colors.white,
                    size: 22,
                  )),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.blue,
              ),
            ),
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
                        builder: (context) => MasalahPageSearch(
                              jenisActivity: 1,
                            )));
              },
              title: (Text('Activity',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold))),
              leading: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 22,
                  )),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.orange,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: 1 - .0, right: 1 - .0, top: 5.0, bottom: 5.0),
            alignment: Alignment.center,
            width: double.infinity,
            child: ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SchedulePage()));
              },
              title: (Text('Schedule',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.pink,
                      fontWeight: FontWeight.bold))),
              leading: CircleAvatar(
                  backgroundColor: Colors.pink,
                  child: Icon(
                    Icons.schedule_rounded,
                    color: Colors.white,
                    size: 22,
                  )),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.pink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
