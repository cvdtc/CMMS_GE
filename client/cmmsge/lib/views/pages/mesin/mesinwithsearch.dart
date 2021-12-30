import 'package:cmmsge/services/models/mesin/mesinModel.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/mesin/networkmesin.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mesintile.dart';

class MesinSearchPage extends StatefulWidget {
  String transaksi;
  MesinSearchPage({required this.transaksi});
  @override
  MesinSearchPageState createState() => MesinSearchPageState();
}

class MesinSearchPageState extends State<MesinSearchPage> {
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "", transaksi = "";
  List<MesinModel> _mesin = <MesinModel>[];
  List<MesinModel> _mesinDisplay = <MesinModel>[];

  TextEditingController _textSearch = TextEditingController(text: "");

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
      username = sp.getString("username");
      jabatan = sp.getString("jabatan");
    });
    fetchMesin(token!, '0').then((value) {
      setState(() {
        _isLoading = false;
        _mesin.addAll(value);
        _mesinDisplay = _mesin;
      });
    });
  }

  Future refreshData() async {
    _mesinDisplay.clear();
    _textSearch.clear();
    Fluttertoast.showToast(msg: 'Data sedang diperbarui, tunggu sebentar...');
    setState(() {
      cekToken();
    });
  }

  @override
  initState() {
    transaksi = widget.transaksi;
    cekToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: transaksi == 'masalah'
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
      floatingActionButton: transaksi == 'masalah'
          ? null
          : FloatingActionButton(
              onPressed: () {
                // Bott().modalAddSite(context, 'tambah', token!, '', '', '');
                // _modalAddSite(context, 'tambah');
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
                          transaksi: transaksi.toString());
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
