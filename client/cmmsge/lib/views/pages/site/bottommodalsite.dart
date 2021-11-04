import 'package:cmmsge/services/models/site/siteModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:flutter/material.dart';

class BottomSite {
  ApiService _apiService = new ApiService();
  TextEditingController _tecNama = TextEditingController(text: "");
  TextEditingController _tecKeterangan = TextEditingController(text: "");

  // ++ BOTTOM MODAL INPUT FORM
  void modalAddSite(context, String tipe, String token, String nama,
      String keterangan, String idsite) {
    print("IDSITE?" + idsite.toString());
    // * setting value text form field if action is edit
    if (tipe == 'ubah') {
      _tecNama.value = TextEditingValue(
          text: nama,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecNama.text.length)));
      _tecKeterangan.value = TextEditingValue(
          text: keterangan,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecKeterangan.text.length)));
    }
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
                  Text(
                    tipe.toUpperCase(),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                      controller: _tecNama,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                          icon: Icon(Icons.cabin_rounded),
                          labelText: 'Nama Site',
                          hintText: 'Masukkan Nama Site',
                          suffixIcon:
                              Icon(Icons.check_circle_outline_outlined))),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                      controller: _tecKeterangan,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          icon: Icon(Icons.note_outlined),
                          labelText: 'Keterangan Site',
                          hintText: 'Masukkan Keterangan',
                          suffixIcon:
                              Icon(Icons.check_circle_outline_outlined))),
                  SizedBox(
                    height: 15.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        print(token +
                            tipe +
                            '0' +
                            _tecNama.text.toString() +
                            _tecKeterangan.text.toString());
                        _modalKonfirmasi(
                            context,
                            token,
                            tipe,
                            tipe == 'ubah' ? idsite.toString() : '0',
                            _tecNama.text.toString(),
                            _tecKeterangan.text.toString());
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
  void _modalKonfirmasi(context, String token, String tipe, String idsite,
      String nama, String keterangan) {
    print("IDSITE?" + idsite.toString());
    if (nama == "" || keterangan == "") {
      _modalbottomSite(
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
                      'Konfirmasi ' + tipe,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    tipe == 'hapus'
                        ? Text('Apakah anda yakin akan menghapus site ' +
                            nama +
                            '?')
                        : Text('Apakah data yang anda masukkan sudah sesuai.?',
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
                                  "Batal",
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 55,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _actiontoapi(context, token, tipe, idsite, nama,
                                  keterangan);

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
                                  "Submit",
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

  // ++ UNTUK MELAKUKAN TRANSAKSI KE API SESUAI DENGAN PARAMETER TIPE YANG DIKIRIM
  void _actiontoapi(context, String token, String tipe, String idsite,
      String nama, String keterangan) {
    if (nama == "" || keterangan == "") {
      _modalbottomSite(
          context,
          "Tidak Valid!",
          "Pastikan semua kolom terisi dengan benar",
          'f405',
          'assets/images/sorry.png');
    } else {
      SiteModel data = SiteModel(nama: nama, keterangan: keterangan);
      print(data);
      if (tipe == 'tambah') {
        _apiService.addRumah(token, data).then((isSuccess) {
          if (isSuccess) {
            _tecNama.clear();
            _tecKeterangan.clear();
            _modalbottomSite(
                context,
                "Berhasil!",
                "${_apiService.responseCode.messageApi}",
                "f200",
                "assets/images/congratulations.png");
          } else {
            _modalbottomSite(
                context,
                "Gagal!",
                "${_apiService.responseCode.messageApi}",
                "f400",
                "assets/images/sorry.png");
          }
          return;
        });
      } else if (tipe == 'ubah') {
        _apiService.ubahSite(token, idsite, data).then((isSuccess) {
          print(isSuccess);
          if (isSuccess) {
            _tecNama.clear();
            _tecKeterangan.clear();
            _modalbottomSite(
                context,
                "Berhasil!",
                "${_apiService.responseCode.messageApi}",
                "f200",
                "assets/images/congratulations.png");
          } else {
            _modalbottomSite(
                context,
                "Gagal!",
                "${_apiService.responseCode.messageApi}",
                "f400",
                "assets/images/sorry.png");
          }
          return;
        });
      } else if (tipe == 'hapus') {
        _apiService.hapusSite(token, idsite).then((isSuccess) {
          if (isSuccess) {
            _modalbottomSite(
                context,
                "Berhasil!",
                "${_apiService.responseCode.messageApi}",
                "f200",
                "assets/images/congratulations.png");
          } else {
            _modalbottomSite(
                context,
                "Gagal!",
                "${_apiService.responseCode.messageApi}",
                "f400",
                "assets/images/sorry.png");
          }
          return;
        });
      } else {
        _modalbottomSite(context, "Tidak Valid!", "Action anda tidak sesuai",
            'f404', 'assets/images/sorry.png');
      }
    }
  }

  // ++ BOTTOM MODAL ACTION ITEM
  void modalActionItem(
      context, token, String nama, String keterangan, String idsite) {
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('DETAIL',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Site : ' + nama,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text('Keterangan: ' + keterangan,
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    thickness: 1.0,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        modalAddSite(
                            context, 'ubah', token, nama, keterangan, idsite);
                      },
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(width: 2, color: Colors.green),
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          primary: Colors.white),
                      child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.0)),
                          child: Container(
                            width: 325,
                            height: 45,
                            alignment: Alignment.center,
                            child: Text('EDIT SITE',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ))),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _modalKonfirmasi(context, token, 'hapus',
                            idsite.toString(), nama, '-');
                      },
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(width: 2, color: Colors.red),
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          primary: Colors.white),
                      child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.0)),
                          child: Container(
                            width: 325,
                            height: 45,
                            alignment: Alignment.center,
                            child: Text('HAPUS SITE',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ))),
                ],
              ),
            ),
          );
        });
  }

  _modalbottomSite(context, String title, String message, String kode,
      String imagelocation) {
    dynamic navigation;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "[ " + kode.toUpperCase() + " ]",
                      style: TextStyle(fontSize: 11.0),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Image.asset(
                  imagelocation,
                  height: 150,
                  width: 250,
                ),
                SizedBox(height: 10.0),
                Text(
                  message.toString(),
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          );
        });
  }
}
