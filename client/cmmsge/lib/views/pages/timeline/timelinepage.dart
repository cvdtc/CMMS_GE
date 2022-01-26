import 'package:cmmsge/services/models/timeline/timelineModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelinePage extends StatefulWidget {
  String idmasalah;
  TimelinePage({required this.idmasalah});
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
// ! Declare Variable HERE!
  ApiService _apiService = new ApiService();
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "", idmasalah = "";
  TextEditingController _tecNama = TextEditingController(text: "");
  TextEditingController _tecKeterangan = TextEditingController(text: "");

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
      username = sp.getString("username");
      jabatan = sp.getString("jabatan");
    });
  }

  @override
  initState() {
    idmasalah = widget.idmasalah;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Timeline '),
        centerTitle: true,
        backgroundColor: thirdcolor,
      ),
      body: FutureBuilder(
          future: _apiService.getListTimeline(token!, idmasalah.toString()),
          builder: (context, AsyncSnapshot<List<TimelineModel>?> snapshot) {
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
                List<TimelineModel>? dataKomponen = snapshot.data;
                return _listKomponen(dataKomponen);
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
          }),
    );
  }

  // ++ DESIGN LIST COMPONENT
  Widget _listKomponen(List<TimelineModel>? dataIndex) {
    return ListView.builder(
        itemCount: dataIndex!.length,
        itemBuilder: (context, index) {
          TimelineModel? dataTimeline = dataIndex[index];
          return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                child: TimelineTile(
                    alignment: TimelineAlign.manual,
                    indicatorStyle: const IndicatorStyle(
                        width: 18,
                        color: primarycolor,
                        indicatorXY: 0.2,
                        padding: EdgeInsets.all(3.0)),
                    lineXY: 0.05,
                    endChild: _designItem(
                        dataTimeline.tipe,
                        dataTimeline.jam,
                        dataTimeline.tanggal,
                        dataTimeline.masalah,
                        dataTimeline.shift,
                        dataTimeline.perbaikan,
                        dataTimeline.engginer,
                        dataTimeline.tanggalprog,
                        dataTimeline.shiftprog.toString(),
                        dataTimeline.tanggalselesai,
                        dataTimeline.keteranganselesai,
                        dataTimeline.kode,
                        dataTimeline.barang,
                        dataTimeline.satuan,
                        dataTimeline.qty,
                        dataTimeline.keterangancheckout,
                        dataTimeline.penggunamasalah.toString(),
                        dataTimeline.penggunaprogress.toString(),
                        dataTimeline.penggunaselesai.toString(),
                        dataTimeline.kategori.toString(),
                        dataTimeline.tanggalbarang,
                        dataTimeline.kilometer)),
              ));
        });
  }

  Widget _designItem(
      int tipe,
      String jam,
      String tanggal,
      String masalah,
      String shift,
      String perbaikan,
      String engginer,
      String tanggalprog,
      String shiftprog,
      String tanggalselesai,
      String keteranganselesai,
      String kode,
      String barang,
      String satuan,
      String qty,
      String keterangancheckout,
      String penggunamasalah,
      String penggunaprogress,
      String penggunaselesai,
      String kategori,
      String tanggalbarang,
      String kilometer) {
    double c_width = MediaQuery.of(context).size.width * 0.8;
    if (tipe == 1) {
      // * show data masalah
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: Colors.orange[200],
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    color: Colors.orange,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Activity Shift ' + shift,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          Text('Pengguna : ' + penggunamasalah)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12.0, top: 12.0, bottom: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deskripsi : ' + masalah,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tanggal : '),
                                Text(tanggal),
                                Text(' ' + jam),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text('Kategori : '), Text(kategori)],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        )),
      );
    } else if (tipe == 2) {
      // * show data progress
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: Colors.green[200],
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress Shift ' + shiftprog,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          Text('Pengguna ' + penggunaprogress),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12.0, top: 12.0, bottom: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deskripsi : ' + perbaikan,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Engineer : ',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              engginer,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('Tanggal : '), Text(tanggalprog)],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        )),
      );
    } else if (tipe == 3) {
      // * show data penyelesaian
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: Colors.blue[200],
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Penyelesaian',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Pengguna ' + penggunaselesai,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12.0, top: 12.0, bottom: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deskripsi : ' + keteranganselesai,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('Tanggal : '), Text(tanggalselesai)],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        )),
      );
    } else if (tipe == 4) {
      // * show data barang
      // * show data penyelesaian
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: Colors.red[200],
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sparepart',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12.0, top: 12.0, bottom: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deskripsi : ' + keterangancheckout,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          'Nama Item : ' + '(' + kode + ') ' + barang,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'QTY : ',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              qty + ' ' + satuan,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kilometer : ',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              kilometer,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('Tanggal : '), Text(tanggalbarang)],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        )),
      );
    } else {
      return Container();
    }
  }
}
