import 'package:cmmsge/services/models/site/siteModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/site/bottommodalsite.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SitePage extends StatefulWidget {
  @override
  _SitePageState createState() => _SitePageState();
}

class _SitePageState extends State<SitePage> {
  // ! Declare Variable HERE!
  ApiService _apiService = new ApiService();
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "";
  TextEditingController _tecNama = TextEditingController(text: "");
  TextEditingController _tecKeterangan = TextEditingController(text: "");

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
  initState() {
    super.initState();
    cekToken();
  }

  @override
  dispose() {
    // TODO: implement dispose
    super.dispose();
    _apiService.client.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Site'),
        centerTitle: true,
        backgroundColor: thirdcolor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          BottomSite().modalAddSite(context, 'tambah', token!, '', '', '');
          // _modalAddSite(context, 'tambah');
        },
        label: Text(
          'Tambah Site',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: secondcolor,
        icon: Icon(
          Icons.cabin_outlined,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
          future: _apiService.getListSite(token!),
          builder: (context, AsyncSnapshot<List<SiteModel>?> snapshot) {
            print('SNAPSHOT? ' + snapshot.toString());
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                        'maaf, terjadi masalah ${snapshot.error}. buka halaman ini kembali.')
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 15,
                    ),
                    Text('Sebentar ya, sedang antri...')
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<SiteModel>? dataKomponen = snapshot.data;
                return _listKomponen(dataKomponen);
              } else {
                return Center(
                  child: Text('Data Masih kosong nih!'),
                );
              }
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                        'maaf, terjadi masalah ${snapshot.error}. buka halaman ini kembali.')
                  ],
                ),
              );
            }
          }),
    );
  }

  // ++ DESIGN LIST COMPONENT
  Widget _listKomponen(List<SiteModel>? dataIndex) {
    return ListView.builder(
        itemCount: dataIndex!.length,
        itemBuilder: (context, index) {
          SiteModel? dataSite = dataIndex[index];
          return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                  elevation: 0.0,
                  child: InkWell(
                    onTap: () {
                      BottomSite().modalActionItem(
                          context,
                          token,
                          dataSite.nama,
                          dataSite.keterangan,
                          dataSite.idsite.toString());
                      // _modalActionItem(dataSite.nama, dataSite.keterangan,
                      //     dataSite.idsite.toString());
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Nama : ', style: TextStyle(fontSize: 18.0)),
                              Text(dataSite.nama,
                                  style: TextStyle(fontSize: 18.0))
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text('Keterangan : ',
                                  style: TextStyle(fontSize: 18.0)),
                              Text(dataSite.keterangan,
                                  style: TextStyle(fontSize: 18.0))
                            ],
                          ),
                        ],
                      ),
                    ),
                  )));
        });
  }
}
