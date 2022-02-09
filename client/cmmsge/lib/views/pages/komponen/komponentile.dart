import 'package:cmmsge/services/models/komponen/KomponenModel.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:flutter/material.dart';

class KomponenTile extends StatelessWidget {
  late final KomponenModel komponen;
  final String token;
  int indexlist = 0;
  KomponenTile(
      {required this.komponen, required this.token, required this.indexlist});

  /// defining component to array
  List<TextEditingController> _tecKeterangan = [];
  List idkomponenList = [];
  

  @override
  Widget build(BuildContext context) {
    _tecKeterangan.add(new TextEditingController());
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 3.0,
      child: InkWell(
        onTap: () {
          idkomponenList.add(komponen.idkomponen.toString());
          idkomponenList.add(_tecKeterangan[indexlist].text.toString());
          print(idkomponenList.toString());
        },
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama : ' + komponen.nama, style: TextStyle(fontSize: 18.0)),
              Text('Kategori : ' + komponen.kategori,
                  style: TextStyle(fontSize: 18.0)),
              Text('Keterangan : ' + komponen.keterangan,
                  style: TextStyle(fontSize: 18.0)),
              Text('INDEX : ' + indexlist.toString(),
                  style: TextStyle(fontSize: 18.0)),
              Row(children: [
                Text('Reminder : ', style: TextStyle(fontSize: 18.0)),
                Text(
                    komponen.flag_reminder.toString() == '0'
                        ? 'Tidak'
                        : komponen.jumlah_reminder,
                    style: TextStyle(fontSize: 18.0)),
              ]),
              TextFormField(
                  // controller: _tecKeterangan[ls],
                  decoration: InputDecoration(
                focusColor: thirdcolor,
                icon: Icon(Icons.people_alt_outlined),
                labelText: 'Username',
                hintText: 'Masukkan Username',
                suffixIcon: Icon(Icons.check_circle),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
