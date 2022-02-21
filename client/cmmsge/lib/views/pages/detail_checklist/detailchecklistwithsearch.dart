import 'package:cmmsge/services/models/checklist/checklist.dart';
import 'package:cmmsge/services/models/checklist_detail/checklistdetailModel.dart';
import 'package:cmmsge/views/pages/checklist/bottomAddChecklist.dart';
import 'package:flutter/material.dart';

class ChecklistDetailTile extends StatelessWidget {
  late final ChecklistDetailModel checklistdetail;
  String token;

  ChecklistDetailTile({
    required this.checklistdetail,
    required this.token,
  });
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
                  Text(
                      'Mesin : (' +
                          checklistdetail.nomesin.toString() +
                          ') ' +
                          checklistdetail.ketmesin,
                      style: TextStyle(fontSize: 18.0)),
                  Text('Komponen : ' + checklistdetail.komponen.toString(),
                      style: TextStyle(fontSize: 18.0)),
                  Text('Kategori : ' + checklistdetail.kategori.toString(),
                      style: TextStyle(fontSize: 18.0)),
                  Text(
                      'Deskripsi : ' +
                          checklistdetail.keterangan_detchecklist.toString(),
                      style: TextStyle(fontSize: 18.0)),
                  Text(
                      'Action : ' + checklistdetail.action_checklist.toString(),
                      style: TextStyle(fontSize: 18.0)),
                ],
              ),
            ),
          )),
    );
  }
}
