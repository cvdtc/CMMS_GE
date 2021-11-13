import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/timeline/timelinepage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BottomMasalah {
  ApiService _apiService = new ApiService();
  TextEditingController _tecMasalah = TextEditingController(text: "");
  TextEditingController _tecTanggal = TextEditingController(text: "");
  TextEditingController _tecJam = TextEditingController(text: "");
  TextEditingController _tecShift = TextEditingController(text: "");
  String _setTime = "", _setDate = "", tanggal = "";
  String _hour = "", _minute = "", _time = "";
  String dateTime = "";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2021),
        lastDate: DateTime(2024));
    if (picked != null) {
      selectedDate = picked;
      _tecTanggal.text = DateFormat.yMd().format(selectedDate);
    }
  }

  // ++ BOTTOM MODAL ACTION ITEM
  void modalActionItem(context, token, String masalah, String nomesin,
      String ketmesin, String idmasalah) {
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
                    'Masalah : ' + masalah,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text('No. Mesin: ' + nomesin, style: TextStyle(fontSize: 16)),
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
                        // modalAddSite(
                        //     context, 'ubah', token, nama, keterangan, idsite);
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
                            child: Text('EDIT MASALAH',
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
                            child: Text('TIMELINE MASALAH',
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
                        // modalAddSite(
                        //     context, 'ubah', token, nama, keterangan, idsite);
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
                  ElevatedButton(
                      onPressed: () {
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
                            child: Text('HAPUS PENYELESAIAN MASALAH',
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

  // ++ BOTTOM MODAL INPUT FORM
  void modalAddMasalah(
      context,
      String tipe,
      String token,
      String nomesin,
      String keterangan,
      String masalah,
      String tanggal,
      String jam,
      String shift,
      String idmasalah) {
    print("IDMASALAH?" + idmasalah.toString());
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
      _tecShift.value = TextEditingValue(
          text: shift,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecShift.text.length)));
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
                    tipe.toUpperCase() + ' MASALAH',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Flexible(
                      child: Text('Mesin : (' + nomesin + ') ' + keterangan,
                          style: TextStyle(
                            fontSize: 16,
                          ))),
                  TextFormField(
                      controller: _tecMasalah,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                          icon: Icon(Icons.warning_amber_rounded),
                          labelText: 'Nama Masalah',
                          hintText: 'Masukkan Masalah',
                          suffixIcon:
                              Icon(Icons.check_circle_outline_outlined))),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onDoubleTap: () {
                          _selectedDate(context);
                        },
                        child: TextFormField(
                            controller: _tecTanggal,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              icon: Icon(Icons.date_range_rounded),
                              labelText: 'Double tap untuk pilih tanggal',
                              hintText: 'Masukkan Keterangan',
                            )),
                      ),
                      InkWell(
                        onDoubleTap: () {
                          _selectedDate(context);
                        },
                        child: TextFormField(
                            controller: _tecTanggal,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              icon: Icon(Icons.date_range_rounded),
                              labelText: 'Double tap untuk pilih jam',
                              hintText: 'Masukkan Keterangan',
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _selectedDate(context);
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
}
