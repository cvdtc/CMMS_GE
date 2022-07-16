import 'dart:ui';

import 'package:cmmsge/services/models/dashboard/dashboardModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/dashboard/old/activityDashboard.dart';
import 'package:cmmsge/views/pages/dashboard/child/chartDashboard.dart';
import 'package:cmmsge/views/pages/dashboard/child/listactivity.dart';
import 'package:cmmsge/views/pages/dashboard/old/scheduleDashboard.dart';
import 'package:cmmsge/views/utils/ceksharepreference.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // ! INITIALIZE VARIABLE
  ApiService _apiService = ApiService();
  late SharedPreferences sp;
  String? token = "", username = "";
  var jml_masalah = "", jml_selesai = 0, belum_selesai = 0;
  List<DashboardModel> _dashboard = <DashboardModel>[];

// ! ditutup karene coba pakai cek token global
  // * ceking token and getting dashboard value from api
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
      username = sp.getString("username");
    });
    _apiService.getDashboard(token!).then((value) {
      // DashboardModel dashboardModel = DashboardModel();
      setState(() {
        _dashboard.addAll(value!);
      });

      // jml_masalah = value as String.toList();
      // jml_selesai = dashboardModel.jml_selesai;
      // belum_selesai = jml_masalah - jml_selesai;
    }).catchError((error, stackTrace) {
      ReusableClasses().modalbottomWarning(context, 'Warning!',
          error.toString(), stackTrace.toString(), 'assets/images/sorry.png');
    });
  }

  @override
  initState() {
    // TODO: implement initState
    cekToken();
    super.initState();

    // CekSharedPred().cektoken(context).then((value) async {
    //   setState(() {
    //     token = value![0];
    //     username = value[1];
    //   });

    // }).catchError((error, stackTrace) {
    //   ReusableClasses().modalbottomWarning(context, 'Warning!',
    //       error.toString(), stackTrace.toString(), 'assets/images/sorry.png');
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _apiService.client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildTextHeader(screenHeight),
          // _buildBanner(screenHeight),
          _buildContent(screenHeight),
          _buildChart(screenHeight),
          _buildSchedule(screenHeight),
          // _buildActivity(screenHeight)
        ],
      ),
    );
  }

  // * code for design text header
  SliverToBoxAdapter _buildTextHeader(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 55, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'PT. Sinar Indogreen Kencana.',
                      style: TextStyle(fontSize: 12),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, ' + username!.toUpperCase(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(GetSharedPreference().tokens)
                      ],
                    )
                  ],
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: CircleAvatar(
                backgroundColor: primarycolor,
                child: Image.asset('assets/images/icongajah.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // * code for banner header
  SliverToBoxAdapter _buildBanner(double screenHeight) {
    return SliverToBoxAdapter(
        child: Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: thirdcolor,
          height: 150,
          width: 200,
          child: Image.asset('assets/images/logoge.png'),
        ),
      ),
    ));
  }

  // * code for setting dashboard value api to ui
  SliverToBoxAdapter _buildContent(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
        ),
        child: _dashboard == []
            ? Text('Data Not Found')
            : Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 80,
                      // width: MediaQuery.of(context).size.width / 2.3,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                _dashboard.length > 0
                                    ? _dashboard
                                        .toString()
                                        .trim()
                                        .split('jml_masalah: ')[1]
                                        .split(',')[0]
                                    : '0',
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue)),
                            Text('JUMLAH MASALAH')
                          ]),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Container(
                      height: 85,
                      // width: MediaQuery.of(context).size.width / 2.3,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                _dashboard.length > 0
                                    ? _dashboard
                                        .toString()
                                        .trim()
                                        .split('jml_selesai: ')[1]
                                        .split(',')[0]
                                        .split(']')[0]
                                    : '0',
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red)),
                            Text('JUMLAH SELESAI')
                          ]),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // * code for load json api schedule
  SliverToBoxAdapter _buildSchedule(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
          ),
          child: ListActivity()),
    );
  }

  // * code for load json api pre activity
  SliverToBoxAdapter _buildActivity(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Pre-Activity terbaru',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ActivityDashboard(
                  flag_activity: 0.toString(),
                  token: token.toString(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // * code for load json api chart Dashboard
  SliverToBoxAdapter _buildChart(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Statistik Activity',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(
              height: 10,
            ),
            ChardDashboard()
          ],
        ),
      ),
    );
  }
}
