import 'package:cmmsge/services/models/komponen/KomponenModel.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/komponen/bottomkomponen.dart';
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
    print(komponen);
    _tecKeterangan.add(new TextEditingController());
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 3.0,
      child: InkWell(
        onTap: () {
          BottomKomponen().modalActionItem(
              context,
              'ubah',
              token,
              komponen.nama,
              komponen.kategori,
              komponen.keterangan,
              komponen.flag_reminder.toString(),
              komponen.jumlah_reminder.toString(),
              komponen.idmesin.toString(),
              komponen.idkomponen.toString());
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
              Row(children: [
                Text('Reminder : ', style: TextStyle(fontSize: 18.0)),
                Text(
                    komponen.flag_reminder.toString() == '0'
                        ? 'Tidak'
                        : komponen.jumlah_reminder.toString(),
                    style: TextStyle(fontSize: 18.0)),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
