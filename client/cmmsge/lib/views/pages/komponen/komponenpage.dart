import 'package:cmmsge/services/models/komponen/KomponenModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KomponenPage extends StatefulWidget {
  String idmesin;
  KomponenPage({required this.idmesin});
  @override
  _KomponenPageState createState() => _KomponenPageState();
}

class _KomponenPageState extends State<KomponenPage> {
  // ! Declare Variable HERE!
  ApiService _apiService = new ApiService();
  late SharedPreferences sp;
  String token = "", idmesin = "";
  TextEditingController _tecNama = TextEditingController(text: "");
  TextEditingController _tecJumlah = TextEditingController(text: "");
  List<TextEditingController> _tecKeterangan = [];
  List<String?> idkomponenList = [];

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token")!;
    });
  }

  @override
  initState() {
    idmesin = widget.idmesin;
    cekToken();
    super.initState();
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text(
          'Tambah Komponen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: secondcolor,
        icon: Icon(
          Icons.cabin_outlined,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
          future: _apiService.getListKomponen(token, idmesin.toString()),
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
              // return Container(
              //   child: Lottie.asset('assets/loading.json'),
              // );
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
          _tecKeterangan.add(new TextEditingController());
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            elevation: 3.0,
            child: InkWell(
              onTap: () {
                idkomponenList.add(dataKomponen.idkomponen.toString());
                idkomponenList.add(_tecKeterangan[index].text.toString());
                // idkomponenList.add(dataKomponen.idkomponen.toString());
              },
              child: Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nama : ' + dataKomponen.nama,
                        style: TextStyle(fontSize: 18.0)),
                    Text('Kategori : ' + dataKomponen.kategori,
                        style: TextStyle(fontSize: 18.0)),
                    Text('Keterangan : ' + dataKomponen.keterangan,
                        style: TextStyle(fontSize: 18.0)),
                    Row(
                      children: [
                        Text('Reminder : ', style: TextStyle(fontSize: 18.0)),
                        Text(
                            dataKomponen.flag_reminder.toString() == '0'
                                ? 'Tidak'
                                : dataKomponen.jumlah_reminder,
                            style: TextStyle(fontSize: 18.0)),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          );
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
