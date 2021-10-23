import 'package:cmmsge/services/models/komponen/KomponenModel.dart';
import 'package:cmmsge/utils/warna.dart';
import 'package:flutter/material.dart';

class KomponenPage extends StatefulWidget {
  @override
  _KomponenPageState createState() => _KomponenPageState();
}

class _KomponenPageState extends State<KomponenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Komponen'),
        centerTitle: true,
        backgroundColor: thirdcolor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text(
          'Tambah Komponen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: secondcolor,
        icon: Icon(
          Icons.cable_outlined,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
          builder: (context, AsyncSnapshot<List<KomponenModel>?> snapshot) {
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
            List<KomponenModel>? dataKomponen = snapshot.data;
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

  Widget _listKomponen(List<KomponenModel>? dataIndex) {
    return ListView.builder(
        itemCount: dataIndex!.length,
        itemBuilder: (context, index) {
          KomponenModel? dataKomponen = dataIndex[index];
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  child: Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [Text('Nama : '), Text(dataKomponen.nama)],
                    ),
                    Row(
                      children: [Text('Jumlah : '), Text(dataKomponen.jumlah)],
                    )
                  ],
                ),
              )));
        });
  }
}
