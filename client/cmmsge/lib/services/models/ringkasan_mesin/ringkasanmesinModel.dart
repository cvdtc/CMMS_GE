import 'dart:convert';

class RingkasanMesinModel {
  String namamesin, lokasi, jml, lastdate, lastcheck, stat;

  RingkasanMesinModel(
      {required this.namamesin,
      required this.lokasi,
      required this.jml,
      required this.lastdate,
      required this.lastcheck,
      required this.stat});

  factory RingkasanMesinModel.fromJson(Map<String, dynamic> map) {
    return RingkasanMesinModel(
        namamesin: map['namamesin'].toString(),
        lokasi: map['lokasi'].toString(),
        jml: map['jml'].toString(),
        lastdate: map['lastdate'].toString(),
        lastcheck: map['lastcheck'].toString(),
        stat: map['stat'].toString());
  }
  @override
  String toString() {
    return 'namamesin: $namamesin, lokasi: $lokasi, jml: $jml, lastdate: $lastdate, lastcheck: $lastcheck, stat: $stat';
  }
}

List<RingkasanMesinModel> ringkasanmesinFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<RingkasanMesinModel>.from(
      data["data"].map((item) => RingkasanMesinModel.fromJson(item)));
}
