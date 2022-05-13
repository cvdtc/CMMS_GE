import 'package:cmmsge/services/models/datagantipart/datagantipartModel.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/views/pages/report/datamesin/komponentab2/networkhistorypart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataGantiPartPage extends StatefulWidget {
  String idmesin;
  DataGantiPartPage({required this.idmesin});
  @override
  State<DataGantiPartPage> createState() => _DataGantiPartPageState();
}

class _DataGantiPartPageState extends State<DataGantiPartPage> {
  late SharedPreferences sp;
  String? token = "";
  List<DataGantiPartModel> _datagantipart = <DataGantiPartModel>[];
  var valuelistview;

  TextEditingController _textSearch = TextEditingController(text: "");

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
    fetchDataGantiPart(token!, widget.idmesin).then((value) {
      setState(() {
        _isLoading = false;
        _datagantipart.addAll(value);
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
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: DataTable(
                  columnSpacing: 30.0,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.grey.withOpacity(0.2)),
                  columns: [
                    DataColumn(
                        label: Text('Nama Barang'),
                        tooltip: 'Nama barang yang diganti'),
                    // DataColumn(label: Text('Tanggal'), tooltip: 'Tanggal ganti'),
                    DataColumn(label: Text('Qty'), tooltip: 'Qty barang'),
                    // DataColumn(label: Text('Umur'), tooltip: 'Umur barang'),
                    DataColumn(
                        label: Text('Tanggal'), tooltip: 'Tanggal Ganti'),
                  ],
                  rows: _datagantipart
                      .map((e) => DataRow(cells: [
                            DataCell(Text(
                              e.nama.toString(),
                              style: TextStyle(fontSize: 12.0),
                            )),
                            // DataCell(Text(e.tanggal.toString())),
                            DataCell(Text(
                              e.qty.toString(),
                              style: TextStyle(fontSize: 12.0),
                            )),
                            // DataCell(Text(e.umur.toString())),
                            DataCell(Text(
                              e.tanggal.toString(),
                              style: TextStyle(fontSize: 12.0),
                            )),
                          ]))
                      .toList()),
            ),
          ),
        ),
      ),
    );
  }
}
