import 'package:cmmsge/services/models/schedule/scheduleModel.dart';
import 'package:cmmsge/views/pages/schedulepart/schedulepartwithsearch.dart';
import 'package:flutter/material.dart';

class ScheduleTile extends StatelessWidget {
  late final ScheduleModel schedule;
  final String token;
  ScheduleTile({required this.schedule, required this.token});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
          elevation: 3.0,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SchedulePartPage(
                            idmesin: schedule.idmesin,
                          )));
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
                      Text(schedule.nomesin, style: TextStyle(fontSize: 18.0))
                    ],
                  ),
                  Row(
                    children: [
                      Text('Mesin : ', style: TextStyle(fontSize: 18.0)),
                      Text(schedule.keterangan,
                          style: TextStyle(fontSize: 18.0))
                    ],
                  ),
                  Row(
                    children: [
                      Text('Masa Pakai : ', style: TextStyle(fontSize: 18.0)),
                      Text(schedule.lewathari + ' Hari',
                          style: TextStyle(fontSize: 18.0))
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
