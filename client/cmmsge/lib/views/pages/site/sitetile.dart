import 'package:cmmsge/services/models/site/siteModel.dart';
import 'package:cmmsge/views/pages/mesin/bottommesin.dart';
import 'package:flutter/material.dart';

import 'bottommodalsite.dart';

class SiteTile extends StatelessWidget {
  late final SiteModel site;
  final String token, tipetransaksi;
  SiteTile(
      {required this.site, required this.token, required this.tipetransaksi});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
            elevation: 4.0,
            child: InkWell(
              onTap: () {
                if (tipetransaksi == 'addmesin') {
                  BottomMesin().modalAddMesin(context, token, 'tambah', '', '',
                      '', site.idsite.toString(), site.nama);
                } else {
                  BottomSite().modalActionItem(context, token, site.nama,
                      site.keterangan, site.idsite.toString());
                }
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
                        Text('Nama : ', style: TextStyle(fontSize: 18.0)),
                        Text(site.nama, style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text('Keterangan : ', style: TextStyle(fontSize: 18.0)),
                        Text(site.keterangan, style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                  ],
                ),
              ),
            )));
    // return Padding(
    //   padding: EdgeInsets.symmetric(horizontal: 10.0),
    //   child: Column(
    //     children: [
    //       ListTile(
    //         title: Text(site.nama),
    //         subtitle: Text(site.keterangan),
    //         onTap: () {},
    //       ),
    //       Divider(
    //         thickness: 2.0,
    //       ),
    //     ],
    //   ),
    // );
  }
}
