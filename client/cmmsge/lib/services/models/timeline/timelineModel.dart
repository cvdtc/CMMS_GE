import 'dart:convert';

class TimelineModel {
  var tipe,
      jam,
      tanggal,
      masalah,
      shift,
      perbaikan,
      engginer,
      tanggalprog,
      shiftprog,
      tanggalselesai,
      keteranganselesai,
      kode,
      barang,
      satuan,
      qty,
      keterangancheckout;

  TimelineModel(
      {this.tipe,
      this.jam,
      this.tanggal,
      this.masalah,
      this.shift,
      this.perbaikan,
      this.engginer,
      this.tanggalprog,
      this.tanggalselesai,
      this.keteranganselesai,
      this.kode,
      this.barang,
      this.satuan,
      this.qty,
      this.keterangancheckout});

  factory TimelineModel.fromJson(Map<String, dynamic> map) {
    return TimelineModel(
      tipe: map['tipe'],
      jam: map['jam'],
      tanggal: map['tanggal'],
      masalah: map['masalah'],
      shift: map['shift'],
      perbaikan: map['perbaikan'],
      engginer: map['engginer'],
      tanggalprog: map['tanggalprog'],
      tanggalselesai: map['tanggalselesai'],
      keteranganselesai: map['keteranganselesai'],
      kode: map['kode'],
      barang: map['barang'],
      satuan: map['satuan'],
      qty: map['qty'],
      keterangancheckout: map['keterangancheckout'],
    );
  }
  @override
  String toString() {
    return 'tipe: $tipe, jam: $jam, tanggal: $tanggal, masalah: $masalah, shift: $shift, perbaikan: $perbaikan, engginer: $engginer, tanggalprog: $tanggalprog, tanggalselesai: $tanggalselesai, keteranganselesai: $keteranganselesai, kode: $kode, barang: $barang, satuan: $satuan, qty: $qty, keterangancheckout: $keterangancheckout';
  }
}

List<TimelineModel> timelineFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<TimelineModel>.from(
      data["data"].map((item) => TimelineModel.fromJson(item)));
}
