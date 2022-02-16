import 'dart:convert';

class SchedulepartModel {
  var kode,
      nama,
      umur_barang,
      satuan,
      lewathari,
      tgl_reminder,
      idcheckout,
      masalah;

  SchedulepartModel(
      {this.kode,
      this.nama,
      this.umur_barang,
      this.satuan,
      this.lewathari,
      this.tgl_reminder,
      this.idcheckout,
      this.masalah});

  factory SchedulepartModel.fromJson(Map<String, dynamic> map) {
    return SchedulepartModel(
        kode: map['kode'],
        nama: map['nama'],
        umur_barang: map['umur_barang'],
        satuan: map['satuan'],
        lewathari: map['lewathari'],
        tgl_reminder: map['tgl_reminder'],
        idcheckout: map['idcheckout'],
        masalah: map['masalah']);
  }

  @override
  String toString() {
    return 'SchedulepartModel{kode: $kode, nama: $nama, umur_barang: $umur_barang, satuan: $satuan, lewathari: $lewathari, tgl_reminder: $tgl_reminder, idcheckout: $idcheckout, masalah: $masalah}';
  }
}

List<SchedulepartModel> schedulrpartFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<SchedulepartModel>.from(
      data["data"].map((item) => SchedulepartModel.fromJson(item)));
}
