import 'package:cmmsge/services/models/site/siteModel.dart';
import 'package:cmmsge/utils/loadingview.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:cmmsge/views/pages/site/networksite.dart';
import 'package:cmmsge/views/pages/site/sitetile.dart';
import 'package:flutter/material.dart';

import 'bottommodalsite.dart';

class SiteSearchPage extends StatefulWidget {
  String token;
  SiteSearchPage({required this.token});
  @override
  _SiteSearchPageState createState() => _SiteSearchPageState();
}

class _SiteSearchPageState extends State<SiteSearchPage> {
  String token = '';
  List<SiteModel> _sites = <SiteModel>[];
  List<SiteModel> _sitesDisplay = <SiteModel>[];

  bool _isLoading = true;

  @override
  void initState() {
    String token = widget.token;
    print(token);
    fetchSite(token).then((value) {
      print("IN?");
      setState(() {
        _isLoading = false;
        _sites.addAll(value);
        _sitesDisplay = _sites;
        print(_sitesDisplay.length);
      });
    });
    super.initState();
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
          BottomSite().modalAddSite(context, 'tambah', token);
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
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              if (!_isLoading) {
                return index == 0
                    ? _searchBar()
                    : SiteTile(
                        site: this._sitesDisplay[index - 1],
                        token: token,
                      );
                // : SiteTile(site: this._sitesDisplay[index - 1]);
              } else {
                return LoadingView();
              }
            },
            itemCount: _sitesDisplay.length + 1,
          ),
        ),
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: TextField(
        autofocus: false,
        onChanged: (searchText) {
          searchText = searchText.toLowerCase();
          setState(() {
            _sitesDisplay = _sites.where((u) {
              var fNama = u.nama.toLowerCase();
              var fKeterangan = u.keterangan.toLowerCase();
              return fNama.contains(searchText) ||
                  fKeterangan.contains(searchText);
            }).toList();
          });
        },
        // controller: _textController,
        decoration: InputDecoration(
          fillColor: thirdcolor,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          hintText: 'Search Site',
        ),
      ),
    );
  }
}
