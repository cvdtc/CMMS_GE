import 'package:cmmsge/services/models/komponen/KomponenModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/utils/bottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BottomKomponen {
  // *
  ApiService _apiService = new ApiService();

  // * TEXT FORM VARIABLE
  TextEditingController _tecNamaKomponen = TextEditingController(text: "");
  TextEditingController _tecKeteranganKomponen =
      TextEditingController(text: "");
  TextEditingController _tecJumlahReminder = TextEditingController(text: "");

  bool buttonSimpanHandler = true;

  // * INITIAL DROPDOWNBUTTON
  String _kategoriValue = 'Electrical';
  // * INITIAL CHECKBOX
  bool isChecked = false;
  int valueflag_reminder = 0;

  // ++ BOTTOM MODAL UNTUK INPUT DATA
  void modalFormKomponen(
      context,
      String tipe,
      String token,
      String nama,
      String kategori,
      String keterangan,
      String flag_reminder,
      String jumlah_reminder,
      String idmesin,
      String idkomponen) {
    // * setting value text form field if action is edit
    if (tipe == 'ubah') {
      _tecNamaKomponen.value = TextEditingValue(
          text: nama,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecNamaKomponen.text.length)));
      _tecKeteranganKomponen.value = TextEditingValue(
          text: keterangan,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecKeteranganKomponen.text.length)));
      _tecJumlahReminder.value = TextEditingValue(
          text: jumlah_reminder,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecJumlahReminder.text.length)));
      _kategoriValue = kategori;
      isChecked = flag_reminder == '1' ? true : false;
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
                    tipe.toUpperCase() + ' KOMPONEN',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                      controller: _tecNamaKomponen,
                      decoration: InputDecoration(
                          icon: Icon(Icons.warning_amber_rounded),
                          labelText: 'Nama Komponen',
                          hintText: 'Nama Komponen')),
                  TextFormField(
                      controller: _tecKeteranganKomponen,
                      decoration: InputDecoration(
                          icon: Icon(Icons.note),
                          labelText: 'Keterangan Komponen',
                          hintText: 'Keterangan Komponen')),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: StatefulBuilder(
                              builder: (BuildContext context,
                                  void Function(void Function()) setState) {
                                return Checkbox(
                                  activeColor: thirdcolor,
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                      isChecked
                                          ? valueflag_reminder = 1
                                          : valueflag_reminder = 0;
                                      print(value);
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          Text('Reminder', style: TextStyle(fontSize: 16.0)),
                        ],
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              'Kategori :',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(
                              width: 15.0,
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
                                  'Electrical',
                                  'Mechanical'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                      value: value, child: Text(value));
                                }).toList(),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                      controller: _tecJumlahReminder,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                          icon: Icon(Icons.wb_sunny_rounded),
                          labelText: 'Jumlah Reminder dalam hari')),
                  SizedBox(
                    height: 25.0,
                  ),
                  ElevatedButton(
                      onPressed: buttonSimpanHandler
                          ? () {
                              // Navigator.pop(context);
                              modalKonfirmasi(
                                  context,
                                  tipe,
                                  token,
                                  _tecNamaKomponen.text.toString(),
                                  _kategoriValue.toString(),
                                  _tecKeteranganKomponen.text.toString(),
                                  valueflag_reminder.toString(),
                                  _tecJumlahReminder.text.toString(),
                                  idmesin,
                                  idkomponen);
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
      String nama,
      String kategori,
      String keterangan,
      String flag_reminder,
      String jumlah_reminder,
      String idmesin,
      String idkomponen) {
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
                  Text('Nama: ' + nama.toString(),
                      style: TextStyle(fontSize: 16)),
                  Text('Kategori : ' + kategori,
                      style: TextStyle(fontSize: 16)),
                  Text('Keterangan : ' + keterangan.toString(),
                      style: TextStyle(fontSize: 16)),
                  Text(
                      'Reminder : ' + flag_reminder == '0'
                          ? 'Tidak'
                          : jumlah_reminder.toString(),
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
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        modalFormKomponen(
                            context,
                            tipe,
                            token,
                            nama,
                            kategori,
                            keterangan,
                            flag_reminder,
                            jumlah_reminder,
                            idmesin,
                            idkomponen);
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
                            child: Text('EDIT KOMPONEN',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ))),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        modalKonfirmasi(
                            context,
                            'hapus',
                            token,
                            nama,
                            kategori,
                            keterangan,
                            flag_reminder,
                            jumlah_reminder,
                            idmesin,
                            idkomponen);
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
                            child: Text('HAPUS KOMPONEN',
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
      String nama,
      String kategori,
      String keterangan,
      String flag_reminder,
      String jumlah_reminder,
      String idmesin,
      String idkomponen) {
    print(token +
        ' | ' +
        nama +
        ' | ' +
        kategori +
        ' | ' +
        keterangan +
        ' | ' +
        flag_reminder +
        ' | ' +
        jumlah_reminder +
        ' | ' +
        idmesin +
        ' | ' +
        idkomponen);
    // * KONDISI UNTUK PENGECEKAN APAKAH NILAI/VALUE masalah, shift, tanggal, DAN jam SUDAH ADA VALUENYA APA BELUM
    if (nama == "" ||
        keterangan == "" ||
        kategori == "" ||
        flag_reminder == "" ||
        jumlah_reminder == "" ||
        idmesin == "") {
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
                        Text('KONFIRMASI ' + tipe.toUpperCase() + ' CHECKLIST',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 20,
                        ),
                        tipe == 'hapus'
                            ? Text(
                                'Apakah anda yakin akan menghapus Komponen ' +
                                    nama)
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
                                      nama,
                                      kategori,
                                      keterangan,
                                      flag_reminder,
                                      jumlah_reminder,
                                      idmesin,
                                      idkomponen);
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
  void _actionToApi(
      context,
      String tipe,
      String token,
      String nama,
      String kategori,
      String keterangan,
      String flag_reminder,
      String jumlah_reminder,
      String idmesin,
      String idkomponen) {
    KomponenModel addData = KomponenModel(
        nama: nama,
        keterangan: keterangan,
        kategori: kategori,
        flag_reminder: flag_reminder,
        jumlah_reminder: jumlah_reminder,
        idmesin: idmesin);
    print(addData.toString() + tipe);
    if (tipe == 'tambah') {
      _apiService.addKomponen(token, addData).then((isSuccess) async {
        if (isSuccess) {
          await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNavigation(
                      numberOfPage: 2,
                    )),
            (Route<dynamic> route) => false,
          );
          _tecNamaKomponen.clear();
          _tecKeteranganKomponen.clear();
          _tecJumlahReminder.clear();
          Fluttertoast.showToast(
              msg: '${_apiService.responseCode.messageApi}',
              backgroundColor: Colors.green);
          buttonSimpanHandler = true;
        } else {
          Fluttertoast.showToast(
              msg: '${_apiService.responseCode.messageApi}',
              backgroundColor: Colors.green);
          buttonSimpanHandler = true;
        }
      }).onError((error, stackTrace) {
        print('Error Checklist' + error.toString() + stackTrace.toString());
        Fluttertoast.showToast(
            msg: '${_apiService.responseCode.messageApi}',
            backgroundColor: Colors.green);
        buttonSimpanHandler = true;
        // ReusableClasses().modalbottomWarning(context, 'Gagal!',
        //     error.toString(), 'f4xx', 'assets/images/sorry.png');
      });
    } else if (tipe == 'ubah') {
      _apiService
          .editKomoponen(token, addData, idkomponen)
          .then((isSuccess) async {
        if (isSuccess) {
          await Navigator.pushAndRemoveUntil(
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
        }
      }).onError((error, stackTrace) {
        print(
            'Error UBAH Checklist' + error.toString() + stackTrace.toString());
        Fluttertoast.showToast(
            msg: '${_apiService.responseCode.messageApi}',
            backgroundColor: Colors.green);
        buttonSimpanHandler = true;
      });
    } else if (tipe == 'hapus') {
      _apiService.deleteKomponen(token, idkomponen).then((isSuccess) async {
        if (isSuccess) {
          await Navigator.pushAndRemoveUntil(
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
        }
      }).onError((error, stackTrace) {
        print(
            'Error HAPUS Checklist' + error.toString() + stackTrace.toString());
        Fluttertoast.showToast(
            msg: '${_apiService.responseCode.messageApi}',
            backgroundColor: Colors.green);
        buttonSimpanHandler = true;
      });
    }
  }
}
