import 'package:cmmsge/services/models/checkout/checkoutModel.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/checkout/bottomcheckout.dart';
import 'package:cmmsge/views/pages/checkout/checkouttile.dart';
import 'package:cmmsge/views/pages/checkout/networkchekout.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutPageSearch extends StatefulWidget {
  String idmasalah, masalah;
  CheckoutPageSearch({required this.idmasalah, required this.masalah});
  @override
  _CheckoutPageSearchState createState() => _CheckoutPageSearchState();
}

class _CheckoutPageSearchState extends State<CheckoutPageSearch> {
  late SharedPreferences sp;
  String? token = "", idmasalah = "", masalah = "";
  List<CheckoutModel> _checkout = <CheckoutModel>[];
  List<CheckoutModel> _checkoutDisplay = <CheckoutModel>[];
  TextEditingController _textSearch = TextEditingController(text: "");

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
    fetchCheckout(token!, idmasalah!).then((value) {
      setState(() {
        _isLoading = false;
        _checkout.addAll(value);
        _checkoutDisplay = _checkout;
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
    _checkoutDisplay.clear();
    _checkout.clear();
    _textSearch.clear();
    Fluttertoast.showToast(msg: 'Data sedang diperbarui, tunggu sebentar...');
    setState(() {
      cekToken();
    });
  }

  @override
  initState() {
    idmasalah = widget.idmasalah;
    masalah = widget.masalah;
    cekToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Item'),
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
          BottomCheckout().addPenyelesaian(context, token!, 'tambah',
              idmasalah.toString(), "", "", masalah!);
        },
        backgroundColor: secondcolor,
        label: Text('SELESAIKAN'),
        icon: Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: SafeArea(
          child: ListView.builder(
            itemBuilder: (context, index) {
              if (!_isLoading) {
                return index == 0
                    ? _searchBar()
                    : CheckoutTile(
                        checkout: this._checkoutDisplay[index - 1],
                        token: token!,
                      );
                // : SiteTile(site: this._sitesDisplay[index - 1]);
              } else {
                return LoadingView();
              }
            },
            itemCount: _checkoutDisplay.length + 1,
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
            _checkoutDisplay = _checkout.where((u) {
              var fBarang = u.barang.toLowerCase();
              var fKeterangan = u.keterangan.toLowerCase();
              return fBarang.contains(searchText) ||
                  fKeterangan.contains(searchText);
            }).toList();
          });
        },
        controller: _textSearch,
        decoration: InputDecoration(
          fillColor: thirdcolor,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          hintText: 'Cari Item',
        ),
      ),
    );
  }
}
