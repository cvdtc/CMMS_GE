import 'dart:convert';

class DataGantiPartModel {
  var kode, nama, tanggal, umur, qty, keterangan;

  DataGantiPartModel(
      {this.kode,
      this.nama,
      this.tanggal,
      this.umur,
      this.qty,
      this.keterangan});
  factory DataGantiPartModel.fromJson(Map<dynamic, dynamic> map) {
    return DataGantiPartModel(
        kode: map["KODE"],
        nama: map["NAMA"],
        tanggal: map['tanggal'],
        umur: map['UMUR'],
        qty: map['qty'],
        keterangan: map['keterangan']);
  }

  @override
  String toString() {
    return 'kode: $kode, nama: $nama, tanggal: $tanggal, umur: $umur, qty: $qty, keterangan: $keterangan';
  }
}

List<DataGantiPartModel> datagantipartFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<DataGantiPartModel>.from(
      data["data"].map((item) => DataGantiPartModel.fromJson(item)));
}
