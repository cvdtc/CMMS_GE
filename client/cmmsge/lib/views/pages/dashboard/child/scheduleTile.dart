import 'package:cmmsge/services/models/masalah/masalahModel.dart';
import 'package:cmmsge/services/models/schedule/scheduleModel.dart';
import 'package:cmmsge/views/pages/masalah/bottommasalah.dart';
import 'package:flutter/material.dart';

class ScheduleTile extends StatelessWidget {
  late final ScheduleModel scheduleModel;
  final String token;
  ScheduleTile({required this.scheduleModel, required this.token});

  @override
  Widget build(BuildContext context) {
    print(ScheduleModel);
    return Card(
        elevation: 0.0,
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
                    Text('No. Mesin : ', style: TextStyle(fontSize: 18.0)),
                    Text(scheduleModel.nomesin,
                        style: TextStyle(fontSize: 18.0))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('Mesin : ', style: TextStyle(fontSize: 18.0)),
                    Text(scheduleModel.keterangan,
                        style: TextStyle(fontSize: 18.0))
                  ],
                ),
                Row(
                  children: [
                    Text('Masa Pakai : ', style: TextStyle(fontSize: 18.0)),
                    Text(scheduleModel.lewathari + ' hari',
                        style: TextStyle(fontSize: 18.0))
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
