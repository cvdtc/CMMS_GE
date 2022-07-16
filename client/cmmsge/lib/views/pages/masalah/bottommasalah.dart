import 'package:cmmsge/services/models/masalah/masalahModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/barang/barangwithsearch.dart';
import 'package:cmmsge/views/pages/checkout/bottomcheckout.dart';
import 'package:cmmsge/views/pages/progress/bottomprogress.dart';
import 'package:cmmsge/views/pages/timeline/timelinepage.dart';
import 'package:cmmsge/views/utils/bottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class BottomMasalah {
  // *
  ApiService _apiService = new ApiService();

  // * TEXT FORM VARIABLE
  TextEditingController _tecMasalah = TextEditingController(text: "");
  TextEditingController _tecTanggal = TextEditingController(text: "");
  TextEditingController _tecJam = TextEditingController(text: "");
  TextEditingController _tecShift = TextEditingController(text: "");

  bool buttonSimpanHandler = true;

  // * DATE AND TIME VARIABLE
  String _setTime = "", _setDate = "";
  DateTime dateSelected = DateTime.now();
  TimeOfDay timeSelected = TimeOfDay.now();

  // * INITIAL DROPDOWNBUTTON
  String _kategoriValue = 'Masalah';
  String _shiftValue = '1';

  // ++ BOTTOM MODAL UNTUK INPUT DATA
  void modalAddMasalah(
      context,
      String tipe,
      String token,
      String idmesin,
      String nomesin,
      String keteranganmesin,
      String masalah,
      String tanggal,
      String jam,
      String shift,
      String idmasalah,
      String idpenyelesaian,
      String kategori,
      int status,
      String flag_activity) {
    // * setting value text form field if action is edit
    if (tipe == 'ubah') {
      _tecMasalah.value = TextEditingValue(
          text: masalah,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecMasalah.text.length)));
      _tecJam.value = TextEditingValue(
          text: jam,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecJam.text.length)));
      _tecTanggal.value = TextEditingValue(
          text: tanggal,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecTanggal.text.length)));

      /// diganti jadi dropdown
      // _tecShift.value = TextEditingValue(
      //     text: shift,
      //     selection: TextSelection.fromPosition(
      //         TextPosition(offset: _tecShift.text.length)));
      _kategoriValue = kategori;
      _shiftValue = shift;
      dateSelected = DateTime.parse(tanggal);
      timeSelected = TimeOfDay(
          hour: int.parse(jam.split(':')[0]),
          minute: int.parse(jam.split(':')[1]));
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
                    tipe.toUpperCase() + ' ACTIVITY',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  // ++ Kondisi untuk menentukan apabila parameter tipe adalah tambah maka ditampilkan tombol pilih mesin untuk user memilih mesin yang akan ditambahkan sebagai masalah
                  // tipe == 'tambah'
                  //     ? ElevatedButton(
                  //         onPressed: () {},
                  //         style: ElevatedButton.styleFrom(
                  //             side: BorderSide(width: 2, color: primarycolor),
                  //             shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(8)),
                  //             elevation: 0.0,
                  //             onSurface: Colors.grey[200],
                  //             primary: Colors.grey[200],
                  //             shadowColor: Colors.grey[200]),
                  //         child: Ink(
                  //             decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(18.0)),
                  //             child: Container(
                  //               width: 325,
                  //               height: 45,
                  //               alignment: Alignment.center,
                  //               child: Text('PILIH MESIN',
                  //                   style: TextStyle(
                  //                     color: primarycolor,
                  //                     fontSize: 18.0,
                  //                     fontWeight: FontWeight.bold,
                  //                   )),
                  //             )))
                  //     : Container(),
                  Text('Mesin : (' + nomesin + ') ' + keteranganmesin,
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  TextFormField(
                      controller: _tecMasalah,
                      decoration: InputDecoration(
                          icon: Icon(Icons.warning_amber_rounded),
                          labelText: 'Deskripsi Activity',
                          hintText: 'Masukkan Activity')),
                  SizedBox(
                    height: 10.0,
                  ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: TextFormField(
                            enabled: false,
                            controller: _tecJam,
                            onSaved: (String? val) {
                              tanggal = val.toString();
                            },
                            decoration: InputDecoration(
                              icon: Icon(Icons.timer),
                              labelText: 'Klik Pilih Jam',
                            )),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0.0, primary: primarycolor),
                        onPressed: () {
                          showTimePicker(
                              context: context,
                              initialTime: timeSelected,
                              builder: (context, picker) => MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: picker!,
                                  )).then((value) {
                            if (value != null) {
                              _setTime = value.format(context).toString();
                              _tecJam.text = _setTime;
                            }
                          });
                        },
                        child: Text('Pilih Jam'),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      /// diganti jadi dropdown
                      // Container(
                      //   width: MediaQuery.of(context).size.width / 2.5,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Tipe :',
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
                              items: <String>[
                                '1',
                                '2',
                                '3'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value));
                              }).toList(),
                            );
                          }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Tipe :',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          StatefulBuilder(builder: (BuildContext context,
                              void Function(void Function()) setState) {
                            return DropdownButton(
                              dropdownColor: Colors.white,
                              value: _kategoriValue,
                              onChanged: (String? value) {
                                setState(() {
                                  _kategoriValue = value!;
                                });
                              },
                              items: <String>[
                                'Masalah',
                                'Maintenance'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value));
                              }).toList(),
                            );
                          }),
                        ],
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
                                  idmesin,
                                  "", // * nomesin tidak perlu dikirim di modal konfirmasi
                                  "", // * keterangan mesin tidak perlu di kirim di modal konfirmasi
                                  _tecMasalah.text.toString(),
                                  _tecTanggal.text.toString(),
                                  _tecJam.text.toString(),
                                  // _tecShift.text.toString(),
                                  _shiftValue.toString(),
                                  idmasalah,
                                  idpenyelesaian,
                                  _kategoriValue.toString(),
                                  flag_activity.toString());
                              // Navigator.of(context).pop();
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

// ++ BOTTOM MODAL UNTUK ACTION PER ITEM
  void modalActionItem(
      context,
      String tipe,
      String token,
      String idmesin,
      String nomesin,
      String keteranganmesin,
      String masalah,
      String tanggal,
      String jam,
      String shift,
      String idmasalah,
      String idpenyelesaian,
      String kategori,
      int status,
      String flag_activity) {
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
                    kategori + ' : ' + masalah,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text('No. Mesin: (' + nomesin + ') - ' + keteranganmesin,
                      style: TextStyle(fontSize: 16)),
                  Text('Tanggal: ' + tanggal.toString(),
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
                  // ++ filter jika status sudah selesai maka tombol edit masalah di hilangkan
                  status == 1
                      ? Container()
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            modalAddMasalah(
                                context,
                                tipe,
                                token,
                                idmesin,
                                nomesin,
                                keteranganmesin,
                                masalah,
                                tanggal,
                                jam,
                                shift,
                                idmasalah,
                                idpenyelesaian,
                                kategori,
                                status,
                                flag_activity);
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
                                child: Text('EDIT ACTIVITY',
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimelinePage(
                                      idmasalah: idmasalah,
                                    )));
                      },
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(width: 2, color: Colors.blue),
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
                            child: Text('TIMELINE ACTIVITY',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ))),
                  SizedBox(
                    height: 10,
                  ),
                  // ++ filter jika status sudah selesai maka tombol tambah progress dihilangkan
                  status == 1
                      ? Container()
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            BottomProgress().modalAddProgress(context, 'tambah',
                                token, idmasalah.toString(), "", "", "", "");
                          },
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(width: 2, color: primarycolor),
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
                                child: Text('TAMBAH PROGRESS',
                                    style: TextStyle(
                                      color: primarycolor,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ))),
                  SizedBox(
                    height: 10,
                  ),
                  status == 1
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            BottomCheckout().modalKonfirmasi(context, token,
                                'hapus', '', 'x', 'x', '', idpenyelesaian, '');
                            // _modalKonfirmasi(context, token, 'hapus',
                            //     idsite.toString(), nama, '-');
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
                                child: Text(
                                    // ++ filter jika status sudah selesai maka text di ubah menjadi hapus penyelesaian
                                    'HAPUS PENYELESAIAN ACTIVITY',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                              )))
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BarangPageSearch(
                                        masalah: masalah,
                                        tipe: 'tambahbarangselesai',
                                        idmasalah: idmasalah)));
                            // _modalKonfirmasi(context, token, 'hapus',
                            //     idsite.toString(), nama, '-');
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
                                child: Text(
                                    // ++ filter jika status sudah selesai maka text di ubah menjadi hapus penyelesaian
                                    'TAMBAH PENYELESAIAN',
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

// ++ MODAL UNTUK KONFIRMASI SEBELUM MELAKUKAN KONEKSI KE API
  void modalKonfirmasi(
      context,
      String tipe,
      String token,
      String idmesin,
      String nomesin,
      String keteranganmesin,
      String masalah,
      String tanggal,
      String jam,
      String shift,
      String idmasalah,
      String idpenyelesaian,
      String kategori,
      String flag_activity) {
    // * KONDISI UNTUK PENGECEKAN APAKAH NILAI/VALUE masalah, shift, tanggal, DAN jam SUDAH ADA VALUENYA APA BELUM
    if (masalah == "" || shift == "" || tanggal == "" || jam == "") {
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
                        Text('KONFIRMASI ' + tipe.toUpperCase() + ' ACTIVITY',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 20,
                        ),
                        tipe == 'hapus'
                            ? Text(
                                'Apakah anda yakin akan menghapus activity ' +
                                    masalah)
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
                                  // Navigator.pop(context);
                                  _actionToApi(
                                      context,
                                      tipe,
                                      token,
                                      idmesin,
                                      "", // * nomesin tidak perlu dikirim ke api
                                      "", // * keterangan mesin tidak perlu dikirim ke api
                                      masalah,
                                      tanggal,
                                      jam,
                                      shift,
                                      idmasalah,
                                      idpenyelesaian,
                                      kategori,
                                      flag_activity);
                                  Navigator.pop(context);
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
  void _actionToApi(
      context,
      String tipe,
      String token,
      String idmesin,
      String nomesin,
      String keteranganmesin,
      String masalah,
      String tanggal,
      String jam,
      String shift,
      String idmasalah,
      String idpenyelesaian,
      String kategori,
      String flag_activity) {
    MasalahModel addData = MasalahModel(
        masalah: masalah,
        tanggal: tanggal,
        jam: jam,
        shift: shift,
        idmesin: idmesin,
        jenis_masalah: kategori,
        flag_activity: flag_activity);
    if (tipe == 'tambah') {
      _apiService.addMasalah(token, addData).then((isSuccess) {
        if (isSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNavigation(
                      numberOfPage: 2,
                    )),
            (Route<dynamic> route) => false,
          );
          _tecMasalah.clear();
          _tecTanggal.clear();
          _tecJam.clear();
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
      });
      // .onError((error, stackTrace) {
      //   Fluttertoast.showToast(
      //       msg: '${_apiService.responseCode.messageApi}',
      //       backgroundColor: Colors.green);
      //   buttonSimpanHandler = true;
      //   //   ReusableClasses().modalbottomWarning(context, 'Gagal!',
      //   //       error.toString(), 'f4xx', 'assets/images/sorry.png');
      // });
    } else if (tipe == 'ubah') {
      _apiService.editMasalah(token, addData, idmasalah).then((isSuccess) {
        if (isSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNavigation(
                      numberOfPage: 2,
                    )),
            (Route<dynamic> route) => false,
          );
          _tecMasalah.clear();
          _tecTanggal.clear();
          _tecJam.clear();
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
      });
      // .onError((error, stackTrace) {
      //   ReusableClasses().modalbottomWarning(context, 'Gagal!',
      //       error.toString(), 'f4xx', 'assets/images/sorry.png');
      // });
    }
  }
}
