import 'dart:ui';

import 'package:cmmsge/services/models/chartmesin/chartmesinModel.dart';
import 'package:cmmsge/services/models/ringkasan_mesin/ringkasanmesinModel.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/report/datamesin/komponentab1/chart.dart';
import 'package:cmmsge/views/pages/report/datamesin/komponentab1/networkringkasanmesin.dart';
import 'package:cmmsge/views/pages/report/datamesin/komponentab2/datagantipart.dart';
import 'package:cmmsge/views/pages/report/datamesin/komponentab3/datamasalahbymesin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'komponentab1/networkringkasanmesin.dart';

class RingkasanMesinPage extends StatefulWidget {
  String idmesin, namamesin;
  RingkasanMesinPage({required this.idmesin, required this.namamesin});
  @override
  State<RingkasanMesinPage> createState() => _RingkasanMesinPageState();
}

class _RingkasanMesinPageState extends State<RingkasanMesinPage> {
  late SharedPreferences sp;
  String? token = "";

  TextEditingController _textSearch = TextEditingController(text: "");

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
  }

  @override
  initState() {
    cekToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Status Mesin ' + widget.namamesin),
            centerTitle: true,
            backgroundColor: thirdcolor,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(30.0),
              child: TabBar(
                isScrollable: true,
                unselectedLabelColor: Colors.white.withOpacity(0.3),
                indicatorColor: Colors.white,
                tabs: [
                  Tab(child: Text('Dashboard')),
                  // Tab(child: Text('Jadwal PM')),
                  // Tab(child: Text('Reminder Part')),
                  Tab(child: Text('History Part')),
                  Tab(child: Text('History Masalah')),
                ],
              ),
            ),
          ),
          body: TabBarView(children: <Widget>[
            /// tab dashboard detail mesin
            ChartDetailMesinPage(idmesin: widget.idmesin),

            /// tab ganti part
            DataGantiPartPage(idmesin: widget.idmesin),

            /// history masalah
            DataMasalahByMesinPage(idmesin: widget.idmesin)
          ])),
    );
  }
}
