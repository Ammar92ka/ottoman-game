import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SaveService {
  Future<void> save(Map<String, dynamic> data) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('ottoman_save', jsonEncode(data));
  }
  Future<Map<String, dynamic>?> load() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getString('ottoman_save');
    if (s == null) return null;
    return jsonDecode(s);
  }
  String exportJson(Map<String, dynamic> data) => jsonEncode(data);
}
