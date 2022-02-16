import 'package:cmmsge/services/models/stokbarang/stokbarang.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/report/stokbarang/networkstokbarang.dart';
import 'package:cmmsge/views/pages/report/stokbarang/stokbarangtile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaporanStokBarang extends StatefulWidget {
  LaporanStokBarang({Key? key}) : super(key: key);

  @override
  State<LaporanStokBarang> createState() => _LaporanStokBarangState();
}

class _LaporanStokBarangState extends State<LaporanStokBarang> {
  late SharedPreferences sp;
  String? token = "";
  List<StokBarangModel> _stokBarang = <StokBarangModel>[];
  List<StokBarangModel> _stokBarangDisplay = <StokBarangModel>[];
  TextEditingController _textSearch = TextEditingController(text: "");
  TextEditingController _tecKeyword = TextEditingController(text: "");

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
  }

  @override
  initState() {
    cekToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: thirdcolor,
          title: Container(
              width: double.infinity,
              height: 40,
              color: Colors.white,
              child: Center(
                child: TextFormField(
                    autofocus: true,
                    controller: _tecKeyword,
                    onFieldSubmitted: (value) {
                      _stokBarang.clear();
                      _stokBarangDisplay.clear();
                      Fluttertoast.showToast(
                          msg: 'Tunggu, Sedang mencari ' +
                              _tecKeyword.text.toString() +
                              ' untuk anda...');
                      _searchClick();
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Masukkan Nama barang',
                      prefixIcon: Icon(
                        Icons.search,
                        color: thirdcolor,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _stokBarang.clear();
                          _stokBarangDisplay.clear();
                          Fluttertoast.showToast(
                              msg: 'Tunggu, Sedang mencari ' +
                                  _tecKeyword.text.toString() +
                                  ' untuk anda...');
                          _searchClick();
                        },
                        icon: new Icon(Icons.arrow_forward, color: thirdcolor),
                      ),
                    )),
              ))),
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              if (!_isLoading) {
                return index == 0
                    ? _searchBar()
                    : StokBarangTile(
                        stokbarang: this._stokBarangDisplay[index - 1],
                        token: token!);
              } else {
                return Container(
                  height: size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Masukkan Keyword'),
                    ],
                  ),
                );
              }
            },
            itemCount: _stokBarangDisplay.length + 1,
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
            _stokBarangDisplay = _stokBarang.where((u) {
              var fNomesin = u.nama.toLowerCase();
              var fKeterangan = u.kode.toLowerCase();
              return fNomesin.contains(searchText) ||
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

  void _searchClick() {
    if (_tecKeyword.text.toString() == "") {
      ReusableClasses().modalbottomWarning(
          context,
          "Tidak Valid",
          'Keyword yang anda masukkan kosong!',
          'f400',
          'assets/images/sorry.png');
    } else {
      fetchStokBarang(token!, _tecKeyword.text.toString()).then((value) {
        setState(() {
          // _textSearch.clear();
          _isLoading = false;
          _stokBarang.addAll(value);
          _stokBarangDisplay = _stokBarang;
        });
      }).catchError((error, stackTrace) {
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
    }
  }
}
