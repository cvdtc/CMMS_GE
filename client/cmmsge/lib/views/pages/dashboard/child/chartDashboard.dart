import 'package:cmmsge/services/models/dashboard/chartsummaryinput.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/dashboard/child/networkchartdashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChardDashboard extends StatefulWidget {
  @override
  State<ChardDashboard> createState() => _ChardDashboardState();
}

class _ChardDashboardState extends State<ChardDashboard> {
  late SharedPreferences sp;
  String? token = "";
  List<DashboardChartModel> _dashboardChart = <DashboardChartModel>[];
  var valuelistview;

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
    fetchchartdashboard(token!).then((value) {
      setState(() {
        _isLoading = false;
        _dashboardChart.addAll(value!);
        // _dashboardChart.
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
    List<charts.Series<DashboardChartModel, String>> chart = [
      charts.Series(
          data: _dashboardChart,
          id: "Chart Mesin",
          domainFn: (DashboardChartModel chart, _) => chart.tanggal,
          measureFn: (DashboardChartModel chart, _) => chart.jumlah_activity,
          labelAccessorFn: (DashboardChartModel chartmodel, _) =>
              '${chartmodel.jumlah_activity.toString()}'),
    ];
    return Container(
      width: double.infinity,
      child: Container(
        color: Colors.white,
        height: 250,
        child: charts.BarChart(
          chart,
          domainAxis: new charts.OrdinalAxisSpec(),
          barRendererDecorator: new charts.BarLabelDecorator<String>(),
          animate: true,
        ),
      ),
    );
  }
}
