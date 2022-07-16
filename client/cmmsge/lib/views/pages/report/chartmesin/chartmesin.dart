import 'package:cmmsge/services/models/chartmesin/chartmesinModel.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/report/datamesin/komponentab1/networkchart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartMesinPage extends StatefulWidget {
  String idmesin, namamesin;
  ChartMesinPage({required this.idmesin, required this.namamesin});

  @override
  State<ChartMesinPage> createState() => _ChartMesinPageState();
}

class _ChartMesinPageState extends State<ChartMesinPage> {
  late SharedPreferences sp;
  String? token = "";
  List<ChartMesinModel> _chartMesin = <ChartMesinModel>[];
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
        // _ringkasanMesin.addAll(value);
      });
    }).catchError((error, stackTrace) {
      if (error == 204) {
        ReusableClasses().modalbottomWarning(context, 'Warning!',
            "Data masih kosong", error.toString(), 'assets/images/sorry.png');
      } else {
        ReusableClasses().modalbottomWarning(context, 'Warning!',
            error.toString(), stackTrace.toString(), 'assets/images/sorry.png');
      }
    });
  }

  @override
  initState() {
    cekToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ChartMesinModel, String>> chart = [
      charts.Series(
          data: _chartMesin,
          id: "Chart Mesin",
          domainFn: (ChartMesinModel chart, _) => chart.periode,
          measureFn: (ChartMesinModel chart, _) => chart.total)
    ];
    return Container(
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
                  animate: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
