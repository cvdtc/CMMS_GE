import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/views/utils/bottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BottomChecklist {
  ApiService _apiService = new ApiService();
  // ++ MODAL UNTUK KONFIRMASI SEBELUM MELAKUKAN KONEKSI KE API
  void modalKonfirmasi(
    context,
    String token,
    String datalist,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),
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
                      Text('KONFIRMASI KOMPONEN CHECKLIST',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          'Apakah data yang ada masukkan sudah sesuai? note: Data tidak bisa di ubah.'),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  side: BorderSide(width: 2, color: Colors.red),
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
                                _actionToApi(context, token, datalist);
                              },
                              style: ElevatedButton.styleFrom(
                                  side:
                                      BorderSide(width: 2, color: Colors.green),
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

// ! KONEKSI KE API
  void _actionToApi(context, String token, String datalist) {
    _apiService.addDetChecklist(token, datalist).then((isSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => BottomNavigation(
                  numberOfPage: 2,
                )),
        (Route<dynamic> route) => false,
      );
      if (isSuccess) {
        Fluttertoast.showToast(
            msg: '${_apiService.responseCode.messageApi}',
            backgroundColor: Colors.green);
      }
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: '${error}', backgroundColor: Colors.red);
      // ReusableClasses().modalbottomWarning(context, 'Gagal!',
      //     error.toString(), 'f4xx', 'assets/images/sorry.png');
    });
  }
}
