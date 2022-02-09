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

  /// defining component to array
  List<TextEditingController> _tecKeterangan = [];
  List idkomponenList = [];
  List saveforJSON = [];

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
    // TODO: implement dispose

    for (final controller in _tecKeterangan) {
      controller.dispose();
    }
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
          BottomKomponen().modalFormKomponen(context, 'tambah', token!,
              widget.idmesin, '', '', '', '', '', '');
        },
        backgroundColor: secondcolor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            itemCount: _komponentsDisplay.length,
            itemBuilder: (context, index) {
              _tecKeterangan.add(new TextEditingController());
              if (!_isLoading) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  elevation: 3.0,
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nama : ' + this._komponentsDisplay[index].nama,
                              style: TextStyle(fontSize: 18.0)),
                          Text(
                              'Kategori : ' +
                                  this._komponentsDisplay[index].kategori,
                              style: TextStyle(fontSize: 18.0)),
                          Text(
                              'Keterangan : ' +
                                  this._komponentsDisplay[index].keterangan,
                              style: TextStyle(fontSize: 18.0)),
                          Text('INDEX : ' + index.toString(),
                              style: TextStyle(fontSize: 18.0)),
                          Row(children: [
                            Text('Reminder : ',
                                style: TextStyle(fontSize: 18.0)),
                            Text(
                                this
                                            ._komponentsDisplay[index]
                                            .flag_reminder
                                            .toString() ==
                                        '0'
                                    ? 'Tidak'
                                    : this
                                        ._komponentsDisplay[index]
                                        .jumlah_reminder,
                                style: TextStyle(fontSize: 18.0)),
                          ]),
                          TextFormField(
                              controller: _tecKeterangan[index],
                              decoration: InputDecoration(
                                focusColor: thirdcolor,
                                icon: Icon(Icons.people_alt_outlined),
                                labelText: 'Deskripsi',
                                hintText: 'Masukkan Deskripsi',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    idkomponenList.add(
                                        _tecKeterangan[index].text.toString());
                                    idkomponenList.add(this
                                        ._komponentsDisplay[index]
                                        .idkomponen);
                                    for (var i = 0;
                                        i < this._komponentsDisplay.length;
                                        i++) {
                                      saveforJSON.add(idkomponenList);
                                    }
                                    print('array ' + idkomponenList.toString());
                                    print('save ' + saveforJSON.toString());
                                    idkomponenList.clear();
                                  },
                                  icon: new Icon(
                                      Icons.check_circle_outline_outlined),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                );
                // : KomponenTile(
                //     komponen: this._komponentsDisplay[index - 1],
                //     indexlist: index,
                //     token: token!,
                //   );
                // : SiteTile(site: this._sitesDisplay[index - 1]);
              } else {
                return LoadingView();
              }
            },
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
