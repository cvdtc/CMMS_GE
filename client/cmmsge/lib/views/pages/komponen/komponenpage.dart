import 'package:cmmsge/services/models/komponen/KomponenModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KomponenPage extends StatefulWidget {
  @override
  _KomponenPageState createState() => _KomponenPageState();
}

class _KomponenPageState extends State<KomponenPage> {
  // ! Declare Variable HERE!
  ApiService _apiService = new ApiService();
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "";
  TextEditingController _tecNama = TextEditingController(text: "");
  TextEditingController _tecJumlah = TextEditingController(text: "");

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
        title: Text('Daftar Komponen'),
        centerTitle: true,
        backgroundColor: thirdcolor,
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     _modalAddSite();
      //   },
      //   label: Text(
      //     'Tambah Site',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   backgroundColor: secondcolor,
      //   icon: Icon(
      //     Icons.cabin_outlined,
      //     color: Colors.white,
      //   ),
      // ),
      body: FutureBuilder(
          future: _apiService.getListKomponen(token!, 0.toString()),
          builder: (context, AsyncSnapshot<List<KomponenModel>?> snapshot) {
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
              return Container(
                child: Lottie.asset('assets/loading.json'),
              );
              // return Center(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       CircularProgressIndicator(),
              //       SizedBox(
              //         height: 15,
              //       ),
              //       Text('Sebentar ya, sedang antri...')
              //     ],
              //   ),
              // );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<KomponenModel>? dataKomponen = snapshot.data;
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
  Widget _listKomponen(List<KomponenModel>? dataIndex) {
    return ListView.builder(
        itemCount: dataIndex!.length,
        itemBuilder: (context, index) {
          KomponenModel? dataKomponen = dataIndex[index];
          return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                  elevation: 0.0,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Komponen : ',
                                style: TextStyle(fontSize: 18.0)),
                            Text(
                                dataKomponen.nama +
                                    ' (' +
                                    dataKomponen.jumlah.toString() +
                                    ')',
                                style: TextStyle(fontSize: 18.0))
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text('Mesin : ', style: TextStyle(fontSize: 18.0)),
                            Text(
                                dataKomponen.nama +
                                    ' (' +
                                    dataKomponen.nomesin +
                                    ')',
                                style: TextStyle(fontSize: 18.0))
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text('Site : ', style: TextStyle(fontSize: 18.0)),
                            Text(dataKomponen.site,
                                style: TextStyle(fontSize: 18.0))
                          ],
                        ),
                      ],
                    ),
                  )));
        });
  }

  // ++ BOTTOM MODAL INPUT FORM
  void _modalAddSite() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                      controller: _tecNama,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                          icon: Icon(Icons.cabin_rounded),
                          labelText: 'Nama Komponen',
                          hintText: 'Masukkan Nama Komponen',
                          suffixIcon:
                              Icon(Icons.check_circle_outline_outlined))),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                      controller: _tecJumlah,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          icon: Icon(Icons.note_outlined),
                          labelText: 'Jumlah Komponen',
                          hintText: 'Masukkan Jumlah Komponen',
                          suffixIcon:
                              Icon(Icons.check_circle_outline_outlined))),
                  SizedBox(
                    height: 15.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _modalKonfirmasi();
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0.0, primary: Colors.white),
                      child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.0)),
                          child: Container(
                            width: 325,
                            height: 45,
                            alignment: Alignment.center,
                            child: Text('S I M P A N',
                                style: TextStyle(
                                  color: primarycolor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          )))
                ],
              ),
            ),
          );
        });
  }

  // ++ BOTTOM MODAL CONFIRMATION
  void _modalKonfirmasi() {
    var nama = _tecNama.text.toString();
    var jumlah = _tecJumlah.text.toString();
    if (nama == "" || jumlah == "") {
      ReusableClasses().modalbottomWarning(
          context,
          "Tidak Valid!",
          "Pastikan semua kolom terisi dengan benar",
          'f405',
          'assets/images/sorry.png');
    } else {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0))),
          builder: (BuildContext context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Konfirmasi',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Apakah data yang anda masukkan sudah sesuai.?',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              primary: Colors.red,
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18)),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Periksa Lagi",
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 55,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _addSite();
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              primary: Colors.white,
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18)),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Simpan",
                                  style: TextStyle(color: primarycolor),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  // ++ SEND VALUE TO API
  void _addSite() {
    // var nama = _tecNama.text.toString();
    // var keterangan = _tecKeterangan.text.toString();
    // if (nama == "" || keterangan == "") {
    //   ReusableClasses().modalbottomWarning(
    //       context,
    //       "Tidak Valid!",
    //       "Pastikan semua kolom terisi dengan benar",
    //       'f405',
    //       'assets/images/sorry.png');
    // } else {
    //   SiteModel data = SiteModel(nama: nama, keterangan: keterangan);
    //   print("Data? " + data.toString());
    //   _apiService.addRumah(token!, data).then((isSuccess) {
    //     if (isSuccess) {
    //       _tecNama.clear();
    //       _tecKeterangan.clear();
    //       ReusableClasses().modalbottomWarning(
    //           context,
    //           "Berhasil!",
    //           "${_apiService.responseCode.messageApi}",
    //           "f200",
    //           "assets/images/congratulations.png");
    //     } else {
    //       ReusableClasses().modalbottomWarning(
    //           context,
    //           "Gagal!",
    //           "${_apiService.responseCode.messageApi}",
    //           "f400",
    //           "assets/images/sorry.png");
    //     }
    //     return;
    //   });
    // }
  }
}
