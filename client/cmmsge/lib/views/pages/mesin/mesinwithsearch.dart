import 'package:cmmsge/services/models/mesin/mesinModel.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/mesin/networkmesin.dart';
import 'package:cmmsge/views/pages/site/sitewithinsearch.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mesintile.dart';

class MesinSearchPage extends StatefulWidget {
  String transaksi, flag_activity;
  MesinSearchPage({required this.transaksi, required this.flag_activity});
  @override
  MesinSearchPageState createState() => MesinSearchPageState();
}

class MesinSearchPageState extends State<MesinSearchPage> {
  late SharedPreferences sp;
  String? token = "", transaksi = "", flag_activity = "";
  List<MesinModel> _mesin = <MesinModel>[];
  List<MesinModel> _mesinDisplay = <MesinModel>[];
  var valuelistview;

  TextEditingController _textSearch = TextEditingController(text: "");

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken(String transaksi) async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
    fetchMesin(token!, '0').then((value) {
      _isLoading = false;
      valuelistview = value;
      _mesin.addAll(valuelistview);
      _mesinDisplay = _mesin;

      /// filter jika menu mesin ini untuk transaksi checklist maka data mesin yang di load hanya mesin yang sudah ada komponennya
      setState(() {
        if (transaksi == 'checklist') {
          _mesinDisplay = _mesin
              .where((element) => element.adakomponen.toString().contains('1'))
              .toList();
          setState(() {
            _mesin = _mesinDisplay;
          });
        }
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
    if (transaksi == 'checklist') {
      cekToken('checklist');
    } else {
      cekToken('menu');
    }
  }

  @override
  initState() {
    transaksi = widget.transaksi;
    flag_activity = widget.flag_activity;
    print(transaksi);
    cekToken(transaksi!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: transaksi == 'masalah' || transaksi == 'komponen'
              ? Text('Pilih Mesin')
              : Text('Daftar Mesin'),
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
      floatingActionButton: transaksi != 'menu' || this._mesin.length < 1
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SiteSearchPage(
                              tipetransaksi: 'addmesin',
                            )));
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
                      ? searchBar()
                      : MesinTile(
                          mesin: this._mesinDisplay[index - 1],
                          token: token!,
                          transaksi: transaksi.toString(),
                          flag_activity: flag_activity!);
                  // : SiteTile(site: this._sitesDisplay[index - 1]);
                } else {
                  return LoadingView();
                }
              },
              itemCount: _mesinDisplay.length + 1,
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
