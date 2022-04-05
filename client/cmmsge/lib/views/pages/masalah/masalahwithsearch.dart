import 'package:cmmsge/services/models/masalah/masalahModel.dart';
import 'package:cmmsge/services/models/site/siteModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/mesin/mesinwithsearch.dart';
import 'package:cmmsge/views/pages/site/networksite.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'masalahtile.dart';
import 'networkmasalah.dart';

class MasalahPageSearch extends StatefulWidget {
  var jenisActivity, idsite, start_date, end_date;

  /// for filtering if jenisActivity 0 = preactivity else if jenisActivity 1 = activity
  MasalahPageSearch(
      {required this.jenisActivity,
      required this.idsite,
      required this.start_date,
      required this.end_date});
  @override
  _MasalahPageSearchState createState() => _MasalahPageSearchState();
}

class _MasalahPageSearchState extends State<MasalahPageSearch> {
  late SharedPreferences sp;
  ApiService _apiService = new ApiService();
  String? token = "", flag_activity = "";
  List<MasalahModel> _masalah = <MasalahModel>[];
  List<MasalahModel> _masalahDisplay = <MasalahModel>[];

  /// for set value listview to this variable
  var valuelistview;

  List<SiteModel> _filtersite = <SiteModel>[];
  TextEditingController _textSearch = TextEditingController(text: "");

  bool _isLoading = true;
  String? idsite, start_date, end_date;
  List? siteList;
  List<SiteModel> _siteModel = <SiteModel>[];

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken(flag_activity, filter_site, start_date, end_date) async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
    fetchMasalah(token!, flag_activity, filter_site, start_date, end_date)
        .then((value) {
      setState(() {
        _isLoading = false;
        valuelistview = value;
        _masalah.addAll(valuelistview);
        _masalahDisplay = _masalah;
      });
    }).onError((error, stackTrace) {
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
    _masalahDisplay.clear();
    _masalah.clear();
    _textSearch.clear();
    flag_activity = widget.jenisActivity.toString();
    Fluttertoast.showToast(msg: 'Data sedang diperbarui, tunggu sebentar...');
    setState(() {
      cekToken(flag_activity, idsite, start_date, end_date);
    });
  }

  @override
  initState() {
    flag_activity = widget.jenisActivity.toString();
    idsite = widget.idsite.toString();
    start_date = widget.start_date.toString();
    end_date = widget.end_date.toString();
    cekToken(flag_activity, idsite, start_date, end_date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            flag_activity == '0' ? 'Daftar Pre Activity' : 'Daftar Activity'),
        centerTitle: true,
        backgroundColor: thirdcolor,
        actions: this._masalah.length < 1
            ? null
            : <Widget>[
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
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      filterBottom(context);
                    },
                    child: Icon(Icons.filter_alt_rounded),
                  ),
                )
              ],
      ),
      floatingActionButton: this._masalah.length > 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MesinSearchPage(
                            transaksi: 'masalah',
                            flag_activity: flag_activity!)));
                // BottomMasalah().modalAddMasalah(
                //     context, 'tambah', token!, "", "", "", "", "", "", "");
              },
              backgroundColor: secondcolor,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: SafeArea(
          child: Container(
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (!_isLoading) {
                  return index == 0
                      ? _searchBar()
                      : MasalahTile(
                          masalah: this._masalahDisplay[index - 1],
                          token: token!,
                        );
                  // : SiteTile(site: this._sitesDisplay[index - 1]);
                } else {
                  return LoadingView();
                }
              },
              itemCount: _masalahDisplay.length + 1,
            ),
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
            _masalahDisplay = _masalah.where((u) {
              var fmasalah = u.masalah.toLowerCase();
              var fnomesin = u.nomesin.toLowerCase();
              return fmasalah.contains(searchText) ||
                  fnomesin.contains(searchText);
            }).toList();
          });
        },
        // controller: _textController,
        decoration: InputDecoration(
            fillColor: thirdcolor,
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
            hintText: 'Cari Activity',
            suffixIcon: IconButton(
              onPressed: () {
                setState(() async {
                  _masalah.clear();
                  _masalah.addAll(valuelistview);
                  _masalah = _masalahDisplay;
                  _textSearch.clear();
                });
              },
              icon: Icon(Icons.clear_rounded),
              iconSize: 18.0,
            )),
      ),
    );
  }

  void filterBottom(context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),
      builder: (BuildContext context) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'FILTER ',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Status : ',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _masalah.clear();
                                      _masalah.addAll(valuelistview);
                                      setState(() {
                                        _masalah = _masalahDisplay;
                                      });
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            width: 2, color: Colors.orange),
                                        elevation: 3.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        primary: Colors.white),
                                    child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.0)),
                                        child: Container(
                                          width: 75,
                                          height: 15,
                                          alignment: Alignment.center,
                                          child: Text('Semua',
                                              style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ))),
                                SizedBox(
                                  width: 5,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _masalah.clear();
                                      _masalah.addAll(valuelistview);
                                      _masalahDisplay = _masalah
                                          .where((element) => element
                                              .statusselesai
                                              .toString()
                                              .contains('0'))
                                          .toList();
                                      setState(() {
                                        _masalah = _masalahDisplay;
                                      });
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            width: 2, color: Colors.blue),
                                        elevation: 3.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        primary: Colors.white),
                                    child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.0)),
                                        child: Container(
                                          width: 75,
                                          height: 15,
                                          alignment: Alignment.center,
                                          child: Text('Belum Selesai',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ))),
                                SizedBox(
                                  width: 5,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _masalah.clear();
                                      _masalah.addAll(valuelistview);
                                      _masalahDisplay = _masalah
                                          .where((element) => element
                                              .statusselesai
                                              .toString()
                                              .contains('1'))
                                          .toList();
                                      setState(() {
                                        _masalah = _masalahDisplay;
                                      });
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            width: 2, color: Colors.green),
                                        elevation: 3.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        primary: Colors.white),
                                    child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.0)),
                                        child: Container(
                                          width: 75,
                                          height: 15,
                                          alignment: Alignment.center,
                                          child: Text('Selesai',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ))),
                              ]),
                        ),
                      )
                    ])));
      },
    );
  }

  Widget _comboSite() {
    return StatefulBuilder(builder:
        (BuildContext context, void Function(void Function()) setState) {
      return DropdownButtonHideUnderline(
        child: ButtonTheme(
            minWidth: 30,
            alignedDropdown: true,
            child: DropdownButton<String>(
              value: idsite,
              iconSize: 30,
              icon: Icon(Icons.arrow_drop_down),
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
              hint: Text('Pilih Site'),
              onChanged: (String? value) {
                setState(() {
                  idsite = value;
                  print('Clicked?' + idsite.toString());
                });
              },
              items: siteList?.map((item) {
                return new DropdownMenuItem(
                  child: Text(
                    item.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                  value: item.toString(),
                );
              }).toList(),
            )),
      );
    });
  }
}
