import 'package:cmmsge/services/models/masalah/masalahModel.dart';
import 'package:cmmsge/services/models/schedule/scheduleModel.dart';
import 'package:cmmsge/views/pages/masalah/bottommasalah.dart';
import 'package:flutter/material.dart';

class DashboardMasalahTile extends StatelessWidget {
  late final MasalahModel masalahModel;
  final String token;
  DashboardMasalahTile({required this.masalahModel, required this.token});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5.0,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Mesin : ', style: TextStyle(fontSize: 18.0)),
                    Text(
                        '(' +
                            masalahModel.nomesin +
                            ')' +
                            masalahModel.ketmesin,
                        style: TextStyle(fontSize: 18.0))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                    child: Text(masalahModel.masalah,
                        style: TextStyle(fontSize: 18.0))),
              ],
            ),
          ),
        ));
  }
}
