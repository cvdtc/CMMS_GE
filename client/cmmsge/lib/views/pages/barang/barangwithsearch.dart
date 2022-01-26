import 'package:cmmsge/services/models/barang/barangModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/barang/barangtile.dart';
import 'package:cmmsge/views/pages/barang/networkbarang.dart';
import 'package:cmmsge/views/pages/checkout/checkoutwithsearch.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarangPageSearch extends StatefulWidget {
  String masalah, idmasalah, tipe;
  BarangPageSearch(
      {required this.masalah, required this.idmasalah, required this.tipe});
  @override
  _BarangPageSearchState createState() => _BarangPageSearchState();
}

class _BarangPageSearchState extends State<BarangPageSearch> {
  late SharedPreferences sp;
  ApiService _apiService = new ApiService();
  String? token = "", masalah = "", tipe = "", idmasalah = "";
  List<BarangModel> _barang = <BarangModel>[];
  List<BarangModel> _barangDisplay = <BarangModel>[];

  TextEditingController _textSearch = TextEditingController(text: "");

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
    fetchBarang(token!).then((value) {
      setState(() {
        _isLoading = false;
        _barang.addAll(value);
        _barangDisplay = _barang;
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
    _barangDisplay.clear();
    _barang.clear();
    _textSearch.clear();
    Fluttertoast.showToast(msg: 'Data sedang diperbarui, tunggu sebentar...');
    setState(() {
      cekToken();
    });
  }

  @override
  void initState() {
    masalah = widget.masalah;
    idmasalah = widget.idmasalah;
    tipe = widget.tipe;
    super.initState();
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Barang Penyelesaian'),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CheckoutPageSearch(
                      idmasalah: idmasalah!, masalah: masalah!)));
        },
        backgroundColor: secondcolor,
        label: Text('Set Selesai'),
        icon: Icon(
          Icons.check,
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
            _barangDisplay = _barang.where((u) {
              var fmasalah = u.kode.toString().toLowerCase();
              var fnomesin = u.nama.toString().toLowerCase();
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
          hintText: 'Cari Barang',
        ),
      ),
    );
  }
}
