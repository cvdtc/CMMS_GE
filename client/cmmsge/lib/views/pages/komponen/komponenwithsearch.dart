import 'package:cmmsge/services/models/komponen/KomponenModel.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/komponen/bottomkomponen.dart';
import 'package:cmmsge/views/pages/komponen/networkkomponen.dart';
import 'package:cmmsge/views/utils/ceksharepreference.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'komponentile.dart';

class KomponenPageSearch extends StatefulWidget {
  String idmesin;
  KomponenPageSearch({required this.idmesin});
  @override
  _KomponenPageSearchState createState() => _KomponenPageSearchState();
}

class _KomponenPageSearchState extends State<KomponenPageSearch> {
  late SharedPreferences sp;
  String? token = "", idmesin = "";
  List<KomponenModel> _komponents = <KomponenModel>[];
  List<KomponenModel> _komponentsDisplay = <KomponenModel>[];
  TextEditingController _textSearch = TextEditingController(text: "");

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken(String idmesin) async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
  }

  Future refreshData() async {
    _komponentsDisplay.clear();
    _komponents.clear();
    _textSearch.clear();
    idmesin = widget.idmesin.toString();
    Fluttertoast.showToast(msg: 'Data sedang diperbarui, tunggu sebentar...');
    setState(() {
      fetchKomponen(token!, idmesin!).then((value) {
        setState(() {
          _isLoading = false;
          _komponents.addAll(value);
          _komponentsDisplay = _komponents;
        });
      }).onError((error, stackTrace) {
        if (error == 204) {
          ReusableClasses().modalbottomWarning(context, 'Warning!',
              "Data masih kosong", error.toString(), 'assets/images/sorry.png');
        } else {
          ReusableClasses().modalbottomWarning(
              context,
              'Warning!',
              error.toString(),
              stackTrace.toString(),
              'assets/images/sorry.png');
        }
      });
    });
  }

  @override
  initState() {
    idmesin = widget.idmesin;
    CekSharedPred().cektoken(context).then((value) {
      setState(() {
        token = value![0];
      });
      fetchKomponen(token!, idmesin!).then((value) {
        setState(() {
          _isLoading = false;
          _komponents.addAll(value);
          _komponentsDisplay = _komponents;
        });
      }).onError((error, stackTrace) {
        if (error == 204) {
          ReusableClasses().modalbottomWarning(context, 'Warning!',
              "Data masih kosong", error.toString(), 'assets/images/sorry.png');
        } else {
          ReusableClasses().modalbottomWarning(
              context,
              'Warning!',
              error.toString(),
              stackTrace.toString(),
              'assets/images/sorry.png');
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Komponen'),
        centerTitle: true,
        backgroundColor: thirdcolor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BottomKomponen().modalFormKomponen(context, 'tambah', token!, '', '',
              '', '', '', idmesin.toString(), '');
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
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: _komponentsDisplay.length + 1,
              itemBuilder: (context, index) {
                if (!_isLoading) {
                  return index == 0
                      ? _searchBar()
                      : KomponenTile(
                          komponen: this._komponentsDisplay[index - 1],
                          indexlist: index,
                          token: token!,
                        );
                  // : SiteTile(site: this._sitesDisplay[index - 1]);
                } else {
                  return LoadingView();
                }
              },
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
        autofocus: false,
        onChanged: (searchText) {
          searchText = searchText.toLowerCase();
          setState(() {
            _komponentsDisplay = _komponents.where((u) {
              var fNama = u.nama.toLowerCase();
              var fKeterangan = u.keterangan.toLowerCase();
              var fkategori = u.kategori.toLowerCase();
              return fNama.contains(searchText) ||
                  fKeterangan.contains(searchText) ||
                  fkategori.contains(searchText);
            }).toList();
          });
        },
        // controller: _textController,
        decoration: InputDecoration(
          fillColor: thirdcolor,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          hintText: 'Cari Komponen',
        ),
      ),
    );
  }
}
