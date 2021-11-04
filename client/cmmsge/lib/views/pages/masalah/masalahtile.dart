import 'package:cmmsge/services/models/masalah/masalahModel.dart';
import 'package:cmmsge/views/pages/masalah/bottommasalah.dart';
import 'package:flutter/material.dart';

class MasalahTile extends StatelessWidget {
  late final MasalahModel masalah;
  final String token;
  MasalahTile({required this.masalah, required this.token});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
            color: masalah.status == '1' ? Colors.red : Colors.white,
            elevation: 0.0,
            child: InkWell(
              onTap: () {
                BottomMasalah().modalActionItem(
                    context,
                    token,
                    masalah.masalah,
                    masalah.nomesin,
                    masalah.ketmesin,
                    masalah.idmasalah.toString());
              },
              child: Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(masalah.masalah, style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text('Tanggal : ', style: TextStyle(fontSize: 18.0)),
                        Text(masalah.tanggal + ' (' + masalah.jam + ')',
                            style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text('Mesin : ', style: TextStyle(fontSize: 18.0)),
                        Text(masalah.nomesin, style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                    Row(
                      children: [
                        Text('Ket. Mesin : ', style: TextStyle(fontSize: 18.0)),
                        Text(masalah.ketmesin, style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                    Row(
                      children: [
                        Text('Status : ', style: TextStyle(fontSize: 18.0)),
                        Text(
                            masalah.status == 1
                                ? 'Sudah Selesai'
                                : 'Belum Selesai',
                            style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }
}
