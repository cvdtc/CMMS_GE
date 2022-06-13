import 'package:cmmsge/services/models/masalah/masalahModel.dart';
import 'package:cmmsge/services/models/schedule/scheduleModel.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/views/pages/dashboard/child/MasalahTile.dart';
import 'package:cmmsge/views/pages/masalah/networkmasalah.dart';
import 'package:cmmsge/views/pages/schedule/networkschedule.dart';
import 'package:cmmsge/views/pages/schedule/scheduletile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListActivity extends StatefulWidget {
  @override
  State<ListActivity> createState() => _ListActivityState();
}

class _ListActivityState extends State<ListActivity> {
  late SharedPreferences sp;
  String? token = "", flag_activity = "";
  List<MasalahModel> _masalah = <MasalahModel>[];

  /// for set value listview to this variable
  TextEditingController _textSearch = TextEditingController(text: "");

  bool _isLoading = true;
  List? sieSchedule;
  List<ScheduleModel> _scheduleModel = <ScheduleModel>[];

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
    fetchSchedule(token!)
        .then((value) {
          setState(() {
            _scheduleModel.addAll(value);
          });
        })
        .whenComplete(() => {
              fetchMasalah(token!, '1', '0', '0', '0').then((value) {
                setState(() {
                  _isLoading = false;
                  _masalah.addAll(value);
                });
              })
            })
        .onError((error, stackTrace) {
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
        });
  }

  @override
  initState() {
    cekToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Schedule terbaru',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 125,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (!_isLoading) {
                  return ScheduleTile(
                      schedule: _scheduleModel[index], token: token!);
                } else {
                  return CircularProgressIndicator();
                }
              },
              itemCount: 10,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text('Activity terbaru',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 125,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (!_isLoading) {
                  return DashboardMasalahTile(
                      masalahModel: _masalah[index], token: token!);
                } else {
                  return CircularProgressIndicator();
                }
              },
              itemCount: 10,
            ),
          ),
          SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }
}
