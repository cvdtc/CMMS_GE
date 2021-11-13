import 'package:cmmsge/services/models/mesin/mesinModel.dart';
import 'package:cmmsge/views/pages/masalah/bottommasalah.dart';
import 'package:flutter/material.dart';

class MesinTile extends StatelessWidget {
  late final MesinModel mesin;
  final String token, transaksi;
  MesinTile(
      {required this.mesin, required this.token, required this.transaksi});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
            elevation: 0.0,
            child: InkWell(
              onTap: () {
                if (transaksi == 'masalah') {
                  BottomMasalah().modalAddMasalah(context, 'tambah', token,
                      mesin.nomesin, mesin.keterangan, '', '', '', '', '');
                }
                // BottomSite().modalActionItem(context, token, site.nama,
                //     site.keterangan, site.idsite.toString());
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
                        Text('No. Mesin : ', style: TextStyle(fontSize: 18.0)),
                        Text(mesin.nomesin, style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text('Keterangan : ', style: TextStyle(fontSize: 18.0)),
                        Text(mesin.keterangan,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }
}
