import 'package:cmmsge/services/models/site/siteModel.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/mesin/bottommesin.dart';
import 'package:cmmsge/views/pages/site/networksite.dart';
import 'package:cmmsge/views/pages/site/sitetile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottommodalsite.dart';

class SiteSearchPage extends StatefulWidget {
  String tipetransaksi;
  SiteSearchPage({required this.tipetransaksi});
  @override
  _SiteSearchPageState createState() => _SiteSearchPageState();
}

class _SiteSearchPageState extends State<SiteSearchPage> {
  late SharedPreferences sp;
  String? token = "", tipetransaksi = "menu";
  List<SiteModel> _sites = <SiteModel>[];
  List<SiteModel> _sitesDisplay = <SiteModel>[];
  TextEditingController _textSearch = TextEditingController(text: "");

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
    fetchSite(token!).then((value) {
      setState(() {
        _isLoading = false;
        _sites.addAll(value);
        _sitesDisplay = _sites;
      });
    });
  }

  Future refreshData() async {
    _sitesDisplay.clear();
    _textSearch.clear();
    Fluttertoast.showToast(msg: 'Data sedang diperbarui, tunggu sebentar...');
    setState(() {
      cekToken();
    });
  }

  @override
  initState() {
    tipetransaksi = widget.tipetransaksi;
    cekToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(tipetransaksi == 'addmesin' ? 'Pilih Site' : 'Daftar Site'),
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
      floatingActionButton:

          /// filter jika tipe transaksi adalah add mesin maka tidak perlu ditampilkan floating button add site
          tipetransaksi == 'addmesin'
              ? null
              : FloatingActionButton(
                  onPressed: () {
                    BottomSite()
                        .modalAddSite(context, 'tambah', token!, '', '', '');

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
                      ? _searchBar()
                      : SiteTile(
                          site: this._sitesDisplay[index - 1],
                          token: token!,
                          tipetransaksi: tipetransaksi!,
                        );
                  // : SiteTile(site: this._sitesDisplay[index - 1]);
                } else {
                  return LoadingView();
                }
              },
              itemCount: _sitesDisplay.length + 1,
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
            _sitesDisplay = _sites.where((u) {
              var fNama = u.nama.toLowerCase();
              var fKeterangan = u.keterangan.toLowerCase();
              return fNama.contains(searchText) ||
                  fKeterangan.contains(searchText);
            }).toList();
          });
        },
        // controller: _textController,
        decoration: InputDecoration(
          fillColor: thirdcolor,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          hintText: 'Search Site',
        ),
      ),
    );
  }
}
