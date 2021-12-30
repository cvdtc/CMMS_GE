import 'package:cmmsge/services/models/checkout/checkoutModel.dart';
import 'package:cmmsge/services/models/penyelesaian/penyelesaianModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/checkout/checkoutwithsearch.dart';
import 'package:cmmsge/views/utils/bottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class BottomCheckout {
  // *
  ApiService _apiService = new ApiService();

  // * TEXT FORM VARIABLE
  TextEditingController _tecTanggal = TextEditingController(text: "");
  TextEditingController _tecKeterangan = TextEditingController(text: "");

  bool buttonSimpanHandler = true;

  // * DATE AND TIME VARIABLE
  String _setDate = "";
  DateTime dateSelected = DateTime.now();

  // ++ BOTTOM MODAL UNTUK INPUT DATA
  void addPenyelesaian(context, String token, String tipe, String idmasalah,
      String tanggal, String keterangan, String masalah) {
    // * setting value text form field if action is edit
    if (tipe == 'ubah') {
      _tecKeterangan.value = TextEditingValue(
          text: keterangan,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecKeterangan.text.length)));
      _tecTanggal.value = TextEditingValue(
          text: tanggal,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecTanggal.text.length)));
      dateSelected = DateTime.parse(tanggal);
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tipe.toUpperCase() + ' BARANG',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Masalah : " + masalah,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Divider(),
                  SizedBox(height: 15.0),
                  TextFormField(
                      controller: _tecKeterangan,
                      decoration: InputDecoration(
                          icon: Icon(Icons.note_add_rounded),
                          labelText: 'Deskripsi Penyelesaian',
                          hintText: 'Masukkan deskripsi')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: TextFormField(
                            enabled: false,
                            controller: _tecTanggal,
                            onSaved: (String? val) {
                              tanggal = val.toString();
                            },
                            decoration: InputDecoration(
                              icon: Icon(Icons.date_range_rounded),
                              labelText: 'Klik Pilih Tanggal',
                            )),
                      ),
                      Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0.0, primary: primarycolor),
                          onPressed: () {
                            showDatePicker(
                                context: context,
                                initialDate: dateSelected,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2029),
                                builder: (context, picker) {
                                  return Theme(
                                      data: ThemeData.dark().copyWith(
                                          colorScheme: ColorScheme.dark(
                                              primary: thirdcolor,
                                              surface: Colors.white60,
                                              background: backgroundcolor,
                                              error: Colors.red,
                                              onPrimary: Colors.white,
                                              onSurface: primarycolor),
                                          dialogBackgroundColor: Colors.white),
                                      child: picker!);
                                }).then((value) {
                              if (value != null) {
                                _setDate = DateFormat('yyyy-MM-dd')
                                    .format(value)
                                    .toString();
                                _tecTanggal.text = _setDate;
                              }
                            });
                          },
                          child: Text('Pilih Tanggal'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  ElevatedButton(
                      onPressed: buttonSimpanHandler
                          ? () {
                              modalKonfirmasi(
                                  context,
                                  token,
                                  tipe,
                                  idmasalah,
                                  _tecKeterangan.text.toString(),
                                  _tecKeterangan.text.toString(),
                                  masalah,
                                  '');
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
                          ))),
                ],
              ),
            ),
          );
        });
  }

// ++ MODAL UNTUK KONFIRMASI SEBELUM MELAKUKAN KONEKSI KE API
  void modalKonfirmasi(context, String token, String tipe, String idmasalah,
      String tanggal, String keterangan, String masalah, idpenyelesaian) {
    // * KONDISI UNTUK PENGECEKAN APAKAH NILAI/VALUE masalah, shift, tanggal, DAN jam SUDAH ADA VALUENYA APA BELUM
    if (keterangan == "" || tanggal == "") {
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
                        tipe == 'hapus'
                            ? Text('KONFIRMASI HAPUS PENYELESAIAN',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold))
                            : Text('KONFIRMASI PENYELESAIAN',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 20,
                        ),
                        tipe == 'hapus'
                            ? Text(
                                'Apakah anda yakin akan menghapus penyelesaian masalah?  note: Harap refresh kembali halaman masalah untuk melihat data terbaru.')
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
                                  _actionToApi(
                                      context,
                                      token,
                                      tipe,
                                      idmasalah,
                                      tanggal,
                                      keterangan,
                                      masalah,
                                      idpenyelesaian);
                                  buttonSimpanHandler = false;
                                  Navigator.of(context).pop();
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
  void _actionToApi(
      context,
      String token,
      String tipe,
      String idmasalah,
      String tanggal,
      String keterangan,
      String masalah,
      String idpenyelesaian) {
    PenyelesaianModel data = PenyelesaianModel(
        keterangan: keterangan, tanggal: tanggal, idmasalah: idmasalah);
    if (tipe == 'tambah') {
      _apiService.addPenyelesaian(token, data).then((isSuccess) {
        if (isSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigation()),
            (Route<dynamic> route) => false,
          );
          _tecTanggal.clear();
          _tecKeterangan.clear();
          Fluttertoast.showToast(
              msg: '${_apiService.responseCode.messageApi}',
              backgroundColor: Colors.green);
          buttonSimpanHandler = true;
        }
      }).onError((error, stackTrace) {
        ReusableClasses().modalbottomWarning(context, 'Gagal!',
            error.toString(), 'f4xx', 'assets/images/sorry.png');
      });
    } else if (tipe == 'hapus') {
      _apiService.deletePenyelesaian(token, idpenyelesaian).then((isSuccess) {
        if (isSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigation()),
            (Route<dynamic> route) => false,
          );
          Fluttertoast.showToast(
              msg: '${_apiService.responseCode.messageApi}',
              backgroundColor: Colors.green);
          buttonSimpanHandler = true;
        }
      }).onError((error, stackTrace) {
        ReusableClasses().modalbottomWarning(context, 'Gagal!',
            error.toString(), 'f4xx', 'assets/images/sorry.png');
      });
    }
  }
}
