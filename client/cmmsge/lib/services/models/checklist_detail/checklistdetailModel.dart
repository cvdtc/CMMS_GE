import 'dart:convert';

class ChecklistDetailModel {
  var komponen,
      kategori,
      ketmesin,
      nomesin,
      keterangan_detchecklist,
      action_checklist,
      idchecklist,
      idmesin;

  ChecklistDetailModel(
      {this.komponen,
      this.kategori,
      this.ketmesin,
      this.nomesin,
      this.keterangan_detchecklist,
      this.action_checklist,
      this.idchecklist,
      this.idmesin});

  factory ChecklistDetailModel.fromJson(Map<dynamic, dynamic> map) {
    return ChecklistDetailModel(
        komponen: map["komponen"],
        kategori: map["kategori"],
        ketmesin: map["ketmesin"],
        nomesin: map["nomesin"],
        keterangan_detchecklist: map["keterangan_detchecklist"],
        action_checklist: map["action_checklist"],
        idchecklist: map["idchecklist"],
        idmesin: map["idmesin"]);
  }

  @override
  String toString() {
    return 'ChecklistDetailModel{komponen: $komponen, kategori: $kategori, ketmesin: $ketmesin, nomesin: $nomesin, keterangan_detchecklist: $keterangan_detchecklist, action_checklist: $action_checklist, idchecklist: $idchecklist, idmesin: $idmesin}';
  }
}

List<ChecklistDetailModel> checklistdetailFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<ChecklistDetailModel>.from(
      data["data"].map((item) => ChecklistDetailModel.fromJson(item)));
}
