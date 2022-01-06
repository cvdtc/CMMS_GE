import 'package:cmmsge/services/models/mesin/mesinModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/utils/bottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BottomMesin {
  // *
  ApiService _apiService = new ApiService();

  // * TEXT FORM VARIABLE
  TextEditingController _tecNoMesin = TextEditingController(text: "");
  TextEditingController _tecKeteranganMesin = TextEditingController(text: "");

  bool buttonSimpanHandler = true;
  void modalAddMesin(context, String token, String tipe, String idmesin,
      String nomesin, String keteranganmesin, String idsite, String site) {
// * setting value text form field if action is edit
    if (tipe == 'ubah') {
      _tecNoMesin.value = TextEditingValue(
          text: nomesin,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecNoMesin.text.length)));
      _tecKeteranganMesin.value = TextEditingValue(
          text: keteranganmesin,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecKeteranganMesin.text.length)));
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
                    tipe.toUpperCase() + ' MESIN',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Text('Site : ' + site,
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  TextFormField(
                      controller: _tecNoMesin,
                      decoration: InputDecoration(
                          icon: Icon(Icons.precision_manufacturing_outlined),
                          labelText: 'Nomor/Kode Mesin',
                          hintText: 'Masukkan Nomor/Kode Mesin')),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                      controller: _tecKeteranganMesin,
                      decoration: InputDecoration(
                          icon: Icon(Icons.description_rounded),
                          labelText: 'Deskripsi Mesin',
                          hintText: 'Masukkan Deskripsi Mesin')),
                  SizedBox(
                    height: 25.0,
                  ),
                  ElevatedButton(
                      onPressed: buttonSimpanHandler
                          ? () {
                              // Navigator.pop(context);
                              modalKonfirmasi(
                                  context,
                                  token,
                                  tipe,
                                  idmesin,
                                  _tecNoMesin.text.toString(),
                                  _tecKeteranganMesin.text.toString(),
                                  idsite,
                                  site);
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

  // ++ MODAL UNTUK KONFIRMASI SEBELUM MELAKUKAN KONEKSI KE API
  void modalKonfirmasi(context, String token, String tipe, String idmesin,
      String nomesin, String keteranganmesin, String idsite, String site) {
    // * KONDISI UNTUK PENGECEKAN APAKAH NILAI/VALUE masalah, shift, tanggal, DAN jam SUDAH ADA VALUENYA APA BELUM
    if (nomesin == "" || keteranganmesin == "") {
      ReusableClasses().modalbottomWarning(
          context,
          'Data tidak valid!',
          'Pastikan semua kolom terisi dengan sesuai!',
          'f204',
          'assets/images/sorry.png');
    } else {
      showModalBottomSheet<void>(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text('KONFIRMASI ' + tipe.toUpperCase() + ' MESIN',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 20,
                        ),
                        tipe == 'hapus'
                            ? Text('Apakah anda yakin akan menghapus mesin ' +
                                keteranganmesin)
                            : Text(
                                'Apakah data yang ada masukkan sudah sesuai? note: Harap refresh kembali halaman masalah untuk melihat data terbaru.'),
                        SizedBox(
                          height: 25,
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
                                    side:
                                        BorderSide(width: 2, color: Colors.red),
                                    elevation: 0.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    primary: Colors.white),
                                child: Ink(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(18.0)),
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
                                  // Navigator.pop(context);
                                  _actionToApi(context, token, tipe, idmesin,
                                      nomesin, keteranganmesin, idsite, site);
                                  buttonSimpanHandler = false;
                                  // Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    side: BorderSide(
                                        width: 2, color: Colors.green),
                                    elevation: 0.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    primary: Colors.white),
                                child: Ink(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(18.0)),
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
                        )
                      ])));
        },
      );
    }
  }

  // ! KONEKSI KE API
  void _actionToApi(context, String token, String tipe, String idmesin,
      String nomesin, String keteranganmesin, String idsite, String site) {
    MesinModel addData = MesinModel(
        idsite: idsite, nomesin: nomesin, keterangan: keteranganmesin);
    if (tipe == 'tambah') {
      _apiService.addMesin(token, addData).then((isSuccess) {
        if (isSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNavigation(
                      numberOfPage: 2,
                    )),
            (Route<dynamic> route) => false,
          );
          _tecNoMesin.clear();
          _tecKeteranganMesin.clear();
          Fluttertoast.showToast(
              msg: '${_apiService.responseCode.messageApi}',
              backgroundColor: Colors.green);
          buttonSimpanHandler = true;
        }
      }).onError((error, stackTrace) {
        ReusableClasses().modalbottomWarning(context, 'Gagal!',
            error.toString(), 'f4xx', 'assets/images/sorry.png');
      });
    } else if (tipe == 'ubah') {
      _apiService.editMesin(token, addData, idmesin).then((isSuccess) {
        if (isSuccess) {
          _tecNoMesin.clear();
          _tecKeteranganMesin.clear();
          Fluttertoast.showToast(
              msg: '${_apiService.responseCode.messageApi}',
              backgroundColor: Colors.green);
          buttonSimpanHandler = true;
        }
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => BottomNavigation(
                    numberOfPage: 2,
                  )),
          (Route<dynamic> route) => false,
        );
      }).onError((error, stackTrace) {
        ReusableClasses().modalbottomWarning(context, 'Gagal!',
            error.toString(), 'f4xx', 'assets/images/sorry.png');
      });
    }
  }
}
