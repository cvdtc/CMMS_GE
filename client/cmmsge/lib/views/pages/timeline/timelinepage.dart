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
            print('SNAPSHOT? ' + snapshot.toString());
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
                        dataTimeline.keterangancheckout)),
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
      String keterangancheckout) {
    double c_width = MediaQuery.of(context).size.width * 0.8;
    if (tipe == 1) {
      // * show data masalah
      return Container(
        color: Colors.orange[300],
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Masalah Shift ' + shift,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Divider(
                  thickness: 2,
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tanggal : '),
                    Text(tanggal),
                    Text(' ' + jam),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Keterangan : '),
                      Text(masalah),
                    ],
                  ),
                ),
              ],
            )),
      );
    } else if (tipe == 2) {
      // * show data progress
      return Container(
        width: c_width,
        color: Colors.green[300],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progress',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Divider(
                thickness: 2,
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('Engineer : '), Text(engginer)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tanggal : '),
                  Text(tanggalprog),
                ],
              ),
              Flexible(
                child: Text('Keterangan : ' + perbaikan),
              ),
            ],
          ),
        ),
      );
    } else if (tipe == 3) {
      // * show data penyelesaian
      return Container(
        color: Colors.blue[300],
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Penyelesaian',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Divider(
                  thickness: 2,
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tanggal : '),
                    Text(tanggalselesai),
                  ],
                ),
                Flexible(
                  child: Text('Keterangan : ' + keteranganselesai),
                )
              ],
            )),
      );
    } else if (tipe == 4) {
      // * show data barang
      return Container(
        color: Colors.red[300],
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Barang',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Divider(
                  thickness: 2,
                  height: 8,
                ),
                Flexible(
                  child: Text('Barang : (' + kode + ') ' + barang),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jumlah : '),
                    Text(qty),
                    Text(' ' + satuan),
                  ],
                ),
                Flexible(
                  child: Text('Keterangan : ' + keterangancheckout),
                )
              ],
            )),
      );
    } else {
      return Container();
    }
  }
}
