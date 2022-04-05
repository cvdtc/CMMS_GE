import 'package:cmmsge/services/models/checklist_detail/checklistdetailModel.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/checklist/networkchecklist.dart';
import 'package:cmmsge/views/pages/detail_checklist/detailchecklistwithsearch.dart';
import 'package:cmmsge/views/pages/detail_checklist/networkdetchecklist.dart';
import 'package:cmmsge/views/pages/mesin/mesinwithsearch.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottomdetailchecklist.dart';

class ChecklistDetailSearchPage extends StatefulWidget {
  String idchecklist, idmesin;
  ChecklistDetailSearchPage({required this.idchecklist, required this.idmesin});
  @override
  ChecklistDetailSearchPageState createState() =>
      ChecklistDetailSearchPageState();
}

class ChecklistDetailSearchPageState extends State<ChecklistDetailSearchPage> {
  late SharedPreferences sp;

  List<ChecklistDetailModel> _checklistDetail = <ChecklistDetailModel>[];
  List<ChecklistDetailModel> _checklistDetailDisplay = <ChecklistDetailModel>[];

  TextEditingController _textSearch = TextEditingController(text: "");

  bool _isLoading = true;
  String? token = "", idchecklist = "", idmesin = "";
  int responsecode = 0;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken(String idchecklist) async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
    fetchChecklistDetail(token!, idchecklist).then((value) {
      setState(() {
        _isLoading = false;
        _checklistDetail.addAll(value);
        _checklistDetailDisplay = _checklistDetail;
      });
    }).catchError((error, stackTrace) {
      if (error == 204) {
        setState(() {
          responsecode == error;
        });
        // ReusableClasses().modalbottomWarning(context, 'Warning!',
        //     "Data masih kosong", error.toString(), 'assets/images/sorry.png');
      } else {
        ReusableClasses().modalbottomWarning(context, 'Warning!',
            error.toString(), stackTrace.toString(), 'assets/images/sorry.png');
      }
    });
  }

  @override
  initState() {
    idchecklist = widget.idchecklist;
    idmesin = widget.idmesin;
    cekToken(idchecklist!);
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
          title: Text('KOMPONEN CHECKLIST'),
          centerTitle: true,
          backgroundColor: thirdcolor,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  BottomChecklistDetail().modalActionItem(context, 'hapus',
                      token!, idchecklist.toString(), idmesin.toString());
                },
                child: Icon(
                  Icons.clear_all_rounded,
                  size: 26.0,
                ),
              ),
            )
          ]),
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              if (!_isLoading) {
                return index == 0
                    ? searchBar()
                    : ChecklistDetailTile(
                        checklistdetail:
                            this._checklistDetailDisplay[index - 1],
                        token: token!,
                      );
                // : SiteTile(site: this._sitesDisplay[index - 1]);
              } else {
                return responsecode == 204
                    ? LoadingView()
                    : Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 32.0,
                            ),
                            Text(
                              'Data komponen checklist yang anda pilih kosong!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                          ],
                        ),
                      );
              }
            },
            itemCount: _checklistDetail.length + 1,
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
            _checklistDetailDisplay = _checklistDetail.where((u) {
              var fKomponen = u.komponen.toLowerCase();

              return fKomponen.contains(searchText);
            }).toList();
          });
        },
        // controller: _textController,
        decoration: InputDecoration(
          fillColor: thirdcolor,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          hintText: 'Search Komponen',
        ),
      ),
    );
  }
}
