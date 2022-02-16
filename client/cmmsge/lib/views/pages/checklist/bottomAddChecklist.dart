import 'package:cmmsge/services/models/checklist/checklist.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/checklist/komponenChecklist.dart';
import 'package:cmmsge/views/utils/bottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class BottomAddChecklist {
  // *
  ApiService _apiService = new ApiService();

  // * TEXT FORM VARIABLE
  final TextEditingController _tecDeskripsi = TextEditingController();
  final TextEditingController _tecKeterangan = TextEditingController();
  final TextEditingController _tecNoDokumen = TextEditingController();
  final TextEditingController _tecDikerjakanOleh = TextEditingController();
  final TextEditingController _tecDiperiksaOleh = TextEditingController();
  final TextEditingController _tecTanggalChecklist = TextEditingController();

  String tanggal_checklist = "";
  // * DATE AND TIME VARIABLE
  String _setDate = "";
  DateTime dateSelected = DateTime.now();

  bool buttonSimpanHandler = true;
  void modalAddChecklist(
      context,
      String token,
      String tipe,
      String deskripsi,
      String keterangan,
      String nodokumen,
      String dikerjakan_oleh,
      String diperiksa_oleh,
      String tanggal_checklist,
      String revisi,
      String idmesin,
      String nomesin,
      String ketmesin,
      String idchecklist) {
// * setting value text form field if action is edit
    if (tipe == 'ubah') {
      print(tanggal_checklist);
      _tecDeskripsi.value = TextEditingValue(
          text: deskripsi,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecDeskripsi.text.length)));
      _tecKeterangan.value = TextEditingValue(
          text: keterangan,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecKeterangan.text.length)));
      _tecNoDokumen.value = TextEditingValue(
          text: nodokumen,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecNoDokumen.text.length)));
      _tecTanggalChecklist.value = TextEditingValue(
          text: tanggal_checklist,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecTanggalChecklist.text.length)));
      _tecDikerjakanOleh.value = TextEditingValue(
          text: dikerjakan_oleh,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecDikerjakanOleh.text.length)));
      _tecDiperiksaOleh.value = TextEditingValue(
          text: diperiksa_oleh,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _tecDiperiksaOleh.text.length)));
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
          return SingleChildScrollView(
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tipe.toUpperCase() + ' CHECKLIST',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    tipe == 'ubah'
                        ? Container()
                        : Text('Mesin : (' + nomesin + ') ' + ketmesin,
                            style: TextStyle(
                              fontSize: 16,
                            )),
                    SizedBox(
                      height: 20.0,
                    ),
                    Card(
                      elevation: 3.0,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, bottom: 8.0, top: 8.0),
                        child: TextFormField(
                            controller: _tecNoDokumen,
                            cursorColor: thirdcolor,
                            decoration: const InputDecoration(
                              icon: Icon(
                                Icons.turned_in_not_rounded,
                                color: thirdcolor,
                              ),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              hintText: 'Nomor Dokumen',
                            )),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Card(
                      elevation: 3.0,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, bottom: 8.0, top: 8.0),
                        child: TextFormField(
                            controller: _tecDeskripsi,
                            cursorColor: thirdcolor,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(
                              icon: Icon(
                                Icons.description,
                                color: thirdcolor,
                              ),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              hintText: 'Deskripsi Checklist',
                            )),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Card(
                      elevation: 3.0,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, bottom: 8.0, top: 8.0),
                        child: TextFormField(
                            controller: _tecKeterangan,
                            cursorColor: thirdcolor,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(
                              icon: Icon(
                                Icons.note_add_outlined,
                                color: thirdcolor,
                              ),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              hintText: 'Keterangan',
                            )),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Card(
                      elevation: 3.0,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, bottom: 8.0, top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.8,
                              child: TextFormField(
                                  enabled: false,
                                  controller: _tecTanggalChecklist,
                                  onSaved: (String? val) {
                                    tanggal_checklist = val.toString();
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(
                                      Icons.date_range_rounded,
                                      color: thirdcolor,
                                    ),
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
                                                dialogBackgroundColor:
                                                    Colors.white),
                                            child: picker!);
                                      }).then((value) {
                                    if (value != null) {
                                      _setDate = DateFormat('yyyy-MM-dd')
                                          .format(value)
                                          .toString();
                                      _tecTanggalChecklist.text = _setDate;
                                    }
                                  });
                                },
                                child: Text('Pilih Tanggal'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Card(
                      elevation: 3.0,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, bottom: 8.0, top: 8.0),
                        child: TextFormField(
                            controller: _tecDikerjakanOleh,
                            cursorColor: thirdcolor,
                            decoration: const InputDecoration(
                              icon: Icon(
                                Icons.person_add,
                                color: thirdcolor,
                              ),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              hintText: 'Dikerjakan Oleh',
                            )),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Card(
                      elevation: 3.0,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, bottom: 8.0, top: 8.0),
                        child: TextFormField(
                            controller: _tecDiperiksaOleh,
                            cursorColor: thirdcolor,
                            decoration: const InputDecoration(
                              icon: Icon(
                                Icons.person_rounded,
                                color: thirdcolor,
                              ),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              hintText: 'Diperiksa Oleh',
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        modalKonfirmasi(
                            context,
                            token,
                            tipe,
                            _tecDeskripsi.text.toString(),
                            _tecKeterangan.text.toString(),
                            _tecNoDokumen.text.toString(),
                            _tecDikerjakanOleh.text.toString(),
                            _tecDiperiksaOleh.text.toString(),
                            _tecTanggalChecklist.text.toString(),
                            revisi,
                            idmesin,
                            nomesin,
                            ketmesin,
                            idchecklist);
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 4.0,
                          shadowColor: thirdcolor,
                          primary: thirdcolor),
                      child: Ink(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Container(
                          width: 325,
                          height: 55,
                          alignment: Alignment.center,
                          child: const Text(
                            'BUAT CHECKLIST',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  // ++ BOTTOM MODAL UNTUK ACTION PER ITEM
  void modalActionItem(
      context,
      String token,
      String tipe,
      String deskripsi,
      String keterangan,
      String nodokumen,
      String dikerjakan_oleh,
      String diperiksa_oleh,
      String tanggal_checklist,
      String revisi,
      String idmesin,
      String nomesin,
      String ketmesin,
      String idchecklist) {
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
                  Text('No. Dokumen: ' + nodokumen.toString(),
                      style: TextStyle(fontSize: 16)),
                  Text('Deskripsi : ' + deskripsi,
                      style: TextStyle(fontSize: 16)),
                  Text('Keterangan : ' + keterangan.toString(),
                      style: TextStyle(fontSize: 16)),
                  Text('Dikerjakan Oleh : ' + dikerjakan_oleh.toString(),
                      style: TextStyle(fontSize: 16)),
                  Text('Diperiksa Oleh : ' + diperiksa_oleh.toString(),
                      style: TextStyle(fontSize: 16)),
                  Text('Tanggal Checklist : ' + tanggal_checklist.toString(),
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
                        modalAddChecklist(
                            context,
                            token,
                            tipe,
                            deskripsi,
                            keterangan,
                            nodokumen,
                            dikerjakan_oleh,
                            diperiksa_oleh,
                            tanggal_checklist,
                            revisi,
                            idmesin,
                            nomesin,
                            ketmesin,
                            idchecklist);
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
                            child: Text('EDIT CHECKLIST',
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
                            token,
                            tipe,
                            deskripsi,
                            keterangan,
                            nodokumen,
                            dikerjakan_oleh,
                            diperiksa_oleh,
                            tanggal_checklist,
                            revisi,
                            idmesin,
                            nomesin,
                            ketmesin,
                            idchecklist);
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
                            child: Text('HAPUS CHECKLIST',
                                style: TextStyle(
                                  color: Colors.red,
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
                            token,
                            'hapuskomponen',
                            deskripsi,
                            keterangan,
                            nodokumen,
                            dikerjakan_oleh,
                            diperiksa_oleh,
                            tanggal_checklist,
                            revisi,
                            idmesin,
                            nomesin,
                            ketmesin,
                            idchecklist);
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
                            child: Text('TAMBAH/UBAH KOMPONEN CHECKLIST',
                                style: TextStyle(
                                  color: Colors.green,
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
      String token,
      String tipe,
      String deskripsi,
      String keterangan,
      String nodokumen,
      String dikerjakan_oleh,
      String diperiksa_oleh,
      String tanggal_checklist,
      String revisi,
      String idmesin,
      String nomesin,
      String ketmesin,
      String idchecklist) {
    // * KONDISI UNTUK PENGECEKAN APAKAH NILAI/VALUE masalah, shift, tanggal, DAN jam SUDAH ADA VALUENYA APA BELUM
    if (deskripsi == "" ||
        keterangan == "" ||
        nodokumen == "" ||
        dikerjakan_oleh == "" ||
        diperiksa_oleh == "" ||
        tanggal_checklist == "") {
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
                                'Apakah anda yakin akan menghapus checklist ' +
                                    deskripsi)
                            : tipe == 'hapuskomponen'
                                ? Text(
                                    'Apakah anda yakin akan menghapus komponen checklist ' +
                                        deskripsi)
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
                                      token,
                                      tipe,
                                      deskripsi,
                                      keterangan,
                                      nodokumen,
                                      dikerjakan_oleh,
                                      diperiksa_oleh,
                                      tanggal_checklist,
                                      revisi,
                                      idmesin,
                                      nomesin,
                                      ketmesin,
                                      idchecklist);
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
      String token,
      String tipe,
      String deskripsi,
      String keterangan,
      String nodokumen,
      String dikerjakan_oleh,
      String diperiksa_oleh,
      String tanggal_checklist,
      String revisi,
      String idmesin,
      String nomesin,
      String ketmesin,
      String idchecklist) {
    ChecklistModel addData = ChecklistModel(
        deskripsi: deskripsi,
        keterangan: keterangan,
        no_dokumen: nodokumen,
        dikerjakan_oleh: dikerjakan_oleh,
        diperiksa_oleh: diperiksa_oleh,
        tanggal_checklist: tanggal_checklist,
        revisi: revisi,
        idmesin: idmesin);
    print(addData.toString() + tipe);
    if (tipe == 'tambah') {
      _apiService.addChecklist(token, addData).then((idcheckout) async {
        print('HASIL??' + idcheckout.toString());
        if (idcheckout > 0) {
          print("idcheckout?" + idcheckout.toString() + idmesin.toString());
          await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => KomponenChecklistPage(
                    idchecklist: idcheckout.toString(),
                    idmesin: idmesin,
                    token: token)),
            (Route<dynamic> route) => false,
          );
          _tecDeskripsi.clear();
          _tecKeterangan.clear();
          _tecNoDokumen.clear();
          _tecTanggalChecklist.clear();
          _tecDikerjakanOleh.clear();
          _tecDiperiksaOleh.clear();
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
          .editChecklist(token, addData, idchecklist)
          .then((isSuccess) async {
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
      _apiService.deleteChecklist(token, idchecklist).then((isSuccess) async {
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
        }
      }).onError((error, stackTrace) {
        print(
            'Error HAPUS Checklist' + error.toString() + stackTrace.toString());
        Fluttertoast.showToast(
            msg: '${_apiService.responseCode.messageApi}',
            backgroundColor: Colors.green);
        buttonSimpanHandler = true;
      });
    } else if (tipe == 'hapuskomponen') {
      _apiService
          .deleteDetChecklist(token, idchecklist)
          .then((isSuccess) async {
        if (isSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => KomponenChecklistPage(
                    idchecklist: idchecklist, idmesin: idmesin, token: token)),
            (Route<dynamic> route) => false,
          );
          Fluttertoast.showToast(
              msg: '${_apiService.responseCode.messageApi}',
              backgroundColor: Colors.green);
          buttonSimpanHandler = true;
        }
      }).onError((error, stackTrace) {
        Fluttertoast.showToast(
            msg: '${_apiService.responseCode.messageApi}',
            backgroundColor: Colors.green);
        buttonSimpanHandler = true;
      });
    }
  }
}
