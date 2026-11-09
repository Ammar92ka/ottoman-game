import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class AiProvider {
  String get name;
  Future<String> generateEvent(String prompt, String apiKey);
}

class GeminiProvider implements AiProvider {
  @override String get name => 'Gemini';
  @override Future<String> generateEvent(String prompt, String apiKey) async {
    if (apiKey.isEmpty) return 'لا يوجد مفتاح - سيتم استخدام القصص المحلية';
    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');
    final res = await http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'contents': [{'parts': [{'text': prompt}]}]}));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    }
    return 'فشل الاتصال بـ Gemini';
  }
}

class GroqProvider implements AiProvider {
  @override String get name => 'Groq';
  @override Future<String> generateEvent(String prompt, String apiKey) async {
    return 'Groq: سيتم توليد الحدث بعد وضع المفتاح';
  }
}

class LlamaProvider implements AiProvider {
  @override String get name => 'Llama';
  @override Future<String> generateEvent(String prompt, String apiKey) async {
    return 'Llama: سيتم توليد الحدث بعد وضع المفتاح';
  }
}
