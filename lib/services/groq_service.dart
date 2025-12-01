import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exercise_model.dart';
import '../models/weekly_plan_model.dart';
import 'ai_service_interface.dart';

/// Groq API service using Llama 3.3 70B model
/// Provides fast and free workout plan generation
class GroqService implements AIService {
  // Groq API configuration
  static const String _apiKey = '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';
  static const String _apiUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.3-70b-versatile';
  
  @override
  Future<List<WorkoutDay>> createWeeklyWorkout(
    List<Exercise> allExercises,
    String userGoal,
    String level,
    int daysAvailable,
    String location,
    String gender,
  ) async {
    if (_apiKey.isEmpty) {
      print("HATA: Groq API Anahtarı bulunamadı");
      throw Exception('API anahtarı yapılandırılmamış. Lütfen uygulama geliştiricisine başvurun.');
    }

    // Create exercise menu for the AI
    String exerciseMenu = allExercises
        .map((e) => "${e.id} (${e.bodyPart}, ${e.equipmentTier})")
        .join(", ");

    // Create the prompt for Llama 3.3
    final prompt = '''
Sen uzman bir fitness koçusun.
KULLANICI PROFİLİ:
- Cinsiyet: $gender
- Hedef: $userGoal
- Seviye: $level
- Mekan: $location
- Sıklık: Haftada $daysAvailable gün

GÖREV:
Bu kullanıcı için $daysAvailable günlük, mantıklı bir "Split" (bölünme) programı hazırla.

KURALLAR:
1. SADECE şu ID listesindeki hareketleri kullan: [$exerciseMenu]
2. Mekan "$location" ise ve listede uygun ekipman yoksa, alternatif bulmaya çalış ama uydurma.
3. Cinsiyet "$gender" olduğu için buna uygun bir ton veya yoğunluk düşünebilirsin (JSON yapısını bozmadan).
4. Yanıtın SADECE geçerli bir JSON Array olsun. Markdown yok, açıklama yok, sadece JSON.
5. HER GÜN İÇİN EN AZ 6, EN FAZLA 8 HAREKET OLSUN.

İSTENEN JSON FORMATI:
[
  {
    "day": "Pazartesi",
    "focus": "Göğüs",
    "exercises": [
      {"id": "bench_press", "sets": "4", "reps": "8-10"},
      {"id": "incline_dumbbell_press", "sets": "3", "reps": "10-12"}
    ]
  },
  {
    "day": "Çarşamba",
    "focus": "Sırt & Biceps (Pull)",
    "exercises": []
  }
]

ÖNEMLİ: Sadece JSON array döndür, başka hiçbir metin ekleme!
''';

    try {
      print("🤖 Groq AI (Llama 3.3) ile program oluşturuluyor...");
      
      // Prepare the API request
      final requestBody = {
        'model': _model,
        'messages': [
          {
            'role': 'user',
            'content': prompt,
          }
        ],
        'temperature': 0.7,
        'max_tokens': 2000,
      };

      // Make the API call
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode != 200) {
        print("❌ Groq API Hatası: ${response.statusCode} - ${response.body}");
        
        // Handle specific error codes
        if (response.statusCode == 401) {
          throw Exception('API anahtarı geçersiz. Lütfen uygulama geliştiricisine başvurun.');
        } else if (response.statusCode == 429) {
          throw Exception('API limiti aşıldı. Lütfen birkaç dakika sonra tekrar deneyin.');
        } else {
          throw Exception('AI servisi yanıt vermedi. Lütfen tekrar deneyin.');
        }
      }

      // Parse the response
      final responseData = jsonDecode(response.body);
      final aiResponse = responseData['choices'][0]['message']['content'] as String;

      if (aiResponse.isEmpty) {
        print("HATA: AI boş yanıt döndü");
        throw Exception('AI servisi yanıt vermedi. Lütfen tekrar deneyin.');
      }

      // Clean the JSON response (remove markdown if present)
      String cleanJson = aiResponse
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      print("📝 AI yanıtı alındı, işleniyor...");
      
      // Parse the workout plan
      final List<dynamic> rawList = jsonDecode(cleanJson);

      if (rawList.isEmpty) {
        throw Exception('Program oluşturulamadı. Lütfen farklı ayarlar deneyin.');
      }

      // Convert to WorkoutDay objects
      List<WorkoutDay> weeklyPlan = [];
      for (var dayData in rawList) {
        weeklyPlan.add(WorkoutDay.fromJson(dayData, allExercises));
      }

      print("✅ Program başarıyla oluşturuldu: ${weeklyPlan.length} gün");
      return weeklyPlan;
      
    } on FormatException catch (e) {
      print("❌ JSON Parse Hatası: $e");
      throw Exception('Program verisi işlenirken hata oluştu. Lütfen tekrar deneyin.');
    } catch (e) {
      print("❌ Groq Service Hatası: $e");
      
      // Check if it's a network error
      if (e.toString().contains('SocketException') || 
          e.toString().contains('NetworkException') ||
          e.toString().contains('Failed host lookup')) {
        throw Exception('İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin.');
      }
      
      // Re-throw if it's already our custom exception
      if (e is Exception) {
        rethrow;
      }
      
      // Generic error
      throw Exception('Program oluşturulurken bir hata oluştu. Lütfen tekrar deneyin.');
    }
  }
}
