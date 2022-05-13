import 'package:cmmsge/services/models/mesin/mesinModel.dart';
import 'package:cmmsge/views/pages/report/datamesin/ringkasanmesin.dart';
import 'package:flutter/material.dart';

class MesinItemDesign extends StatelessWidget {
  late final MesinModel mesin;
  final String token, flag_activity;
  MesinItemDesign(
      {required this.mesin, required this.token, required this.flag_activity});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Card(
          elevation: 3.0,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RingkasanMesinPage(
                            idmesin: mesin.idmesin.toString(),
                            namamesin: mesin.keterangan,
                          )));
            },
            child: Column(
              children: [
                mesin.gambar == "-"
                    ? Image.asset(
                        'assets/images/logoge.png',
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        mesin.gambar,
                        fit: BoxFit.cover,
                      ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      mesin.keterangan,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
