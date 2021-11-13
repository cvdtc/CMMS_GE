import 'package:cmmsge/services/models/mesin/mesinModel.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/mesin/networkmesin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mesintile.dart';

class MesinSearchPage extends StatefulWidget {
  String transaksi;
  MesinSearchPage({required this.transaksi});
  @override
  _MesinSearchPageState createState() => _MesinSearchPageState();
}

class _MesinSearchPageState extends State<MesinSearchPage> {
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "", transaksi = "";
  List<MesinModel> _mesin = <MesinModel>[];
  List<MesinModel> _mesinDisplay = <MesinModel>[];

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
      print("IN? " + token!);
      setState(() {
        _isLoading = false;
        _mesin.addAll(value);
        _mesinDisplay = _mesin;
        print(_mesinDisplay.length);
      });
    });
  }

  @override
  initState() {
    transaksi = widget.transaksi;
    cekToken();
    print(token);
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
                onTap: () {},
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              ),
            )
          ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Bott().modalAddSite(context, 'tambah', token!, '', '', '');
          // _modalAddSite(context, 'tambah');
        },
        label: Text(
          'Tambah Mesin',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: secondcolor,
        icon: Icon(
          Icons.cabin_outlined,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              if (!_isLoading) {
                return index == 0
                    ? _searchBar()
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
