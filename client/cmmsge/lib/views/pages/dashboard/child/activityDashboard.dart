import 'package:cmmsge/services/models/masalah/masalahModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityDashboard extends StatefulWidget {
  String flag_activity;
  ActivityDashboard({required this.flag_activity});

  @override
  _ActivityDashboardState createState() => _ActivityDashboardState();
}

class _ActivityDashboardState extends State<ActivityDashboard> {
  // ! Declare Variable HERE!
  ApiService _apiService = new ApiService();
  late SharedPreferences sp;
  String? token, flag_activity;

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
    flag_activity = widget.flag_activity;
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
        future: _apiService.getListMasalah(token!, flag_activity.toString()),
        builder: (context, AsyncSnapshot<List<MasalahModel>?> snapshot) {
          print(snapshot);
          if (snapshot.hasError) {
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
              List<MasalahModel>? dataSchedule = snapshot.data;
              return _listMasalah(dataSchedule);
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
  Widget _listMasalah(List<MasalahModel>? dataIndex) {
    return Container(
      height: 175,
      child: ListView.builder(
          itemCount: dataIndex!.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            MasalahModel? dataMasalah = dataIndex[index];
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
                            Text(dataMasalah.masalah,
                                style: TextStyle(fontSize: 18.0)),
                            Divider(
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                'Tanggal : ${dataMasalah.tanggal} ${dataMasalah.jam}'),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                'Mesin : (${dataMasalah.nomesin}) - ${dataMasalah.ketmesin}'),
                            Text('Kategori : ${dataMasalah.jenis_masalah}'),
                            Text('Dibuat pada : ${dataMasalah.created}')
                          ],
                        ),
                      ),
                    )));
          }),
    );
  }
}
