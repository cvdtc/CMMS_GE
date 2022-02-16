import 'package:cmmsge/utils/ReusableClasses.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CekSharedPred {
  late SharedPreferences sp;
  String? token = "", username = "", jabatan = "";
  List<String>? sharedpref = [];
  Future<List?> cektoken(context) async {
    sp = await SharedPreferences.getInstance();
    token = sp.getString("access_token");
    jabatan = sp.getString("jabatan");
    username = sp.getString("username");
    sharedpref!.add(token.toString());
    sharedpref!.add(username.toString());
    sharedpref!.add(jabatan.toString());
    if (token == null) {
      ReusableClasses().exit(context);
    }
    return sharedpref;
  }
}
