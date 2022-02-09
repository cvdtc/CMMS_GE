import 'package:cmmsge/services/models/schedule/scheduleModel.dart';
import 'package:cmmsge/services/models/stokbarang/stokbarang.dart';
import 'package:cmmsge/views/pages/schedulepart/schedulepartwithsearch.dart';
import 'package:flutter/material.dart';

class StokBarangTile extends StatelessWidget {
  late final StokBarangModel stokbarang;
  final String token;
  StokBarangTile({required this.stokbarang, required this.token});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
          elevation: 3.0,
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kode : ' + stokbarang.kode,
                      style: TextStyle(fontSize: 18.0)),
                  Text('Nama : ' + stokbarang.nama,
                      style: TextStyle(fontSize: 18.0)),
                  Text('Umur : ' + stokbarang.umur.toString(),
                      style: TextStyle(fontSize: 18.0)),
                  Text(
                      'Stok : ' +
                          stokbarang.stok.toString() +
                          ' ' +
                          stokbarang.satuan,
                      style: TextStyle(fontSize: 18.0)),
                ],
              ),
            ),
          )),
    );
  }
}
