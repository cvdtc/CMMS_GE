import 'package:cmmsge/services/models/progress/progressModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class BottomProgress {
  // *
  ApiService _apiService = new ApiService();

  // * TEXT FORM VARIABLE
  TextEditingController _tecPerbaikan = TextEditingController(text: "");
  TextEditingController _tecTanggal = TextEditingController(text: "");
  TextEditingController _tecEngineer = TextEditingController(text: "");
  TextEditingController _tecShift = TextEditingController(text: "");

  bool buttonSimpanHandler = true;

  // * DATE AND TIME VARIABLE
  String _setDate = "";
  DateTime dateSelected = DateTime.now();

  // * INITIAL DROPDOWNBUTTON
  String _kategoriValue = 'Masalah';
  String _shiftValue = '1';

  // ++ BOTTOM MODAL UNTUK INPUT DATA
  void modalAddProgress(context, String tipe, String token, String idmasalah,
      String perbaikan, String engineer, String tanggal, String shift) {
    // * setting value text form field if action is edit
    if (tipe == 'ubah') {
      _tecPerbaikan.value = TextEditingValue(
          text: perbaikan,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecPerbaikan.text.length)));
      _tecEngineer.value = TextEditingValue(
          text: engineer,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecEngineer.text.length)));
      _tecTanggal.value = TextEditingValue(
          text: tanggal,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecTanggal.text.length)));
      // _tecShift.value = TextEditingValue(
      //     text: shift,
      //     selection: TextSelection.fromPosition(
      //         TextPosition(offset: _tecShift.text.length)));
      _shiftValue = shift;
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tipe.toUpperCase() + ' PROGRESS',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  // Text('Mesin : (' + nomesin + ') ' + keteranganmesin,
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //     )),
                  TextFormField(
                      controller: _tecPerbaikan,
                      decoration: InputDecoration(
                          icon: Icon(Icons.warning_amber_rounded),
                          labelText: 'Deskripsi Perbaikan',
                          hintText: 'Masukkan Deskripsi')),
                  TextFormField(
                      controller: _tecEngineer,
                      decoration: InputDecoration(
                          icon: Icon(Icons.people_alt_rounded),
                          labelText: 'Engineer',
                          hintText: 'Masukkan engineer')),
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

                  /// diganti combo box
                  // Container(
                  //   child: TextFormField(
                  //       controller: _tecShift,
                  //       keyboardType: TextInputType.number,
                  //       inputFormatters: <TextInputFormatter>[
                  //         FilteringTextInputFormatter.digitsOnly
                  //       ],
                  //       decoration: InputDecoration(
                  //           focusColor: thirdcolor,
                  //           icon: Icon(Icons.safety_divider),
                  //           hintText: 'Isi Shift')),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Shift :',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      StatefulBuilder(builder: (BuildContext context,
                          void Function(void Function()) setState) {
                        return DropdownButton(
                          dropdownColor: Colors.white,
                          value: _shiftValue,
                          onChanged: (String? value) {
                            setState(() {
                              _shiftValue = value!;
                            });
                          },
                          items: <String>['1', '2', '3']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  ElevatedButton(
                      onPressed: buttonSimpanHandler
                          ? () {
                              print('clicked!');
                              Navigator.pop(context);
                              modalKonfirmasi(
                                  context,
                                  tipe,
                                  token,
                                  idmasalah,
                                  _tecPerbaikan.text.toString(),
                                  _tecEngineer.text.toString(),
                                  _tecTanggal.text.toString(),
                                  _shiftValue.toString());
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
  void modalKonfirmasi(context, String tipe, String token, String idmasalah,
      String perbaikan, String engineer, String tanggal, String shift) {
    print(tipe +
        ' | ' +
        idmasalah +
        ' | ' +
        perbaikan +
        ' | ' +
        engineer +
        ' | ' +
        tanggal +
        ' | ' +
        shift);
    // * KONDISI UNTUK PENGECEKAN APAKAH NILAI/VALUE masalah, shift, tanggal, DAN jam SUDAH ADA VALUENYA APA BELUM
    if (perbaikan == "" || shift == "" || tanggal == "" || engineer == "") {
      Fluttertoast.showToast(
          msg: 'Pastikan semua kolom terisi dengan sesuai!',
          backgroundColor: Colors.green);
      // ReusableClasses().modalbottomWarning(
      //     context,
      //     'Data tidak valid!',
      //     'Pastikan semua kolom terisi dengan sesuai!',
      //     'f204',
      //     'assets/images/sorry.png');
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
                        Text('KONFIRMASI ' + tipe.toUpperCase() + ' MASALAH',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 20,
                        ),
                        tipe == 'hapus'
                            ? Text('Apakah anda yakin akan menghapus masalah ' +
                                perbaikan)
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
                                  _actionToApi(context, tipe, token, idmasalah,
                                      perbaikan, engineer, tanggal, shift);
                                  buttonSimpanHandler = false;
                                  Navigator.pop(context);
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
  void _actionToApi(context, String tipe, String token, String idmasalah,
      String perbaikan, String engineer, String tanggal, String shift) {
    ProgressModel data = ProgressModel(
        perbaikan: perbaikan,
        engineer: engineer,
        tanggal: tanggal,
        idmasalah: idmasalah,
        shift: shift);

    if (tipe == 'tambah') {
      _apiService.addProgress(token, data).then((isSuccess) {
        if (isSuccess) {
          _tecPerbaikan.clear();
          _tecTanggal.clear();
          _tecEngineer.clear();
          _tecShift.clear();
          Fluttertoast.showToast(
              msg: '${_apiService.responseCode.messageApi}',
              backgroundColor: Colors.green);
          buttonSimpanHandler = true;
        } else {
          Fluttertoast.showToast(
              msg: '${_apiService.responseCode.messageApi}',
              backgroundColor: Colors.green);
        }
      }).onError((error, stackTrace) {
        ReusableClasses().modalbottomWarning(context, 'Gagal!',
            error.toString(), 'f4xx', 'assets/images/sorry.png');
      });
    } else if (tipe == 'ubah') {
      // _apiService.editMasalah(token, addData, idmasalah).then((isSuccess) {
      //   if (isSuccess) {
      //     _tecMasalah.clear();
      //     _tecTanggal.clear();
      //     _tecJam.clear();
      //     _tecShift.clear();
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
