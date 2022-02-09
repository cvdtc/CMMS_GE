import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:flutter/material.dart';

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

  // ++ BOTTOM MODAL UNTUK INPUT DATA
  void modalFormKomponen(
    context,
    String tipe,
    String token,
    String idmesin,
    String idkomponen,
    String nama,
    String kategori,
    String keterangan,
    String flag_reminder,
    String jumlah_reminder,
  ) {
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
                  StatefulBuilder(builder: (BuildContext context,
                      void Function(void Function()) setState) {
                    return Container(
                      child: isChecked == true
                          ? TextFormField(
                              controller: _tecJumlahReminder,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.note),
                                  labelText: 'Jumlah Reminder dalam hari'))
                          : SizedBox(
                              height: 10.0,
                            ),
                    );
                  }),
                  SizedBox(
                    height: 25.0,
                  ),
                  ElevatedButton(
                      onPressed: buttonSimpanHandler
                          ? () {
                              Navigator.pop(context);
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
}
