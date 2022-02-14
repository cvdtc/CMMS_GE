import 'dart:convert';

import 'package:cmmsge/services/models/komponen/KomponenModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/checklist/bottomchecklist.dart';
import 'package:cmmsge/views/pages/komponen/networkkomponen.dart';
import 'package:cmmsge/views/utils/ceksharepreference.dart';
import 'package:flutter/material.dart';

class KomponenChecklistPage extends StatefulWidget {
  String idcheckout, idmesin;
  KomponenChecklistPage({required this.idcheckout, required this.idmesin});
  @override
  State<KomponenChecklistPage> createState() => _KomponenChecklistPageState();
}

class _KomponenChecklistPageState extends State<KomponenChecklistPage> {
  ApiService _apiService = new ApiService();
  String? token = "", idmesin = "", idcheckout = "";
  List<KomponenModel> _komponents = <KomponenModel>[];
  List<KomponenModel> _komponentsDisplay = <KomponenModel>[];
  bool _isLoading = true;

  /// defining component to array
  List<TextEditingController> _tecKeterangan = [];
  List<TextEditingController> _tecAction = [];
  var dataList = [];
  int indexLength = 0;
  String valueChecklist = '';
  int idchecklist = 0;

  @override
  void initState() {
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
    super.dispose();
    for (final controller in _tecKeterangan) {
      controller.dispose();
    }
    for (final controller in _tecAction) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checklist Komponen'),
        centerTitle: true,
        backgroundColor: thirdcolor,
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: _komponentsDisplay.length,
            itemBuilder: (context, index) {
              indexLength = index;
              _tecKeterangan.add(new TextEditingController());
              _tecAction.add(new TextEditingController());
              if (!_isLoading) {
                return Padding(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    elevation: 3.0,
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
                          Column(
                            children: [
                              TextFormField(
                                  controller: _tecKeterangan[index],
                                  decoration: InputDecoration(
                                    focusColor: thirdcolor,
                                    icon: Icon(Icons.bug_report_outlined),
                                    labelText: 'Deskripsi',
                                    hintText: 'Masukkan Deskripsi',
                                    // suffixIcon: IconButton(
                                    //     onPressed: () {
                                    /// for test using manual add to list
                                    // for (int i = 0; i < index + 1; i++) {
                                    //   data.addAll(
                                    //     {
                                    //       'idkomponen[$index]': this
                                    //           ._komponentsDisplay[index]
                                    //           .idkomponen,
                                    //       'keterangan[$index]':
                                    //           _tecKeterangan[index]
                                    //               .text
                                    //               .toString()
                                    //     },
                                    //   );
                                    // }
                                    // for (int i = 0; i < index + 1; i++) {
                                    //   data.addAll({
                                    //     'keterangan[$index]':
                                    //         _tecKeterangan[index]
                                    //             .text
                                    //             .toString()
                                    //   });
                                    // }
                                    /// for test without multi dimesnsion of list
                                    // dataList = List.generate(
                                    //     index + 1,
                                    //     (index) =>
                                    //         this
                                    //             ._komponentsDisplay[index]
                                    //             .idkomponen
                                    //             .toString() +
                                    //         _tecKeterangan[index]
                                    //             .text
                                    //             .toString());

                                    /// for test within multi dimension of list (FIX)
                                    // dataList = List.generate(
                                    //     index + 1,
                                    //     (index) => [
                                    //           this
                                    //               ._komponentsDisplay[index]
                                    //               .idkomponen,
                                    //           _tecKeterangan[index]
                                    //               .text
                                    //               .toString()
                                    //         ]);
                                    // print(dataList);
                                    // print(json.encode({'array': dataList}));
                                    // setState(() {
                                    //   valueChecklist = json.encode(
                                    //       {'array': dataList}).toString();
                                    // });
                                    // },
                                    // icon: new Icon(Icons
                                    //     .check_circle_outline_outlined),
                                    // color: _tecKeterangan[index]
                                    //             .text
                                    //             .toString() ==
                                    //         ''
                                    //     ? Colors.black
                                    //     : Colors.green),
                                  )),
                              TextFormField(
                                  controller: _tecAction[index],
                                  decoration: InputDecoration(
                                    focusColor: thirdcolor,
                                    icon: Icon(Icons.architecture_outlined),
                                    labelText: 'Action',
                                    hintText: 'Masukkan Deskripsi Action',
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          /// for test within multi dimension of list (FIX)
                                          dataList = List.generate(
                                              index + 1,
                                              (index) => [
                                                    this
                                                        ._komponentsDisplay[
                                                            index]
                                                        .idkomponen,
                                                    _tecKeterangan[index]
                                                        .text
                                                        .toString(),
                                                    _tecAction[index]
                                                        .text
                                                        .toString(),
                                                    idchecklist

                                                    /// idchecklist set injection for testing
                                                  ]);
                                          print(dataList);
                                          print(
                                              json.encode({'array': dataList}));
                                          setState(() {
                                            valueChecklist = json.encode(
                                                {'array': dataList}).toString();
                                          });
                                        },
                                        icon: new Icon(Icons
                                            .check_circle_outline_outlined),
                                        iconSize: 32.0,
                                        color: _tecKeterangan[index]
                                                    .text
                                                    .toString() ==
                                                ''
                                            ? Colors.red
                                            : Colors.green),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return LoadingView();
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: Material(
        color: thirdcolor,
        child: InkWell(
          onTap: () {
            checklistClick();
            print(dataList);
          },
          child: const SizedBox(
            height: kToolbarHeight,
            width: double.infinity,
            child: Center(
              child: Text(
                'S I M P A N',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  checklistClick() async {
    print(dataList.length != indexLength + dataList.length + indexLength);
    if (dataList.length < indexLength) {
      ReusableClasses().modalbottomWarning(
          context,
          'Harap Isi Deskripsi Komponen',
          'Pastikan ketika anda sudah mengisi deskripsi komponen, anda sudah mengklik tombol centang',
          'f204',
          'assets/images/sorry.png');
    } else {
      BottomChecklist().modalKonfirmasi(context, '', valueChecklist);
    }
  }
}
