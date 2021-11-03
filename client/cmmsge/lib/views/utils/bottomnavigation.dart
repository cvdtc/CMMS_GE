import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/dashboard/dasboardpage.dart';
import 'package:cmmsge/views/pages/menu/menupage.dart';
import 'package:cmmsge/views/pages/scan/scanmesinpage.dart';
import 'package:cmmsge/views/pages/schedule/scheduleganti.dart';
import 'package:cmmsge/views/pages/site/sitewithinsearch.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "";
// * ceking token and getting dashboard value from Shared Preferences
  cekToken() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("access_token")!;
      username = sp.getString("username")!;
      jabatan = sp.getString("jabatan")!;
    });

    print('Token Site?' + " " + token.toString());
  }

  @override
  void initState() {
    cekToken();
    super.initState();
  }

  // ! Initialize Variable
  // * please all variable drop here!
  // * and make sure variable have value don't let variable null
  int _currentTab = 0;
  PageStorageBucket bucket = PageStorageBucket();
  List<Widget> _currentPage = <Widget>[
    DashboardPage(),
    ScanMesinPage(),
    SiteSearchPage(
      token:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZHBlbmdndW5hIjoxMCwiaWF0IjoxNjM1NzU2ODEyLCJleHAiOjE2MzU4NDMyMTJ9.CweiMGCE9Qa792RLhblo4pZXFJFhThCHuaafPDvN1eo',
    ),
    MenuPage()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _backPressed,
        child: Scaffold(
          body: PageStorage(bucket: bucket, child: _currentPage[_currentTab]),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedIconTheme: IconThemeData(color: primarycolor),
            selectedItemColor: primarycolor,
            unselectedItemColor: primarycolor.withOpacity(.40),
            onTap: (value) {
              setState(() {
                _currentTab = value;
              });
            },
            currentIndex: _currentTab,
            items: [
              BottomNavigationBarItem(
                  label: 'Home', icon: Icon(Icons.favorite)),
              BottomNavigationBarItem(
                  label: 'Scan', icon: Icon(Icons.qr_code_2)),
              BottomNavigationBarItem(
                  label: 'Schedule', icon: Icon(Icons.schedule_outlined)),
              BottomNavigationBarItem(label: 'Menu', icon: Icon(Icons.menu)),
            ],
          ),
        ));
  }

  // * handle exit apps when back button pressed 2 times
  Future<bool> _backPressed() async {
    DateTime currentTime = DateTime.now();
    bool backButton = DateTime == null ||
        currentTime.difference(DateTime.now()) > Duration(seconds: 2);
    if (backButton) {
      return false;
    } else {
      return true;
    }
  }
}
