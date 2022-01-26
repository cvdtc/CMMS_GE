import 'package:shared_preferences/shared_preferences.dart';

class checkAuth {
  late SharedPreferences sp;
  String? token, username, jabatan;
  Future<List<String?>> cekToken() async {
    sp = await SharedPreferences.getInstance();
    token = sp.getString("access_token");
    username = sp.getString("username");
    jabatan = sp.getString("jabatan");

    return [this.token, this.username, this.jabatan];
  }
}
