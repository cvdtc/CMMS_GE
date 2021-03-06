import 'package:cmmsge/services/models/barang/barangModel.dart';
import 'package:cmmsge/services/models/schedule/schedulepartModel.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/schedulepart/networkschedulepart.dart';
import 'package:cmmsge/views/pages/schedulepart/scheduleparttile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchedulePartPage extends StatefulWidget {
  String idmesin;
  SchedulePartPage({required this.idmesin});

  @override
  _SchedulePartPageState createState() => _SchedulePartPageState();
}

class _SchedulePartPageState extends State<SchedulePartPage> {
  late SharedPreferences sp;
  String? token = "", idmesin = '';
  List<SchedulepartModel> _schedulePart = <SchedulepartModel>[];
  List<SchedulepartModel> _schedulePartDisplay = <SchedulepartModel>[];
  TextEditingController _textSearch = TextEditingController(text: "");

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken(String idmesin) async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
    fetchSchedulePart(token!, idmesin).then((value) {
      setState(() {
        _isLoading = false;
        _schedulePart.addAll(value);
        _schedulePartDisplay = _schedulePart;
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
    idmesin = widget.idmesin;
    cekToken(idmesin!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Schedule Pergantian Part'),
          centerTitle: true,
          backgroundColor: thirdcolor,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              ),
            )
          ]),
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              if (!_isLoading) {
                return index == 0
                    ? _searchBar()
                    : SchedulePartTile(
                        barang: this._schedulePartDisplay[index - 1],
                        token: token!,
                      );
                // : SiteTile(site: this._sitesDisplay[index - 1]);
              } else {
                return LoadingView();
              }
            },
            itemCount: _schedulePart.length + 1,
          ),
        ),
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: TextField(
        controller: _textSearch,
        autofocus: false,
        onChanged: (searchText) {
          searchText = searchText.toLowerCase();
          setState(() {
            _schedulePartDisplay = _schedulePart.where((u) {
              var fKode = u.kode.toLowerCase();
              var fNama = u.nama.toLowerCase();
              return fKode.contains(searchText) || fNama.contains(searchText);
            }).toList();
          });
        },
        // controller: _textController,
        decoration: InputDecoration(
          fillColor: thirdcolor,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          hintText: 'Search Mesin',
        ),
      ),
    );
  }
}
