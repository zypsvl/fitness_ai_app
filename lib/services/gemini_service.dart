import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/exercise_model.dart';
import '../models/weekly_plan_model.dart';

class GeminiService {
  Future<List<WorkoutDay>> createWeeklyWorkout(
    List<Exercise> allExercises,
    String userGoal,
    String level,
    int daysAvailable,
    String location,
    String gender,
  ) async {
    // API Key - hardcoded for APK distribution
    final apiKey = 'AIzaSyCt7FaqbAwsmT4a-yWyobgDjrWtOQgfYAg';
    
    if (apiKey.isEmpty) {
      print("HATA: API Anahtarı bulunamadı");
      throw Exception('API anahtarı yapılandırılmamış. Lütfen uygulama geliştiricisine başvurun.');
    }

    final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);

    // Hareket listesini AI'ya özet geçiyoruz
    String exerciseMenu = allExercises
        .map((e) => "${e.id} (${e.bodyPart}, ${e.equipmentTier})")
        .join(", ");

    final prompt =
        '''
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
    4. Yanıtın SADECE geçerli bir JSON Array olsun. Markdown yok.
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
    ''';

    try {
      print("🤖 AI'dan program oluşturuluyor...");
      final response = await model.generateContent([Content.text(prompt)]);

      if (response.text == null || response.text!.isEmpty) {
        print("HATA: AI boş yanıt döndü");
        throw Exception('AI servisi yanıt vermedi. Lütfen tekrar deneyin.');
      }

      String cleanJson = response.text!
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      print("📝 AI yanıtı alındı, işleniyor...");
      
      final List<dynamic> rawList = jsonDecode(cleanJson);

      if (rawList.isEmpty) {
        throw Exception('Program oluşturulamadı. Lütfen farklı ayarlar deneyin.');
      }

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
      print("❌ AI Servis Hatası: $e");
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
