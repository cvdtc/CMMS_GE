import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cmmsge/services/models/mesin/mesinModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/report/datamesin/ringkasanmesin.dart';
import 'package:cmmsge/views/pages/scan/networkceknomesin.dart';
import 'package:cmmsge/views/pages/scan/webviewscanresult.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanMesinPage extends StatefulWidget {
  @override
  _ScanMesinPageState createState() => _ScanMesinPageState();
}

class _ScanMesinPageState extends State<ScanMesinPage> {
  //QRCODE VARIABLE
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  List<MesinModel> _datamesin = <MesinModel>[];

// AUDIO VARIABLE
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  String? audioPath;

  //VARIABLE
  String? dataqr;
  ApiService _apiService = new ApiService();
  late bool isSuccess;
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "";

  bool _isLoading = true;

  // * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token");
      username = sp.getString("username");
      jabatan = sp.getString("jabatan");
    });
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      audioCache.fixedPlayer?.notificationService.startHeadlessService();
    }
    cekToken();
  }

  void playSound() async {
    final file = await audioCache.loadAsFile('audio/success-payment.mp3');
    final bytes = await file.readAsBytes();
    audioCache.playBytes(bytes);
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(5),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                side: BorderSide(width: 2, color: thirdcolor),
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                primary: Colors.white),
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                // return Text('Flash: ${snapshot.data}');
                                return snapshot.data == true
                                    ? Icon(Icons.flash_off, color: thirdcolor)
                                    : Icon(Icons.flash_on, color: thirdcolor);
                              },
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                side: BorderSide(width: 2, color: thirdcolor),
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                primary: Colors.white),
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                return snapshot.data == CameraFacing.back
                                    ? Icon(
                                        Icons.camera_front,
                                        color: thirdcolor,
                                      )
                                    : Icon(Icons.cameraswitch,
                                        color: thirdcolor);
                              },
                            )),
                      ),
                    ],
                  ),
                  result == null
                      ? Text('Scan a code')
                      // : result!.code!.split('2b')[0].toString() != '\$'
                      // ? Text('QR Tidak Valid!')
                      : ElevatedButton(
                          onPressed: () {
                            fetchMesinByNoMesin(token!, result!.code.toString())
                                .then((value) {
                              print('ppp' + value.toString());
                              setState(() {
                                _isLoading = false;
                                _datamesin.addAll(value!);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RingkasanMesinPage(
                                              idmesin: _datamesin[0]
                                                  .idmesin
                                                  .toString(),
                                              namamesin: _datamesin[0]
                                                  .keterangan
                                                  .toString(),
                                            )));
                              });
                            }).catchError((error, stackTrace) {
                              print(error);
                              if (error == 204) {
                                ReusableClasses().modalbottomWarning(
                                    context,
                                    'Warning!',
                                    "Data masih kosong",
                                    error.toString(),
                                    'assets/images/sorry.png');
                              } else {
                                ReusableClasses().modalbottomWarning(
                                    context,
                                    'Warning!',
                                    error.toString(),
                                    stackTrace.toString(),
                                    'assets/images/sorry.png');
                              }
                            });

                            /// not used bcz has changed bypass to laporan data mesin
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => WebviewScanResult(
                            //               urlwebview: result!.code.toString(),
                            //               token: token!,
                            //             )));
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            primary: thirdcolor,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18)),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Lihat Detail" + result!.code.toString(),
                              ),
                            ),
                          )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      overlayMargin: EdgeInsets.all(5),
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: thirdcolor,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutBottomOffset: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
    setState(() {
      this.controller = controller;
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
    cekToken();
  }
}
