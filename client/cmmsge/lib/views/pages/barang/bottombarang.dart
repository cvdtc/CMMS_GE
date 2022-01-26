import 'package:cmmsge/services/models/checkout/checkoutModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class BottomBarang {
  // *
  ApiService _apiService = new ApiService();

  // * TEXT FORM VARIABLE
  TextEditingController _tecQty = TextEditingController(text: "");
  TextEditingController _tecTanggal = TextEditingController(text: "");
  TextEditingController _tecKeterangan = TextEditingController(text: "");
  TextEditingController _tecKilometer = TextEditingController(text: "");

  bool buttonSimpanHandler = true;

  // * DATE AND TIME VARIABLE
  String _setDate = "";
  DateTime dateSelected = DateTime.now();

  // ++ BOTTOM MODAL UNTUK INPUT DATA
  void addDetailBarang(
      context,
      String tipe,
      String token,
      String idmasalah,
      String masalah,
      String kode,
      String barang,
      String satuan,
      String qty,
      String tanggal,
      String keterangan,
      String kilometer,
      String umur_barang) {
    // * setting value text form field if action is edit
    if (tipe == 'ubah') {
      _tecKeterangan.value = TextEditingValue(
          text: keterangan,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecKeterangan.text.length)));
      _tecQty.value = TextEditingValue(
          text: qty,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecQty.text.length)));
      _tecTanggal.value = TextEditingValue(
          text: tanggal,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecTanggal.text.length)));
      _tecKilometer.value = TextEditingValue(
          text: kilometer,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecKilometer.text.length)));

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
                    tipe == 'tambahbarangselesai'
                        ? 'TAMBAHKAN BARANG'
                        : tipe.toUpperCase() + ' BARANG',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Activity : " + masalah,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Divider(),
                  SizedBox(height: 15.0),
                  Text(
                    'Barang: ' + barang,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: TextFormField(
                            controller: _tecQty,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                focusColor: thirdcolor,
                                icon: Icon(Icons.add_circle_outline_rounded),
                                hintText: 'Isi Qty')),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: TextFormField(
                            controller: _tecKilometer,
                            decoration: InputDecoration(
                                focusColor: thirdcolor,
                                icon: Icon(Icons.car_rental_outlined),
                                hintText: 'Isi Kilometer')),
                      ),
                    ],
                  ),
                  TextFormField(
                      controller: _tecKeterangan,
                      decoration: InputDecoration(
                          icon: Icon(Icons.note_add_rounded),
                          labelText: 'Deskripsi',
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
                              Navigator.pop(context);
                              modalKonfirmasi(
                                  context,
                                  tipe,
                                  token,
                                  idmasalah,
                                  masalah,
                                  kode,
                                  barang,
                                  satuan,
                                  _tecQty.text.toString(),
                                  _tecTanggal.text.toString(),
                                  _tecKeterangan.text.toString(),
                                  _tecKilometer.text.toString(),
                                  umur_barang);
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
                  SizedBox(
                    height: 10.0,
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => CheckoutPageSearch(
                  //                   idmasalah: idmasalah, masalah: masalah)));
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //         elevation: 3.0,
                  //         onSurface: Colors.green,
                  //         primary: Colors.green,
                  //         shadowColor: thirdcolor),
                  //     child: Ink(
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(18.0)),
                  //         child: Container(
                  //           width: 325,
                  //           height: 45,
                  //           alignment: Alignment.center,
                  //           child: Text('SET SELESAI',
                  //               style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 18.0,
                  //                 fontWeight: FontWeight.bold,
                  //               )),
                  //         )))
                ],
              ),
            ),
          );
        });
  }

// ++ MODAL UNTUK KONFIRMASI SEBELUM MELAKUKAN KONEKSI KE API
  void modalKonfirmasi(
      context,
      String tipe,
      String token,
      String idmasalah,
      String masalah,
      String kode,
      String barang,
      String satuan,
      String qty,
      String tanggal,
      String keterangan,
      String kilometer,
      String umur_barang) {
    // * KONDISI UNTUK PENGECEKAN APAKAH NILAI/VALUE masalah, shift, tanggal, DAN jam SUDAH ADA VALUENYA APA BELUM
    if (qty == "" || keterangan == "" || tanggal == "" || kode == "") {
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
                        Text('KONFIRMASI BARANG',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 20,
                        ),
                        tipe == 'hapus'
                            ? Text('Apakah anda yakin akan menghapus barang ' +
                                barang)
                            : Text(
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
                                  _actionToApi(
                                      context,
                                      tipe,
                                      token,
                                      idmasalah,
                                      masalah,
                                      kode,
                                      barang,
                                      satuan,
                                      qty,
                                      tanggal,
                                      keterangan,
                                      kilometer,
                                      umur_barang);
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
      String tipe,
      String token,
      String idmasalah,
      String masalah,
      String kode,
      String barang,
      String satuan,
      String qty,
      String tanggal,
      String keterangan,
      String kilometer,
      String umur_barang) {
    CheckoutModel data = CheckoutModel(
        idmasalah: idmasalah,
        idbarang: kode,
        tanggal: tanggal,
        idsatuan: 1,
        qty: qty,
        keterangan: keterangan,
        kilometer: kilometer,

        /// just send not be inserted, for calculate tgl_reminder + umur_pakai - 30 day in api
        umur_barang: umur_barang);

    if (tipe == 'tambahbarangselesai') {
      _apiService.addCheckoutBarang(token, data).then((isSuccess) {
        if (isSuccess) {
          _tecQty.clear();
          _tecTanggal.clear();
          _tecKeterangan.clear();
          _tecKilometer.clear();
          Fluttertoast.showToast(
              msg: '${_apiService.responseCode.messageApi}',
              backgroundColor: Colors.green);
          buttonSimpanHandler = true;
        }
      }).onError((error, stackTrace) {
        ReusableClasses().modalbottomWarning(context, 'Gagal!',
            error.toString(), 'f4xx', 'assets/images/sorry.png');
      });
    } else if (tipe == 'hapusbarangselesai') {
      // _apiService.hapusCheckout(token, idcheckout).then((isSuccess) {
      //   if (isSuccess) {
      //     _tecQty.clear();
      //     _tecTanggal.clear();
      //     _tecKeterangan.clear();
      //     _tecKilometer.clear();
      //     Fluttertoast.showToast(
      //         msg: '${_apiService.responseCode.messageApi}',
      //         backgroundColor: Colors.green);
      //     buttonSimpanHandler = true;
      //   }
      // }).onError((error, stackTrace) {
      //   ReusableClasses().modalbottomWarning(context, 'Gagal!',
      //       error.toString(), 'f4xx', 'assets/images/sorry.png');
      // });
    }
  }
}
