import 'package:cmmsge/services/models/masalah/masalahModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/mesin/mesinwithsearch.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'masalahtile.dart';
import 'networkmasalah.dart';

class MasalahPageSearch extends StatefulWidget {
  int jenisActivity;

  /// for filtering if jenisActivity 0 = preactivity else if jenisActivity 1 = activity
  MasalahPageSearch({required this.jenisActivity});
  @override
  _MasalahPageSearchState createState() => _MasalahPageSearchState();
}

class _MasalahPageSearchState extends State<MasalahPageSearch> {
  late SharedPreferences sp;
  ApiService _apiService = new ApiService();
  String? token = "", flag_activity = "";
  List<MasalahModel> _masalah = <MasalahModel>[];
  List<MasalahModel> _masalahDisplay = <MasalahModel>[];

  TextEditingController _textSearch = TextEditingController(text: "");

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken(flag_activity) async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
    fetchMasalah(token!, flag_activity).then((value) {
      setState(() {
        _isLoading = false;
        _masalah.addAll(value);
        _masalahDisplay = _masalah;
      });
    }).onError((error, stackTrace) {
      ReusableClasses().modalbottomWarning(context, error.toString(),
          'Data masih Kosong', 'f204', 'assets/images/sorry.png');
    });
  }

  Future refreshData() async {
    _masalahDisplay.clear();
    _textSearch.clear();
    flag_activity = widget.jenisActivity.toString();
    Fluttertoast.showToast(msg: 'Data sedang diperbarui, tunggu sebentar...');
    setState(() {
      cekToken(flag_activity);
    });
  }

  @override
  initState() {
    flag_activity = widget.jenisActivity.toString();
    cekToken(flag_activity);
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MesinSearchPage(
                      transaksi: 'masalah', flag_activity: flag_activity!)));
          // BottomMasalah().modalAddMasalah(
          //     context, 'tambah', token!, "", "", "", "", "", "", "");
        },
        backgroundColor: secondcolor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
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
        ),
      ),
    );
  }
}
