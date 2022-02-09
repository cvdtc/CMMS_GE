import 'package:cmmsge/views/pages/masalah/masalahwithsearch.dart';
import 'package:cmmsge/views/pages/mesin/mesinwithsearch.dart';
import 'package:cmmsge/views/pages/report/stokbarang/stokbarang.dart';
import 'package:cmmsge/views/pages/schedule/schedulewithsearch.dart';
import 'package:cmmsge/views/pages/site/sitewithinsearch.dart';
import 'package:cmmsge/views/utils/ceksharepreference.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late SharedPreferences sp;
  String? token = "";

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    CekSharedPred().cektoken(context).then((value) => token = value![0]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.only(top: 45),
      child: Container(
        child: Column(
          children: [_menu(), _transaksi(), _reporting()],
        ),
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
                        builder: (context) => MesinSearchPage(
                            transaksi: 'komponen', flag_activity: '0')));
              },
              title: (Text(
                'Komponen',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              )),
              subtitle: Text('Master komponen berdasarkan mesin'),
              leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.account_tree_rounded,
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
              subtitle: Text('Master Mesin'),
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
              subtitle: Text('Master Site'),
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
              subtitle: Text('Schedule Kegiatan'),
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
              subtitle: Text('Report kegiatan'),
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
              subtitle: Text('Schedule ganti part'),
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
          Container(
            padding: EdgeInsets.only(
                left: 1 - .0, right: 1 - .0, top: 5.0, bottom: 5.0),
            alignment: Alignment.center,
            width: double.infinity,
            child: ListTile(
              onTap: () {},
              title: (Text('Checklist',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold))),
              subtitle: Text('Checklist Rutin Perperiode'),
              leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(
                    Icons.check_box_rounded,
                    color: Colors.white,
                    size: 22,
                  )),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.teal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reporting() {
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
                'LAPORAN',
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
                        builder: (context) => LaporanStokBarang()));
              },
              title: (Text('Stok Barang',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold))),
              subtitle: Text('Laporan stok barang'),
              leading: CircleAvatar(
                  backgroundColor: Colors.cyan,
                  child: Icon(
                    Icons.home_repair_service_rounded,
                    color: Colors.white,
                    size: 22,
                  )),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.cyan,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
