import 'package:cmmsge/services/models/datamasalahbymesin/datamasalahbymesinModel.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/report/datamesin/komponentab3/networkmasalahbymesin.dart';
import 'package:cmmsge/views/pages/timeline/timelinepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataMasalahByMesinPage extends StatefulWidget {
  String idmesin;
  DataMasalahByMesinPage({required this.idmesin});
  @override
  State<DataMasalahByMesinPage> createState() => _DataMasalahByMesinPageState();
}

class _DataMasalahByMesinPageState extends State<DataMasalahByMesinPage> {
  late SharedPreferences sp;
  String? token = "";
  List<DataMasalahByMesinModel> _datamasalah = <DataMasalahByMesinModel>[];
  var valuelistview;

  TextEditingController _textSearch = TextEditingController(text: "");

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
    fetchDatamasalahByMesin(token!, widget.idmesin).then((value) {
      setState(() {
        _isLoading = false;
        _datamasalah.addAll(value);
      });
    }).catchError((error, stackTrace) {
      print(error);
      if (error == 204) {
        ReusableClasses().modalbottomWarning(context, 'Warning!',
            "Data masih kosong", error.toString(), 'assets/images/sorry.png');
      } else {
        ReusableClasses().modalbottomWarning(context, 'Warning!',
            error.toString(), stackTrace.toString(), 'assets/images/sorry.png');
      }
    });
  }

  @override
  initState() {
    cekToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                '(*) untuk melihat detail double tap Row',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8.0,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: DataTable(
                      columnSpacing: 30.0,
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.grey.withOpacity(0.2)),
                      columns: [
                        DataColumn(
                            label: Text(
                              'Tanggal',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            tooltip: 'Tanggal Masalah'),
                        DataColumn(
                            label: Text(
                              'Masalah',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            tooltip: 'Masalah Mesin'),
                        DataColumn(
                            label: Text(
                              'Status',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            tooltip: 'Status Mesin'),
                      ],
                      rows: _datamasalah
                          .map((e) => DataRow(cells: [
                                DataCell(
                                    Text(
                                      e.tanggal.toString(),
                                      style: TextStyle(fontSize: 12.0),
                                    ), onDoubleTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TimelinePage(
                                                idmasalah:
                                                    e.idmasalah.toString(),
                                              )));
                                }),
                                DataCell(
                                    Text(
                                      e.masalah.toString(),
                                      style: TextStyle(fontSize: 12.0),
                                    ), onDoubleTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TimelinePage(
                                                idmasalah:
                                                    e.idmasalah.toString(),
                                              )));
                                }),
                                DataCell(
                                    e.status.toString == '0'
                                        ? Text(
                                            'Belum Selesai',
                                            style: TextStyle(
                                                color: thirdcolor,
                                                fontSize: 12.0),
                                          )
                                        : Text(
                                            'Selesai',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 12.0),
                                          ), onDoubleTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TimelinePage(
                                                idmasalah:
                                                    e.idmasalah.toString(),
                                              )));
                                })
                              ]))
                          .toList()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
