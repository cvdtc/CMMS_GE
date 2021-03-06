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
      satuan,
      kilometer,
      tgl_reminder,
      umur_barang;

  CheckoutModel(
      {this.idcheckout,
      this.idmasalah,
      this.idbarang,
      this.idsatuan,
      this.tanggal,
      this.keterangan,
      this.qty,
      this.barang,
      this.satuan,
      this.kilometer,
      this.tgl_reminder,
      this.umur_barang});

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
        kilometer: map['kilometer'],
        tgl_reminder: map['tgl_reminder'],
        umur_barang: map['umur_barang']);
  }

  Map<String, dynamic> toJson() {
    return {
      "idmasalah": idmasalah,
      "idbarang": idbarang,
      "tanggal": tanggal,
      "idsatuan": idsatuan,
      "qty": qty,
      "keterangan": keterangan,
      "kilometer": kilometer,
      "tgl_reminder": tgl_reminder,

      /// just send not be inserted.
      "umur_barang": umur_barang
    };
  }

  @override
  String toString() {
    return 'CheckoutModel{idmasalah: $idmasalah, idbarang: $idbarang, tanggal: $tanggal, idsatuan: $idsatuan, qty: $qty, keterangan: $keterangan, kilomerter: $kilometer, tgl_reminder: $tgl_reminder}';
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
