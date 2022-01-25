import 'package:cmmsge/services/models/schedule/scheduleModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleDashboard extends StatefulWidget {
  ScheduleDashboard({Key? key}) : super(key: key);

  @override
  _ScheduleDashboardState createState() => _ScheduleDashboardState();
}

class _ScheduleDashboardState extends State<ScheduleDashboard> {
  // ! Declare Variable HERE!
  ApiService _apiService = new ApiService();
  late SharedPreferences sp;
  String? token = "";

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
    });
  }

  @override
  initState() {
    super.initState();
    cekToken();
  }

  @override
  dispose() {
    // TODO: implement dispose
    super.dispose();
    _apiService.client.close();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // ++ 0 in getlistmesin for getting all data mesin without filter
        future: _apiService.getSchedule(token!),
        builder: (context, AsyncSnapshot<List<ScheduleModel>?> snapshot) {
          print('Schedule' + snapshot.toString());
          if (snapshot.hasError) {
            print(snapshot.hasError);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                      'maaf, terjadi masalah ${snapshot.error}. buka halaman ini kembali.')
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Sebentar ya, sedang antri...')
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<ScheduleModel>? dataSchedule = snapshot.data;
              return _listSchedule(dataSchedule);
            } else {
              return Center(
                child: Text('Data Masih kosong nih!'),
              );
            }
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                      'maaf, terjadi masalah ${snapshot.error}. buka halaman ini kembali.')
                ],
              ),
            );
          }
        });
  }

  // ++ DESIGN LIST Schedule
  Widget _listSchedule(List<ScheduleModel>? dataIndex) {
    return Container(
      height: 125,
      child: ListView.builder(
          itemCount: dataIndex!.length,
          // itemCount: 12,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            ScheduleModel? dataSchedule = dataIndex[index];
            return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                    elevation: 0.0,
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('No. Mesin : ',
                                    style: TextStyle(fontSize: 18.0)),
                                Text(dataSchedule.nomesin,
                                    style: TextStyle(fontSize: 18.0))
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('Mesin : ',
                                    style: TextStyle(fontSize: 18.0)),
                                Text(dataSchedule.keterangan,
                                    style: TextStyle(fontSize: 18.0))
                              ],
                            ),
                            Row(
                              children: [
                                Text('Masa Pakai : ',
                                    style: TextStyle(fontSize: 18.0)),
                                Text(dataSchedule.lewathari + ' hari',
                                    style: TextStyle(fontSize: 18.0))
                              ],
                            ),
                          ],
                        ),
                      ),
                    )));
          }),
    );
  }
}
