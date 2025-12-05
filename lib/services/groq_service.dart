import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exercise_model.dart';
import '../models/weekly_plan_model.dart';
import 'ai_service_interface.dart';

/// Groq API service using Llama 3.3 70B model
/// Provides fast and free workout plan generation
class GroqService implements AIService {
  // Groq API configuration
  // API Key should be loaded from environment variables in production
  static const String _apiKey = ''; // TODO: Add your Groq API Key here or use .env
  static const String _apiUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.1-8b-instant';
  
  @override
  Future<List<WorkoutDay>> createWeeklyWorkout(
    List<Exercise> allExercises,
    String userGoal,
    String level,
    int daysAvailable,
    String location,
    String gender,
    String? equipment,
    List<String>? focusAreas,
  ) async {
    if (_apiKey.isEmpty) {
      print("HATA: Groq API Anahtarı bulunamadı");
      throw Exception('API anahtarı yapılandırılmamış. Lütfen uygulama geliştiricisine başvurun.');
    }

    // Debug: Print equipment and focus areas
    print("🔧 Equipment: $equipment");
    print("🎯 Focus Areas: $focusAreas");
    print("📍 Location: $location");

    // Filter exercises based on equipment and location
    List<Exercise> filteredExercises = allExercises;
    
    if (location.toLowerCase().contains('ev') || location.toLowerCase().contains('home')) {
      if (equipment == 'none') {
        filteredExercises = allExercises.where((e) => 
          e.equipmentTier == 'home' || e.equipmentTier == 'bodyweight'
        ).toList();
      } else if (equipment == 'dumbbells') {
        filteredExercises = allExercises.where((e) => 
          e.equipmentTier == 'dumbbell' || e.equipmentTier == 'home' || e.equipmentTier == 'bodyweight'
        ).toList();
      } else if (equipment == 'bands') {
        filteredExercises = allExercises.where((e) => 
          e.equipmentTier == 'resistance_band' || e.equipmentTier == 'home' || e.equipmentTier == 'bodyweight'
        ).toList();
      } else if (equipment == 'both') {
        filteredExercises = allExercises.where((e) => 
          e.equipmentTier == 'dumbbell' || e.equipmentTier == 'resistance_band' || e.equipmentTier == 'home' || e.equipmentTier == 'bodyweight'
        ).toList();
      }
    }

    print("🔍 Filtered exercises count: ${filteredExercises.length} (Original: ${allExercises.length})");

    // Create exercise menu for the AI
    String exerciseMenu = filteredExercises
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
Bu kullanıcı için 7 günlük detaylı bir antrenman programı hazırla.
Program $daysAvailable gün antrenman ve ${7 - daysAvailable} gün dinlenme içermelidir.

PROGRAM YAPISI VE SPLIT MANTIĞI (Buna KESİNLİKLE uy):
${daysAvailable == 1 ? '- 1 Gün: Full Body (Tüm Vücut)\n- Diğer günler dinlenme.' : ''}
${daysAvailable == 2 ? '- 1. Gün: Upper Body (Üst Vücut)\n- 2. Gün: Lower Body (Alt Vücut)\n- Aralarda dinlenme bırak.' : ''}
${daysAvailable == 3 ? '- 1. Gün: Push (İtiş)\n- 2. Gün: Pull (Çekiş)\n- 3. Gün: Legs (Bacak) ve Core\n- VEYA 3 gün Full Body.' : ''}
${daysAvailable == 4 ? '- 1. Gün: Upper Body\n- 2. Gün: Lower Body\n- 3. Gün: Upper Body\n- 4. Gün: Lower Body' : ''}
${daysAvailable == 5 ? '- 1. Gün: Push\n- 2. Gün: Pull\n- 3. Gün: Legs\n- 4. Gün: Upper Body\n- 5. Gün: Lower Body' : ''}
${daysAvailable >= 6 ? '- Push/Pull/Legs döngüsü veya bölgesel split (Chest/Back/Legs/Shoulders/Arms/Core).' : ''}

TEMEL KURALLAR - ÇOK ÖNEMLİ:
1. SADECE şu ID listesindeki hareketleri kullan: [$exerciseMenu]
2. Mekan "$location" ise ve listede uygun ekipman yoksa, alternatif bulmaya çalış ama uydurma.
3. Yanıtın SADECE geçerli bir JSON Array olsun. Markdown yok, açıklama yok.
4. HER ANTRENMAN GÜNÜ İÇİN KESİNLİKLE 5-7 ARASI HAREKET OLSUN.
   - 5'ten az hareket olmasın (yetersiz).
   - 8'den fazla hareket olmasın (gereksiz yorgunluk).
   - Hareket sayılarını günlere dengeli dağıt (örn: bir gün 3, diğer gün 8 hareket OLMAZ).

5. HAREKET ÇEŞİTLİLİĞİ VE DENGE:
   - AYNI HAREKETİ AYNI GÜN İÇİNDE ASLA TEKRARLAMA.
   - Benzer varyasyonları (örn: push_up ve knee_push_up) aynı gün kullanma.
   - Compound (bileşik) hareketleri antrenmanın başına koy.
   - İzolasyon hareketlerini sona sakla.
   - Bir kas grubu için arka arkaya 3'ten fazla hareket koyma.

6. DİNLENME GÜNLERİ:
   - Dinlenme günlerini antrenman günlerinin arasına mantıklı şekilde dağıt.
   - Asla 3 günden fazla üst üste ağır antrenman koyma (profesyonel değilse).
   - Dinlenme günü formatı: {"day": "Gün adı", "focus": "Dinlenme", "is_rest_day": true, "exercises": []}

${equipment != null && (location.toLowerCase().contains('ev') || location.toLowerCase().contains('home')) ? '''
7. EKİPMAN KISITLAMALARI (Ev Antrenmanı):
   Kullanıcı ekipmanı: $equipment
   
   ${equipment == 'none' ? '''
   - SADECE vücut ağırlığı (bodyweight) hareketleri kullan.
   - DUMBBELL, BARBELL, BAND, GYM içeren hareketler KESİNLİKLE YASAK.
   ''' : ''}
   
   ${equipment == 'dumbbells' ? '''
   - Dumbbell ve vücut ağırlığı hareketleri kullanabilirsin.
   - BARBELL, GYM, BAND içeren hareketler YASAK.
   ''' : ''}
   
   ${equipment == 'bands' ? '''
   - Direnç bandı ve vücut ağırlığı hareketleri kullanabilirsin.
   - DUMBBELL, BARBELL, GYM içeren hareketler YASAK.
   ''' : ''}
   
   ${equipment == 'both' ? '''
   - Dumbbell, direnç bandı ve vücut ağırlığı hareketleri serbest.
   - BARBELL ve GYM makinesi hareketleri YASAK.
   ''' : ''}
''' : ''}

${focusAreas != null && focusAreas.isNotEmpty ? '''
8. ODAK ALANLARI:
   - Kullanıcı şuralara odaklanmak istiyor: ${focusAreas.join(', ')}
   - Bu bölgeler için antrenmanlara 1-2 ekstra set veya hareket ekle.
   - Ancak programın genel dengesini bozma (sadece kol çalışma mesela).
''' : ''}

İSTENEN JSON FORMATI (Örnektir, sen 7 gün için doldur):
[
  {
    "day": "Pazartesi",
    "focus": "Göğüs & Triceps",
    "is_rest_day": false,
    "exercises": [
      {"id": "push_up", "sets": "3", "reps": "12-15"},
      {"id": "diamond_push_up", "sets": "3", "reps": "8-10"}
    ]
  },
  ...
  {
    "day": "Pazar",
    "focus": "Dinlenme",
    "is_rest_day": true,
    "exercises": []
  }
]
''';

    try {
      print("🤖 Groq AI (Llama 3.1 8B) ile program oluşturuluyor...");
      
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

      // Debug: Print masked API key
      print("🔑 API Key used: ${_apiKey.trim().substring(0, 10)}...");

      // Make the API call
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_apiKey.trim()}',
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
