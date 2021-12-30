import 'package:cmmsge/services/models/barang/barangModel.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/barang/networkbarang.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'barangtile.dart';

class BarangPageSearch extends StatefulWidget {
  String masalah, idmasalah, tipe;
  BarangPageSearch(
      {required this.masalah, required this.idmasalah, required this.tipe});
  @override
  _BarangPageSearchState createState() => _BarangPageSearchState();
}

class _BarangPageSearchState extends State<BarangPageSearch> {
  late SharedPreferences sp;
  String? token = "",
      username = "",
      jabatan = "",
      masalah = "",
      tipe = "",
      idmasalah = "";
  List<BarangModel> _barang = <BarangModel>[];
  List<BarangModel> _barangDisplay = <BarangModel>[];
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
    fetchBarang(token!).then((value) {
      setState(() {
        _isLoading = false;
        _barang.addAll(value);
        _barangDisplay = _barang;
      });
    });
  }

  Future refreshData() async {
    _barangDisplay.clear();
    _textSearch.clear();
    Fluttertoast.showToast(msg: 'Data sedang diperbarui, tunggu sebentar...');
    setState(() {
      cekToken();
    });
  }

  @override
  initState() {
    cekToken();
    masalah = widget.masalah;
    idmasalah = widget.idmasalah;
    tipe = widget.tipe;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Barang Penyelesaian'),
        centerTitle: true,
        backgroundColor: thirdcolor,
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: SafeArea(
          child: ListView.builder(
            itemBuilder: (context, index) {
              if (!_isLoading) {
                return index == 0
                    ? _searchBar()
                    : BarangTile(
                        barang: this._barangDisplay[index - 1],
                        token: token!,
                        masalah: masalah!,
                        idmasalah: idmasalah!.toString(),
                        tipe: tipe!);
                // : SiteTile(site: this._sitesDisplay[index - 1]);
              } else {
                return LoadingView();
              }
            },
            itemCount: _barangDisplay.length + 1,
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
            _barangDisplay = _barang.where((u) {
              var fNama = u.nama.toLowerCase();
              var fKode = u.kode.toLowerCase();
              return fNama.contains(searchText) || fKode.contains(searchText);
            }).toList();
          });
        },
        controller: _textSearch,
        decoration: InputDecoration(
          fillColor: thirdcolor,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          hintText: 'Cari Barang',
        ),
      ),
    );
  }
}
