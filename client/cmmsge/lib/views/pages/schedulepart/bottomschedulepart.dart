import 'package:cmmsge/services/models/checkout/checkoutModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/utils/bottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class BottomSchedulePart {
  ApiService _apiService = new ApiService();
  // * DATE AND TIME VARIABLE
  String _setDate = "";
  DateTime dateSelected = DateTime.now();
  TextEditingController _tecTanggal = TextEditingController(text: "");
  bool buttonSimpanHandler = true;

  void modalBottomFormSchedulePart(context, String tipe, String token,
      String idcheckout, String kode, String namabarang, String tgl_reminder) {
    // * setting value text form field if action is edit
    if (tipe == 'ubah') {
      _tecTanggal.value = TextEditingValue(
          text: tgl_reminder,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecTanggal.text.length)));
      dateSelected = DateTime.parse(tgl_reminder);
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
                    tipe.toUpperCase() + ' TGL REMINDER',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Part : (' + kode + ') ' + namabarang,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10.0),
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
                              tgl_reminder = val.toString();
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
                              Navigator.pop(context);
                              modalKonfirmasi(
                                  context,
                                  tipe,
                                  token,
                                  idcheckout,
                                  kode,
                                  namabarang,
                                  _tecTanggal.text.toString());
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
                            child: Text('P E R B A R U I',
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
  void modalKonfirmasi(context, String tipe, String token, String idcheckout,
      String kode, String namabarang, String tgl_reminder) {
    // * KONDISI UNTUK PENGECEKAN APAKAH NILAI/VALUE masalah, shift, tanggal, DAN jam SUDAH ADA VALUENYA APA BELUM
    if (tgl_reminder == "") {
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
                        Text('KONFIRMASI UBAH REMINDER',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                            'Apakah data yang ada masukkan sudah sesuai? note: Harap refresh kembali halaman untuk melihat data terbaru.'),
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
                                  _actionToApi(context, tipe, token, idcheckout,
                                      kode, namabarang, tgl_reminder);
                                  // Navigator.pop(context);
                                  buttonSimpanHandler = false;
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
  void _actionToApi(context, String tipe, String token, String idcheckout,
      String kode, String namabarang, String tgl_reminder) {
    CheckoutModel data = CheckoutModel(tgl_reminder: tgl_reminder);
    if (tipe == 'ubah') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => BottomNavigation(
                  numberOfPage: 2,
                )),
        (Route<dynamic> route) => false,
      );
      _apiService.ubahDataCheckout(token, idcheckout, data).then((isSuccess) {
        if (isSuccess) {
          _tecTanggal.clear();
          Fluttertoast.showToast(
              msg: '${_apiService.responseCode.messageApi}',
              backgroundColor: Colors.green);
          buttonSimpanHandler = true;
        }
      });
      // .onError((error, stackTrace) {
      //   Fluttertoast.showToast(msg: '${error}', backgroundColor: Colors.red);
      //   // ReusableClasses().modalbottomWarning(context, 'Gagal!',
      //   //     error.toString(), 'f4xx', 'assets/images/sorry.png');
      // });
    }
  }
}
