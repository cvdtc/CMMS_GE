import 'package:cmmsge/services/models/mesin/mesinModel.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/mesin/networkmesin.dart';
import 'package:cmmsge/views/pages/report/datamesin/mesinitemdesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Listmesin extends StatefulWidget {
  @override
  _ListmesinState createState() => _ListmesinState();
}

class _ListmesinState extends State<Listmesin> {
  late SharedPreferences sp;
  String? token = "", flag_activity = "";
  List<MesinModel> _mesin = <MesinModel>[];
  List<MesinModel> _mesinDisplay = <MesinModel>[];
  var valuelistview;

  TextEditingController _textSearch = TextEditingController(text: "");

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
    fetchMesin(token!, '0').then((value) {
      setState(() {
        _isLoading = false;
        valuelistview = value;
        _mesin.addAll(valuelistview);
        _mesinDisplay = _mesin;
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

  Future refreshData() async {
    _mesinDisplay.clear();
    _mesin.clear();
    _textSearch.clear();
    Fluttertoast.showToast(msg: 'Data sedang diperbarui, tunggu sebentar...');
    cekToken();
  }

  @override
  initState() {
    cekToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Daftar Mesin'),
          centerTitle: true,
          backgroundColor: thirdcolor,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  refreshData();
                },
                child: Icon(
                  Icons.refresh_rounded,
                  size: 26.0,
                ),
              ),
            )
          ]),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: SafeArea(
          child: Container(
            //     child: MasonryGridView.count(
            //   itemBuilder: (context, index) {
            //     if (!_isLoading) {
            //       return index == 0
            //           ? searchBar()
            //           : MesinItemDesign(
            //               mesin: this._mesinDisplay[index - 1],
            //               token: token!,
            //               flag_activity: flag_activity!);
            //     } else {
            //       return LoadingView();
            //     }
            //   },
            //   crossAxisCount: 4,
            // )
            child: GridView.builder(
              itemBuilder: (context, index) {
                if (!_isLoading) {
                  return index == 0
                      ? searchBar()
                      : MesinItemDesign(
                          mesin: this._mesinDisplay[index - 1],
                          token: token!,
                          flag_activity: flag_activity!);
                  // : SiteTile(site: this._sitesDisplay[index - 1]);
                } else {
                  return LoadingView();
                }
              },
              itemCount: _mesinDisplay.length + 1,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              shrinkWrap: false,
            ),
          ),
        ),
      ),
    );
  }

  searchBar() {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: TextField(
        controller: _textSearch,
        autofocus: false,
        onChanged: (searchText) {
          searchText = searchText.toLowerCase();
          setState(() {
            _mesinDisplay = _mesin.where((u) {
              var fNoMesin = u.nomesin.toLowerCase();
              var fKeterangan = u.keterangan.toLowerCase();
              return fNoMesin.contains(searchText) ||
                  fKeterangan.contains(searchText);
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
