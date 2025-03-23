
import 'dart:convert';
import 'package:dream/const/api_key.dart';
import 'package:http/http.dart' as http;

class RuyaYorumuController {
  Future<String> getYorum(String ruyaMetni) async {
    // Gemini API endpoint'i
    final apiUrl = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent');

    // API anahtarını constants'tan al
    final apiKey = ApiKey.GEMINI_API_KEY;

    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': apiKey, // Gemini API için doğru header formatı
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": """Sen profesyonel bir rüya yorumcususun. Aşağıdaki rüyayı analiz et ve kapsamlı bir yorum yap:

Rüya: $ruyaMetni

Yorumunda şunları içer:
1. Rüyadaki sembol ve motiflerin olası anlamları
2. Rüyanın psikolojik açıdan ne ifade edebileceği
3. Rüyada görülen öğelerin kültürel ve evrensel sembolizmi
4. Kişinin günlük hayatıyla olası bağlantılar

Yorumunu dengeli, bilgilendirici ve yargılayıcı olmayan bir tonda yap. Kesin yargılardan kaçın ve farklı yorum olasılıklarını belirt. Yanıtını 3-4 paragrafla sınırla ve anlaşılır bir dil kullan.""",
                },
              ],
            },
          ],
          "generationConfig": {"temperature": 0.7, "maxOutputTokens": 800, "topP": 0.95, "topK": 40},
        }),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        // Gemini API response yapısı
        return decodedResponse['candidates'][0]['content']['parts'][0]['text'].trim();
      } else {
        print('API Hatası: ${response.statusCode}, ${response.body}');
        return 'Rüya yorumu alınamadı.';
      }
    } catch (e) {
      print('Hata oluştu: $e');
      return 'Rüya yorumu alınamadı.';
    }
  }
}
