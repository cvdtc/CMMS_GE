import 'dart:convert';

class PenyelesaianModel {
  var idpenyelesaian, tanggal, keterangan, idmasalah;

  PenyelesaianModel(
      {this.idpenyelesaian, this.tanggal, this.keterangan, this.idmasalah});

  Map<String, dynamic> toJson() {
    return {
      "tanggal": tanggal,
      "keterangan": keterangan,
      "idmasalah": idmasalah
    };
  }

  @override
  String toString() {
    return 'PenyelesaianModel{tanggal: $tanggal, keterangan: $keterangan, idmasalah: $idmasalah}';
  }
}

String penyelesaianToJson(PenyelesaianModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
