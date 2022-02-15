import 'package:cmmsge/services/models/checklist/checklist.dart';
import 'package:cmmsge/views/pages/checklist/bottomAddChecklist.dart';
import 'package:flutter/material.dart';

class ChecklistTile extends StatelessWidget {
  late final ChecklistModel checklist;
  String token;

  ChecklistTile({
    required this.checklist,
    required this.token,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
          elevation: 3.0,
          child: InkWell(
            onTap: () {
              BottomAddChecklist().modalActionItem(
                  context,
                  token,
                  'ubah',
                  checklist.deskripsi,
                  checklist.keterangan,
                  checklist.no_dokumen.toString(),
                  checklist.dikerjakan_oleh,
                  checklist.diperiksa_oleh,
                  checklist.tanggal_checklist,
                  checklist.revisi.toString(),
                  checklist.idmesin.toString(),
                  '',
                  '',
                  checklist.idchecklist.toString());
            },
            child: Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('No. Dokumen : ' + checklist.no_dokumen.toString(),
                      style: TextStyle(fontSize: 18.0)),
                  Text('Deskripsi : ' + checklist.deskripsi.toString(),
                      style: TextStyle(fontSize: 18.0)),
                  Text(
                      'Dikerjakan Oleh : ' +
                          checklist.dikerjakan_oleh.toString(),
                      style: TextStyle(fontSize: 18.0)),
                  Text(
                      'Diperiksa Oleh : ' + checklist.diperiksa_oleh.toString(),
                      style: TextStyle(fontSize: 18.0)),
                  Text(
                      'Tanggal Checklist : ' +
                          checklist.tanggal_checklist.toString(),
                      style: TextStyle(fontSize: 18.0)),
                ],
              ),
            ),
          )),
    );
  }
}
