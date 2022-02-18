import 'package:cmmsge/services/models/site/siteModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/utils/bottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BottomSite {
  ApiService _apiService = new ApiService();
  TextEditingController _tecNama = TextEditingController(text: "");
  TextEditingController _tecKeterangan = TextEditingController(text: "");
  String _dropdownValue = "";
  bool buttonSimpanHandler = true;

  // ++ BOTTOM MODAL INPUT FORM
  void modalAddSite(context, String tipe, String token, String nama,
      String keterangan, String idsite) {
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
                    height: 25.0,
                  ),
                  ElevatedButton(
                      onPressed: buttonSimpanHandler
                          ? () {
                              // Navigator.pop(context);
                              _modalKonfirmasi(
                                  context,
                                  token,
                                  tipe,
                                  tipe == 'ubah' ? idsite.toString() : '0',
                                  _tecNama.text.toString(),
                                  _tecKeterangan.text.toString());
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          onSurface: thirdcolor,
                          primary: thirdcolor,
                          shadowColor: thirdcolor),
                      child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.0)),
                          child: Container(
                            width: 325,
                            height: 45,
                            alignment: Alignment.center,
                            child: Text('S I M P A N',
                                style: TextStyle(
                                  color: Colors.white,
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
    if (nama == "" || keterangan == "") {
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
                              buttonSimpanHandler = true;
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                side: BorderSide(width: 2, color: Colors.red),
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                primary: Colors.white),
                            child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18)),
                                child: Container(
                                  width: 125,
                                  height: 45,
                                  alignment: Alignment.center,
                                  child: Text('B A T A L',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ))),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              // Navigator.of(context).pop();
                              _actiontoapi(context, token, tipe, idsite, nama,
                                  keterangan);
                              buttonSimpanHandler = false;
                            },
                            style: ElevatedButton.styleFrom(
                                side: BorderSide(width: 2, color: Colors.green),
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                primary: Colors.white),
                            child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18)),
                                child: Container(
                                  width: 125,
                                  height: 45,
                                  alignment: Alignment.center,
                                  child: Text('SUDAH SESUAI',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ))),
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
      ReusableClasses().modalbottomWarning(
          context,
          "Tidak Valid!",
          "Pastikan semua kolom terisi dengan benar",
          'f405',
          'assets/images/sorry.png');
    } else {
      SiteModel data = SiteModel(nama: nama, keterangan: keterangan);
      if (tipe == 'tambah') {
        _apiService.addSite(token, data).then((isSuccess) {
          if (isSuccess) {
            // Navigator.of(context, rootNavigator: true).pop(context);
            _tecNama.clear();
            _tecKeterangan.clear();
            Fluttertoast.showToast(
                msg: '${_apiService.responseCode.messageApi}',
                backgroundColor: Colors.green);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => BottomNavigation(
                        numberOfPage: 2,
                      )),
              (Route<dynamic> route) => false,
            );
            buttonSimpanHandler = true;
          } else {
            ReusableClasses().modalbottomWarning(
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
          if (isSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => BottomNavigation(
                        numberOfPage: 2,
                      )),
              (Route<dynamic> route) => false,
            );
            _tecNama.clear();
            _tecKeterangan.clear();
            Fluttertoast.showToast(
                msg: '${_apiService.responseCode.messageApi}',
                backgroundColor: Colors.green);
            buttonSimpanHandler = true;
          } else {
            ReusableClasses().modalbottomWarning(
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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => BottomNavigation(
                        numberOfPage: 2,
                      )),
              (Route<dynamic> route) => false,
            );
            Fluttertoast.showToast(
                msg: '${_apiService.responseCode.messageApi}',
                backgroundColor: Colors.green);
            buttonSimpanHandler = true;
          } else {
            ReusableClasses().modalbottomWarning(
                context,
                "Gagal!",
                "${_apiService.responseCode.messageApi}",
                "f400",
                "assets/images/sorry.png");
          }
          return;
        });
      } else {
        ReusableClasses().modalbottomWarning(context, "Tidak Valid!",
            "Action anda tidak sesuai", 'f404', 'assets/images/sorry.png');
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
                        // Navigator.of(context).pop();
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
                        // Navigator.of(context).pop();
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
}
