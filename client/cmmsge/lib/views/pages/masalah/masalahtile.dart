import 'package:cmmsge/services/models/masalah/masalahModel.dart';
import 'package:cmmsge/views/pages/masalah/bottommasalah.dart';
import 'package:flutter/material.dart';

class MasalahTile extends StatelessWidget {
  late final MasalahModel masalah;
  final String token;
  MasalahTile({required this.masalah, required this.token});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 3.0,
        color: masalah.statusselesai == 1 ? Colors.green[100] : Colors.red[100],
        child: InkWell(
          onTap: () {
            BottomMasalah().modalActionItem(
                context,
                'ubah',
                token,
                masalah.idmesin.toString(),
                masalah.nomesin.toString(),
                masalah.ketmesin,
                masalah.masalah,
                masalah.tanggal,
                masalah.jam,
                masalah.shift.toString(),
                masalah.idmasalah.toString(),
                masalah.idpenyelesaian.toString(),
                masalah.jenis_masalah,
                masalah.statusselesai,
                masalah.flag_activity.toString());
          },
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: masalah.statusselesai == 1 ? Colors.green : Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            masalah.statusselesai == 1
                                ? Text('Sudah Terselesaikan')
                                : Text('Belum Selesai'),
                            Text('Site: ' + masalah.site)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(masalah.masalah, style: TextStyle(fontSize: 18.0)),
                        Divider(
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Tanggal : ${masalah.tanggal} ${masalah.jam}'),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                            'Mesin : (${masalah.nomesin}) - ${masalah.ketmesin}'),
                        Divider(
                          color: Colors.white,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Kategori : ${masalah.jenis_masalah}'),
                                  Text('Pengguna : ${masalah.pengguna}'),
                                ]),
                            Text('Dibuat pada : ${masalah.created}')
                          ],
                        )
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
