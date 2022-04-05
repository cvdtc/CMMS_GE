// ! NOT USED BCZ USING BOTTOM MODAL FORM

// import 'package:cmmsge/utils/warna.dart';
// import 'package:cmmsge/views/pages/checklist/komponenChecklist.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class AddChecklistPage extends StatefulWidget {
//   String idmesin, nomesin, ketmesin;
//   AddChecklistPage(
//       {required this.idmesin, required this.nomesin, required this.ketmesin});

//   @override
//   State<AddChecklistPage> createState() => _AddChecklistPageState();
// }

// class _AddChecklistPageState extends State<AddChecklistPage> {
//   final TextEditingController _tecDeskripsi = TextEditingController();
//   final TextEditingController _tecKeterangan = TextEditingController();
//   final TextEditingController _tecNoDokumen = TextEditingController();
//   final TextEditingController _tecDikerjakanOleh = TextEditingController();
//   final TextEditingController _tecDiperiksaOleh = TextEditingController();
//   final TextEditingController _tecTanggalChecklist = TextEditingController();

//   String idmesin = "", nomesin = "", ketmesin = "", tanggalchecklist = "";
//   // * DATE AND TIME VARIABLE
//   String _setDate = "";
//   DateTime dateSelected = DateTime.now();

//   @override
//   void initState() {
//     idmesin = widget.idmesin;
//     nomesin = widget.nomesin;
//     ketmesin = widget.ketmesin;
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: thirdcolor,
//         title: Text('Buat Checklist'),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.all(12.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Card(
//                 elevation: 3.0,
//                 shadowColor: Colors.grey,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       left: 12.0, right: 12.0, bottom: 8.0, top: 8.0),
//                   child: TextFormField(
//                       controller: _tecNoDokumen,
//                       cursorColor: thirdcolor,
//                       decoration: const InputDecoration(
//                         icon: Icon(
//                           Icons.turned_in_not_rounded,
//                           color: thirdcolor,
//                         ),
//                         border: InputBorder.none,
//                         fillColor: Colors.white,
//                         focusColor: Colors.white,
//                         hintText: 'Nomor Dokumen',
//                       )),
//                 ),
//               ),
//               SizedBox(height: 8.0),
//               Card(
//                 elevation: 3.0,
//                 shadowColor: Colors.grey,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       left: 12.0, right: 12.0, bottom: 8.0, top: 8.0),
//                   child: TextFormField(
//                       controller: _tecDeskripsi,
//                       cursorColor: thirdcolor,
//                       keyboardType: TextInputType.multiline,
//                       maxLines: null,
//                       decoration: const InputDecoration(
//                         icon: Icon(
//                           Icons.description,
//                           color: thirdcolor,
//                         ),
//                         border: InputBorder.none,
//                         fillColor: Colors.white,
//                         focusColor: Colors.white,
//                         hintText: 'Deskripsi Checklist',
//                       )),
//                 ),
//               ),
//               SizedBox(height: 8.0),
//               Card(
//                 elevation: 3.0,
//                 shadowColor: Colors.grey,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       left: 12.0, right: 12.0, bottom: 8.0, top: 8.0),
//                   child: TextFormField(
//                       controller: _tecKeterangan,
//                       cursorColor: thirdcolor,
//                       keyboardType: TextInputType.multiline,
//                       maxLines: null,
//                       decoration: const InputDecoration(
//                         icon: Icon(
//                           Icons.note_add_outlined,
//                           color: thirdcolor,
//                         ),
//                         border: InputBorder.none,
//                         fillColor: Colors.white,
//                         focusColor: Colors.white,
//                         hintText: 'Keterangan',
//                       )),
//                 ),
//               ),
//               SizedBox(height: 8.0),
//               Card(
//                 elevation: 3.0,
//                 shadowColor: Colors.grey,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       left: 12.0, right: 12.0, bottom: 8.0, top: 8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: MediaQuery.of(context).size.width / 1.8,
//                         child: TextFormField(
//                             enabled: false,
//                             controller: _tecTanggalChecklist,
//                             onSaved: (String? val) {
//                               tanggalchecklist = val.toString();
//                             },
//                             decoration: InputDecoration(
//                               icon: Icon(
//                                 Icons.date_range_rounded,
//                                 color: thirdcolor,
//                               ),
//                               labelText: 'Klik Pilih Tanggal',
//                             )),
//                       ),
//                       Container(
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               elevation: 0.0, primary: primarycolor),
//                           onPressed: () {
//                             showDatePicker(
//                                 context: context,
//                                 initialDate: dateSelected,
//                                 firstDate: DateTime(2020),
//                                 lastDate: DateTime(2029),
//                                 builder: (context, picker) {
//                                   return Theme(
//                                       data: ThemeData.dark().copyWith(
//                                           colorScheme: ColorScheme.dark(
//                                               primary: thirdcolor,
//                                               surface: Colors.white60,
//                                               background: backgroundcolor,
//                                               error: Colors.red,
//                                               onPrimary: Colors.white,
//                                               onSurface: primarycolor),
//                                           dialogBackgroundColor: Colors.white),
//                                       child: picker!);
//                                 }).then((value) {
//                               if (value != null) {
//                                 _setDate = DateFormat('yyyy-MM-dd')
//                                     .format(value)
//                                     .toString();
//                                 _tecTanggalChecklist.text = _setDate;
//                               }
//                             });
//                           },
//                           child: Text('Pilih Tanggal'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 8.0),
//               Card(
//                 elevation: 3.0,
//                 shadowColor: Colors.grey,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       left: 12.0, right: 12.0, bottom: 8.0, top: 8.0),
//                   child: TextFormField(
//                       controller: _tecDikerjakanOleh,
//                       cursorColor: thirdcolor,
//                       decoration: const InputDecoration(
//                         icon: Icon(
//                           Icons.person_add,
//                           color: thirdcolor,
//                         ),
//                         border: InputBorder.none,
//                         fillColor: Colors.white,
//                         focusColor: Colors.white,
//                         hintText: 'Dikerjakan Oleh',
//                       )),
//                 ),
//               ),
//               SizedBox(height: 8.0),
//               Card(
//                 elevation: 3.0,
//                 shadowColor: Colors.grey,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       left: 12.0, right: 12.0, bottom: 8.0, top: 8.0),
//                   child: TextFormField(
//                       controller: _tecDiperiksaOleh,
//                       cursorColor: thirdcolor,
//                       decoration: const InputDecoration(
//                         icon: Icon(
//                           Icons.person_rounded,
//                           color: thirdcolor,
//                         ),
//                         border: InputBorder.none,
//                         fillColor: Colors.white,
//                         focusColor: Colors.white,
//                         hintText: 'Diperiksa Oleh',
//                       )),
//                 ),
//               ),
//               SizedBox(
//                 height: 25.0,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // Navigator.pushReplacement(
//                   //     context,
//                   //     MaterialPageRoute(
//                   //         builder: (context) => KomponenChecklistPage(
//                   //               idmesin: idmesin,
//                   //             )));
//                 },
//                 style: ElevatedButton.styleFrom(
//                     elevation: 4.0,
//                     shadowColor: thirdcolor,
//                     primary: thirdcolor),
//                 child: Ink(
//                   decoration:
//                       BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
//                   child: Container(
//                     width: 325,
//                     height: 55,
//                     alignment: Alignment.center,
//                     child: const Text(
//                       'BUAT CHECKLIST',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22.0,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
