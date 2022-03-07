import 'dart:ui';

import 'package:cmmsge/services/models/site/siteModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/masalah/masalahwithsearch.dart';
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
  String _conversionDateStart = '0';
  String _conversionDateEnd = '0';

  /// dropdown value for site
  int dropdownSiteValue = 0;
  String textSiteValue = "";

  bottomfilterModal(
      context, String transaksi, List<SiteModel> siteModel) async {
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
                        Row(
                          children: [
                            Text(
                              'Pilih Site : ',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            SizedBox(
                              width: 12.0,
                            ),
                            Container(
                              child: DropdownButton(
                                dropdownColor: Colors.white,
                                hint: Text("Semua Site"),
                                items: siteModel.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item.nama),
                                    value: item.idsite,
                                    onTap: () {
                                      setState(() {
                                        textSiteValue = item.nama;
                                      });
                                    },
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    print(value);
                                    dropdownSiteValue =
                                        int.parse(value.toString());
                                  });
                                },
                                // value: 0,
                              ),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),

                            /// handler when dropdown site null value
                            dropdownSiteValue != ""

                                /// filter dropdown site when id is 0 it's mean all site
                                ? dropdownSiteValue == 0
                                    ? Text(
                                        'Site : SEMUA SITE',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        'Site : ' + textSiteValue.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                : Container(),
                          ],
                        ),
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
                                        Text(
                                            _conversionDateStart == '0'
                                                ? 'Semua'
                                                : _conversionDateStart,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(' s/d '),
                                        Text(
                                            _conversionDateEnd == '0'
                                                ? 'Semua'
                                                : _conversionDateEnd,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (dropdownSiteValue == "" ||
                                  _conversionDateStart == "" ||
                                  _conversionDateEnd == "") {
                                ReusableClasses().modalbottomWarning(
                                    context,
                                    'Pilih Filter',
                                    'harap pilih filter data terlebih dahulu!',
                                    'f400',
                                    'assets/images/sorry.png');
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MasalahPageSearch(
                                              jenisActivity: 1,
                                              idsite: dropdownSiteValue,
                                              start_date: _conversionDateStart,
                                              end_date: _conversionDateEnd,
                                            )));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: thirdcolor,
                              elevation: 3.0,
                            ),
                            child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18.0)),
                                child: Container(
                                  width: 325,
                                  height: 45,
                                  alignment: Alignment.center,
                                  child: Text('T E R A P K A N',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ))),
                        SizedBox(
                          height: 10.0,
                        ),
                        Divider(
                          thickness: 1.0,
                        ),
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
                                  child: Text('BUAT ACTIVITY',
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
