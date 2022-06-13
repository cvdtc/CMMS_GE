import 'package:cmmsge/services/models/chartmesin/chartmesinModel.dart';
import 'package:cmmsge/services/models/ringkasan_mesin/ringkasanmesinModel.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/report/datamesin/komponentab1/networkchart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'networkringkasanmesin.dart';

class ChartDetailMesinPage extends StatefulWidget {
  String idmesin;
  ChartDetailMesinPage({required this.idmesin});
  @override
  State<ChartDetailMesinPage> createState() => _ChartDetailMesinState();
}

class _ChartDetailMesinState extends State<ChartDetailMesinPage> {
  late SharedPreferences sp;
  String? token = "";
  List<ChartMesinModel> _chartMesin = <ChartMesinModel>[];
  List<RingkasanMesinModel> _ringkasanMesin = <RingkasanMesinModel>[];
  var valuelistview;

  TextEditingController _textSearch = TextEditingController(text: "");

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
    fetchchartmesin(token!, widget.idmesin).then((value) {
      setState(() {
        _isLoading = false;
        _chartMesin.addAll(value!);
      });
    }).whenComplete(() => {
          fetchRingkasanMesin(token!, widget.idmesin).then((value) {
            setState(() {
              _isLoading = false;
              _ringkasanMesin.addAll(value!);
            });
          }).catchError((error, stackTrace) {
            print(error);
            if (error == 204) {
              ReusableClasses().modalbottomWarning(
                  context,
                  'Warning!',
                  "Data masih kosong",
                  error.toString(),
                  'assets/images/sorry.png');
            } else {
              ReusableClasses().modalbottomWarning(
                  context,
                  'Warning!',
                  error.toString(),
                  stackTrace.toString(),
                  'assets/images/sorry.png');
            }
          })
        });
  }

  @override
  initState() {
    cekToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _isLoading
          ? LoadingView()
          : CustomScrollView(
              physics: ClampingScrollPhysics(),
              slivers: <Widget>[
                  _buildChart(screenHeight),
                  _buildRingkasan(screenHeight)
                ]),
    );
  }

  // * code for design chart
  SliverToBoxAdapter _buildChart(double screenHeight) {
    List<charts.Series<ChartMesinModel, String>> chart = [
      charts.Series(
          data: _chartMesin,
          id: "Chart Mesin",
          domainFn: (ChartMesinModel chart, _) => chart.periode,
          measureFn: (ChartMesinModel chart, _) => chart.total,
          labelAccessorFn: (ChartMesinModel chartmodel, _) =>
              '${chartmodel.total.toString()}'),
    ];
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Statistik Pemeriksaan Mesin',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                Divider(
                  thickness: 2,
                  color: thirdcolor,
                ),
                Container(
                  height: 250,
                  child: charts.BarChart(
                    chart,
                    domainAxis: new charts.OrdinalAxisSpec(),
                    barRendererDecorator:
                        new charts.BarLabelDecorator<String>(),
                    animate: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // * code for design Ringkasan Mesin
  SliverToBoxAdapter _buildRingkasan(double screenHeight) {
    return SliverToBoxAdapter(
        child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            children: [
              Text(
                'Ringkasan Mesin',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              Divider(
                thickness: 2,
                color: thirdcolor,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nama Mesin : ',
                                  style: TextStyle(fontSize: 16.0)),
                              Expanded(
                                child: Text(
                                  _ringkasanMesin[0].namamesin.toString() +
                                      ' (' +
                                      _ringkasanMesin[0].nomesin.toString() +
                                      ')',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            children: [
                              Text('Lokasi Mesin : ',
                                  style: TextStyle(fontSize: 16.0)),
                              Text(_ringkasanMesin[0].lokasi.toString(),
                                  style: TextStyle(fontSize: 16.0)),
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            children: [
                              Text('Jml. Masalah : ',
                                  style: TextStyle(fontSize: 16.0)),
                              Text(_ringkasanMesin[0].jml.toString(),
                                  style: TextStyle(fontSize: 16.0)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      color: Colors.black,
                      thickness: 2.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Last Check : ',
                              style: TextStyle(fontSize: 16.0)),
                          FittedBox(
                            child: Text(
                              _ringkasanMesin[0].lastdate.toString() +
                                  ' (' +
                                  _ringkasanMesin[0].lastcheck.toString() +
                                  ' hari)',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            children: [
                              Text('Status : ',
                                  style: TextStyle(fontSize: 16.0)),
                              _ringkasanMesin[0].stat.toString() == '0'
                                  ? Text('Running',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold))
                                  : Text('Stop',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
