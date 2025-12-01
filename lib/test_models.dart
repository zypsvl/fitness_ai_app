import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // .env dosyasını oku

  String apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";

  if (apiKey.isEmpty) {
    print("❌ HATA: .env dosyasında API Key bulunamadı!");
    return;
  }

  print("🔑 Anahtar: $apiKey");
  print("📡 Google'a soruluyor: 'Bu anahtar hangi modelleri kullanabilir?'...");

  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey',
  );

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("\n✅ BAŞARILI! İŞTE KULLANABİLECEĞİN MODELLER:\n");

      bool found = false;
      for (var model in data['models']) {
        // Sadece içerik üretebilen modelleri filtrele
        if (model['supportedGenerationMethods'].contains('generateContent')) {
          // model['name'] genellikle "models/gemini-pro" şeklinde gelir
          String name = model['name'].toString().replaceFirst('models/', '');
          print("👉 $name");
          found = true;
        }
      }
      if (!found) print("⚠️ Liste geldi ama uygun model bulunamadı.");
      print("\n------------------------------------------\n");
    } else {
      print("❌ ERİŞİM HATASI (Kod: ${response.statusCode})");
      print("Google'ın Cevabı: ${response.body}");
      print(
        "\nÇÖZÜM: Lütfen https://aistudio.google.com adresinden YENİ bir key al.",
      );
    }
  } catch (e) {
    print("Bağlantı Hatası: $e");
  }
}
