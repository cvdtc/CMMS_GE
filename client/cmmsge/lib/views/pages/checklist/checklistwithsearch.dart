import 'package:cmmsge/services/models/checklist/checklist.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/checklist/networkchecklist.dart';
import 'package:cmmsge/views/pages/mesin/mesinwithsearch.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'checklisttile.dart';

class ChecklistSearchPage extends StatefulWidget {
  @override
  ChecklistSearchPageState createState() => ChecklistSearchPageState();
}

class ChecklistSearchPageState extends State<ChecklistSearchPage> {
  late SharedPreferences sp;
  String? token = "", transaksi = "", flag_activity = "";
  List<ChecklistModel> _checklist = <ChecklistModel>[];
  List<ChecklistModel> _checklistDisplay = <ChecklistModel>[];

  TextEditingController _textSearch = TextEditingController(text: "");

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
    fetchChecklist(token!).then((value) {
      setState(() {
        _isLoading = false;
        _checklist.addAll(value);
        _checklistDisplay = _checklist;
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
    _checklistDisplay.clear();
    _checklist.clear();
    _textSearch.clear();
    Fluttertoast.showToast(msg: 'Data sedang diperbarui, tunggu sebentar...');
    setState(() {
      cekToken();
    });
  }

  @override
  initState() {
    cekToken();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('RECORD CHECKLIST'),
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
      floatingActionButton: this._checklist.length < 0
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MesinSearchPage(
                              flag_activity: '0',
                              transaksi: 'checklist',
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
                      : ChecklistTile(
                          checklist: this._checklistDisplay[index - 1],
                          token: token!,
                        );
                  // : SiteTile(site: this._sitesDisplay[index - 1]);
                } else {
                  return LoadingView();
                }
              },
              itemCount: _checklist.length + 1,
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
            _checklistDisplay = _checklist.where((u) {
              var fNodokumen = u.no_dokumen.toLowerCase();
              var fDeskripsi = u.deskripsi.toLowerCase();
              return fNodokumen.contains(searchText) ||
                  fDeskripsi.contains(searchText);
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
