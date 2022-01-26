import 'package:cmmsge/services/models/schedule/schedulepartModel.dart';
import 'package:cmmsge/views/pages/schedulepart/bottomschedulepart.dart';
import 'package:flutter/material.dart';

class SchedulePartTile extends StatelessWidget {
  late final SchedulepartModel barang;
  String token;
  SchedulePartTile({required this.barang, required this.token});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 3.0,
        color: Colors.white,
        child: InkWell(
          onTap: () {
            BottomSchedulePart().modalBottomFormSchedulePart(
                context,
                'ubah',
                token,
                barang.idcheckout.toString(),
                barang.kode,
                barang.nama,
                barang.tgl_reminder);
          },
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text('Kode : ${barang.kode}',
                            style: TextStyle(fontSize: 18.0)),
                        Text('Nama : ${barang.nama}',
                            style: TextStyle(fontSize: 18.0)),
                        Text('Satuan : ${barang.satuan}',
                            style: TextStyle(fontSize: 18.0)),
                        Text('Masa pakai : ${barang.lewathari} hari',
                            style: TextStyle(fontSize: 18.0)),
                        Text('Tgl Reminder : ${barang.tgl_reminder}',
                            style: TextStyle(fontSize: 18.0)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
