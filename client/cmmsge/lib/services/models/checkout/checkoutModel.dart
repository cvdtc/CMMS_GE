import 'dart:convert';

class CheckoutModel {
  var idcheckout,
      idmasalah,
      idbarang,
      idsatuan,
      tanggal,
      keterangan,
      qty,
      barang,
      satuan;

  CheckoutModel(
      {this.idcheckout,
      this.idmasalah,
      this.idbarang,
      this.idsatuan,
      this.tanggal,
      this.keterangan,
      this.qty,
      this.barang,
      this.satuan});

  factory CheckoutModel.fromJson(Map<String, dynamic> map) {
    return CheckoutModel(
      idcheckout: map['idcheckout'],
      idmasalah: map['idmasalah'],
      idbarang: map['idbarang'],
      idsatuan: map['idsatuan'],
      tanggal: map['tanggal'],
      keterangan: map['keterangan'],
      qty: map['qty'],
      barang: map['barang'],
      satuan: map['satuan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idmasalah": idmasalah,
      "idbarang": idbarang,
      "tanggal": tanggal,
      "idsatuan": idsatuan,
      "qty": qty,
      "keterangan": keterangan
    };
  }

  @override
  String toString() {
    return 'CheckoutModel{idmasalah: $idmasalah, idbarang: $idbarang, tanggal: $tanggal, idsatuan: $idsatuan, qty: $qty, keterangan: $keterangan}';
  }
}

String checkoutToJson(CheckoutModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

List<CheckoutModel> checkoutFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<CheckoutModel>.from(
      data["data"].map((item) => CheckoutModel.fromJson(item)));
}
