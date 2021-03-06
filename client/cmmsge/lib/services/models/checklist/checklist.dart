import 'dart:convert';

class ChecklistModel {
  var idchecklist,
      deskripsi,
      keterangan,
      dikerjakan_oleh,
      diperiksa_oleh,
      tanggal_checklist,
      revisi,
      idmesin,
      no_dokumen,
      nomesin,
      ketmesin;

  ChecklistModel(
      {this.idchecklist,
      this.deskripsi,
      this.keterangan,
      this.dikerjakan_oleh,
      this.diperiksa_oleh,
      this.tanggal_checklist,
      this.revisi,
      this.idmesin,
      this.no_dokumen,
      this.nomesin,
      this.ketmesin});

  factory ChecklistModel.fromJson(Map<dynamic, dynamic> map) {
    return ChecklistModel(
      idchecklist: map["idchecklist"],
      deskripsi: map["deskripsi"],
      keterangan: map["keterangan"],
      dikerjakan_oleh: map["dikerjakan_oleh"],
      diperiksa_oleh: map["diperiksa_oleh"],
      tanggal_checklist: map["tanggal_checklist"],
      revisi: map["revisi"],
      idmesin: map["idmesin"],
      no_dokumen: map["no_dokumen"],
      nomesin: map['nomesin'],
      ketmesin: map['ketmesin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "deskripsi": deskripsi,
      "keterangan": keterangan,
      "dikerjakan_oleh": dikerjakan_oleh,
      "diperiksa_oleh": diperiksa_oleh,
      "tanggal_checklist": tanggal_checklist,
      "idmesin": idmesin,
      "revisi": revisi,
      "no_dokumen": no_dokumen,
    };
  }

  @override
  String toString() {
    return 'ChecklistModel{ deskripsi: $deskripsi, keterangan: $keterangan, dikerjakan_oleh: $dikerjakan_oleh, diperiksa_oleh: $diperiksa_oleh, tanggal_checklist: $tanggal_checklist, idmesin: $idmesin, no_dokumen: $no_dokumen, nomesin: $nomesin, ketmesin: $ketmesin }';
  }
}

List<ChecklistModel> checklistFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<ChecklistModel>.from(
      data["data"].map((item) => ChecklistModel.fromJson(item)));
}

String checklistToJson(ChecklistModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
