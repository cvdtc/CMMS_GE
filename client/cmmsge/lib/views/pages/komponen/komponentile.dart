import 'package:cmmsge/services/models/komponen/KomponenModel.dart';
import 'package:flutter/material.dart';

import 'bottomkomponen.dart';

class KomponenTile extends StatelessWidget {
  late final KomponenModel komponen;
  final String token;
  KomponenTile({required this.komponen, required this.token});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
            elevation: 0.0,
            child: InkWell(
              onTap: () {
                BottomKomponen().modalActionItem(
                    context,
                    token,
                    komponen.nama,
                    komponen.nomesin.toString(),
                    komponen.mesin,
                    komponen.site,
                    komponen.jumlah.toString(),
                    komponen.idkomponen.toString(),
                    komponen.idmesin.toString());
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
                        Text('Komponen : ', style: TextStyle(fontSize: 18.0)),
                        Text(
                            komponen.nama +
                                ' (' +
                                komponen.jumlah.toString() +
                                ')',
                            style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text('Mesin : ', style: TextStyle(fontSize: 18.0)),
                        Text(komponen.nama + ' (' + komponen.nomesin + ')',
                            style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text('Site : ', style: TextStyle(fontSize: 18.0)),
                        Text(komponen.site, style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }
}
