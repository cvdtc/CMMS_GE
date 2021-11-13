import 'package:cmmsge/services/models/masalah/masalahModel.dart';
import 'package:cmmsge/services/models/mesin/mesinModel.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/mesin/mesintile.dart';
import 'package:cmmsge/views/pages/mesin/mesinwithsearch.dart';
import 'package:cmmsge/views/pages/mesin/networkmesin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'masalahtile.dart';
import 'networkmasalah.dart';

class MasalahPageSearch extends StatefulWidget {
  @override
  _MasalahPageSearchState createState() => _MasalahPageSearchState();
}

class _MasalahPageSearchState extends State<MasalahPageSearch> {
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "";
  List<MasalahModel> _masalah = <MasalahModel>[];
  List<MasalahModel> _masalahDisplay = <MasalahModel>[];
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
    fetchMasalah(token!, 'all').then((value) {
      print("IN? " + token!);
      setState(() {
        _isLoading = false;
        _masalah.addAll(value);
        _masalahDisplay = _masalah;
        print(_masalahDisplay.length);
      });
    });
  }

  @override
  initState() {
    cekToken();
    print(token);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Site'),
        centerTitle: true,
        backgroundColor: thirdcolor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MesinSearchPage(
                        transaksi: 'masalah',
                      )));
        },
        label: Text(
          'Tambah Masalah',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: secondcolor,
        icon: Icon(
          Icons.warning_amber_rounded,
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
          hintText: 'Cari Masalah',
        ),
      ),
    );
  }
}
