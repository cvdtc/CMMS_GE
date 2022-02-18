import 'dart:ui';

import 'package:cmmsge/services/models/site/siteModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/mesin/mesinwithsearch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class BottomFilter {
  /// jenis activity digunakan untuk flag transaksi activity atau preactivity 0: preactivity 1: activity
  int jenisactivity = 0;

  /// setting first value datetime for syncfusion date range
  DateTime _startDate = DateTime.now(), _endDate = DateTime.now();

  /// convertinf datetime format to customized format using string
  String _conversionDateStart = '', _conversionDateEnd = '';
  var datamodelsite;
  bool isLoading = true;
  late SharedPreferences sp;
  String token = "";

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    token = sp.getString("access_token")!;
  }

  Future<List<SiteModel>?> siteModel = ApiService().getSite(
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZHBlbmdndW5hIjoxMCwiZGV2aWNlIjoibW9iaWxlIiwiYXBwdmVyc2lvbiI6My4xLCJ1dWlkIjoiUktRMS4yMDA4MjYuMDAyIiwiaWF0IjoxNjQ1MTAxNTcwLCJleHAiOjE2NDUxODc5NzB9.Dg_8SdALueXEQBxvWLp1oaim18H0hcPSteuOr1L9nfo');
  bottomfilterModal(context, String transaksi) async {
    print('?' + datamodelsite.toString());
    print('?c' + siteModel.toString());
    transaksi == 'activity' ? jenisactivity = 1 : jenisactivity = 0;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              ///checking token from sharedpreferences
              // cekToken() async {
              //   sp = await SharedPreferences.getInstance();
              //   setState(() {
              //     token = sp.getString("access_token");
              //   });
              // }

              ///load data from json
              // ApiService()
              //     .getSite(
              //         'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZHBlbmdndW5hIjoxMCwiZGV2aWNlIjoibW9iaWxlIiwiYXBwdmVyc2lvbiI6My4xLCJ1dWlkIjoiUktRMS4yMDA4MjYuMDAyIiwiaWF0IjoxNjQ1MTAxNTcwLCJleHAiOjE2NDUxODc5NzB9.Dg_8SdALueXEQBxvWLp1oaim18H0hcPSteuOr1L9nfo')
              //     .then((value) async {
              //   setState(() {
              //     datamodelsite = value;
              //     isLoading = false;
              //     ApiService().client.close();
              //   });
              // });
              // datamodelsite != null
              //     ? setState(() {
              //         print('xxxx' + datamodelsite.toString());
              //         isLoading = false;
              //       })
              //     : setState(() {
              //         print('xxxx2' + datamodelsite.toString());
              //         isLoading == true;
              //       });
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
                          'Filter data ' + transaksi.toString(),
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        isLoading ? CircularProgressIndicator() : Container(),
                        // : DropdownButton(
                        //     hint: Text("Pilih Site"),
                        //     value: _valProvince,
                        //     items: _dataProvince.map((item) {
                        //       return DropdownMenuItem(
                        //         child: Text(item['province']),
                        //         value: item['province'],
                        //       );
                        //     }).toList(),
                        //     onChanged: (value) {
                        //       setState(() {
                        //         _valProvince = value;
                        //       });
                        //     },
                        //   ),

                        /// kendalanya load api terus
                        // Container(
                        //     child: SingleChildScrollView(
                        //       scrollDirection: Axis.horizontal,
                        //       child: Row(
                        //         children: [
                        //           Text(
                        //             'Site :',
                        //             style: TextStyle(fontSize: 18.0),
                        //           ),
                        //           SizedBox(
                        //             width: 12.0,
                        //           ),
                        //           ElevatedButton(
                        //               onPressed: () {
                        //                 print(datamodelsite);
                        //               },
                        //               style: ElevatedButton.styleFrom(
                        //                   side: BorderSide(
                        //                       width: 2,
                        //                       color: Colors.orange),
                        //                   elevation: 3.0,
                        //                   shape: RoundedRectangleBorder(
                        //                       borderRadius:
                        //                           BorderRadius.circular(
                        //                               15)),
                        //                   primary: Colors.white),
                        //               child: Ink(
                        //                   decoration: BoxDecoration(
                        //                       borderRadius:
                        //                           BorderRadius.circular(
                        //                               18.0)),
                        //                   child: Container(
                        //                     width: 75,
                        //                     height: 15,
                        //                     alignment: Alignment.center,
                        //                     child: Text('Semua',
                        //                         style: TextStyle(
                        //                           color: Colors.orange,
                        //                           fontSize: 12.0,
                        //                           fontWeight:
                        //                               FontWeight.bold,
                        //                         )),
                        //                   ))),
                        //           SizedBox(
                        //             width: 5,
                        //           ),
                        //           ElevatedButton(
                        //               onPressed: () {},
                        //               style: ElevatedButton.styleFrom(
                        //                   side: BorderSide(
                        //                       width: 2, color: Colors.blue),
                        //                   elevation: 3.0,
                        //                   shape: RoundedRectangleBorder(
                        //                       borderRadius:
                        //                           BorderRadius.circular(
                        //                               15)),
                        //                   primary: Colors.white),
                        //               child: Ink(
                        //                   decoration: BoxDecoration(
                        //                       borderRadius:
                        //                           BorderRadius.circular(
                        //                               18.0)),
                        //                   child: Container(
                        //                     width: 75,
                        //                     height: 15,
                        //                     alignment: Alignment.center,
                        //                     child: Text('Site 1',
                        //                         style: TextStyle(
                        //                           color: Colors.blue,
                        //                           fontSize: 12.0,
                        //                           fontWeight:
                        //                               FontWeight.bold,
                        //                         )),
                        //                   ))),
                        //           SizedBox(
                        //             width: 5,
                        //           ),
                        //           ElevatedButton(
                        //               onPressed: () {},
                        //               style: ElevatedButton.styleFrom(
                        //                   side: BorderSide(
                        //                       width: 2,
                        //                       color: Colors.green),
                        //                   elevation: 3.0,
                        //                   shape: RoundedRectangleBorder(
                        //                       borderRadius:
                        //                           BorderRadius.circular(
                        //                               15)),
                        //                   primary: Colors.white),
                        //               child: Ink(
                        //                   decoration: BoxDecoration(
                        //                       borderRadius:
                        //                           BorderRadius.circular(
                        //                               18.0)),
                        //                   child: Container(
                        //                     width: 75,
                        //                     height: 15,
                        //                     alignment: Alignment.center,
                        //                     child: Text('Site 2',
                        //                         style: TextStyle(
                        //                           color: Colors.green,
                        //                           fontSize: 12.0,
                        //                           fontWeight:
                        //                               FontWeight.bold,
                        //                         )),
                        //                   ))),
                        //           ElevatedButton(
                        //               onPressed: () {},
                        //               style: ElevatedButton.styleFrom(
                        //                   side: BorderSide(
                        //                       width: 2,
                        //                       color: Colors.orange),
                        //                   elevation: 3.0,
                        //                   shape: RoundedRectangleBorder(
                        //                       borderRadius:
                        //                           BorderRadius.circular(
                        //                               15)),
                        //                   primary: Colors.white),
                        //               child: Ink(
                        //                   decoration: BoxDecoration(
                        //                       borderRadius:
                        //                           BorderRadius.circular(
                        //                               18.0)),
                        //                   child: Container(
                        //                     width: 75,
                        //                     height: 15,
                        //                     alignment: Alignment.center,
                        //                     child: Text('Site 3',
                        //                         style: TextStyle(
                        //                           color: Colors.orange,
                        //                           fontSize: 12.0,
                        //                           fontWeight:
                        //                               FontWeight.bold,
                        //                         )),
                        //                   ))),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        Container(
                          child: Row(
                            children: [
                              Text(
                                'Tanggal :',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              SizedBox(
                                width: 12.0,
                              ),
                              Container(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0.0, primary: primarycolor),
                                  onPressed: () {
                                    showDialog(
                                        useSafeArea: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SfDateRangePicker(
                                            initialSelectedRange:
                                                PickerDateRange(
                                                    _startDate.subtract(
                                                        Duration(days: 4)),
                                                    _endDate.subtract(
                                                        Duration(days: 4))),
                                            backgroundColor: Colors.white,
                                            onSelectionChanged:
                                                _onSelectionChanged,
                                            selectionMode:
                                                DateRangePickerSelectionMode
                                                    .range,
                                            showActionButtons: true,
                                            onSubmit: (value) {
                                              setState(() {});
                                              print(value);
                                              print(_conversionDateStart +
                                                  ' | ' +
                                                  _conversionDateEnd);
                                              Navigator.pop(context);
                                            },
                                          );
                                        });
                                  },
                                  child: Text('Pilih Tanggal'),
                                ),
                              ),
                              SizedBox(
                                width: 12.0,
                              ),
                              _conversionDateStart == ''
                                  ? Container()
                                  : Column(
                                      children: [
                                        Text(_conversionDateStart),
                                        Text(' s/d '),
                                        Text(_conversionDateEnd),
                                      ],
                                    )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {},
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
                                  child: Text('T E R A P K A N',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ))),
                        SizedBox(
                          height: 10.0,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MesinSearchPage(
                                          transaksi: transaksi,
                                          flag_activity:
                                              jenisactivity.toString())));
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
                                  child: Text('TAMBAH ACTIVITY',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ))),
                      ],
                    )),
              );
            },
          );
        });
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      /// handler if variable _startdate or _enddate null value
      _startDate == null
          ? _startDate = DateTime.now()
          : _endDate == null
              ? _endDate = DateTime.now()
              : _endDate = args.value.endDate;

      /// getting value from selected date syncfusion
      _startDate = args.value.startDate;
      _endDate = args.value.endDate;

      /// converting value _startdate and _enddate to string and date format!
      _conversionDateStart =
          DateFormat('yyyy-MM-dd').format(_startDate).toString();
      _conversionDateEnd = DateFormat('yyyy-MM-dd').format(_endDate).toString();
    } else {
      final List<PickerDateRange> selectedRanges = args.value;
    }
  }
}
