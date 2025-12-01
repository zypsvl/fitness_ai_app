import 'package:flutter/material.dart';

class AppStrings {
  final BuildContext context;
  
  AppStrings(this.context);
  
  // Get current locale
  String get _languageCode => Localizations.localeOf(context).languageCode;
  bool get _isEnglish => _languageCode == 'en';
  
  // App Title
  String get appTitle => 'GymGenius';
  
  // Onboarding
  String get genderQuestion => _isEnglish ? "What's your gender?" : "Cinsiyetin?";
  String get male => _isEnglish ? "Male" : "Erkek";
  String get female => _isEnglish ? "Female" : "Kadın";
  
  String get goalQuestion => _isEnglish ? "What's your goal?" : "Hedefin Ne?";
  String get loseWeight => _isEnglish ? "Lose Weight" : "Kilo Vermek";
  String get buildMuscle => _isEnglish ? "Build Muscle" : "Kas Yapmak";
  String get getStronger => _isEnglish ? "Get Stronger" : "Güçlenmek";
  String get getFit => _isEnglish ? "Get Fit" : "Fit Olmak";
  
  String get levelQuestion => _isEnglish ? "What's your level?" : "Seviyen?";
  String get beginner => _isEnglish ? "Beginner" : "Başlangıç";
  String get intermediate => _isEnglish ? "Intermediate" : "Orta";
  String get advanced => _isEnglish ? "Advanced" : "İleri";
  
  String get planDetailsTitle => _isEnglish ? "Plan Details" : "Plan Detayları";
  String get whereToWorkout => _isEnglish ? "Where will you workout?" : "Nerede Çalışacaksın?";
  String get gym => _isEnglish ? "Gym" : "Spor Salonu";
  String get homeDumbbell => _isEnglish ? "Home (Dumbbell)" : "Ev (Dambıl)";
  String get weeklyWorkout => _isEnglish ? "Weekly Workout" : "Haftalık Antrenman";
  String get days => _isEnglish ? "Days" : "Gün";
  
  String get createProgramButton => _isEnglish ? "CREATE PROGRAM 🚀" : "PROGRAMI OLUŞTUR 🚀";
  String get myPrograms => _isEnglish ? "My Programs" : "Programlarım";
  
  // Error messages
  String get errorNoInternet => _isEnglish 
    ? "No internet connection. Please check your connection."
    : "İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin.";
  
  String get errorApiKey => _isEnglish
    ? "API key not configured. Please contact app developer."
    : "API anahtarı yapılandırılmamış. Lütfen uygulama geliştiricisine başvurun.";
  
  String get errorEmptyResponse => _isEnglish
    ? "AI service did not respond. Please try again."
    : "AI servisi yanıt vermedi. Lütfen tekrar deneyin.";
  
  String get errorParsing => _isEnglish
    ? "Error processing program data. Please try again."
    : "Program verisi işlenirken hata oluştu. Lütfen tekrar deneyin.";
  
  String get errorEmptyProgram => _isEnglish
    ? "Could not create program. Please try different settings."
    : "Program oluşturulamadı. Lütfen farklı ayarlar deneyin.";
  
  String get errorGeneric => _isEnglish
    ? "An error occurred while creating program. Please try again."
    : "Program oluşturulurken bir hata oluştu. Lütfen tekrar deneyin.";
  
  // Save Program Dialog
  String get saveProgram => _isEnglish ? "Save Program" : "Programı Kaydet";
  String get programName => _isEnglish ? "Give your program a name" : "Programına bir isim ver";
  String get programNameHint => _isEnglish ? "e.g., My Summer Program" : "Örn: Yaz Programım";
  String get programNameError => _isEnglish ? "Please enter a name" : "Lütfen bir isim girin";
  String get programNameTooShort => _isEnglish ? "Name must be at least 3 characters" : "İsim en az 3 karakter olmalı";
  String get cancel => _isEnglish ? "Cancel" : "İptal";
  String get save => _isEnglish ? "Save" : "Kaydet";
  
  // Days of week
  String get monday => _isEnglish ? "Monday" : "Pazartesi";
  String get tuesday => _isEnglish ? "Tuesday" : "Salı";
  String get wednesday => _isEnglish ? "Wednesday" : "Çarşamba";
  String get thursday => _isEnglish ? "Thursday" : "Perşembe";
  String get friday => _isEnglish ? "Friday" : "Cuma";
  String get saturday => _isEnglish ? "Saturday" : "Cumartesi";
  String get sunday => _isEnglish ? "Sunday" : "Pazar";
  
  // General
  String get sets => _isEnglish ? "Sets" : "Set";
  String get reps => _isEnglish ? "Reps" : "Tekrar";
  String get exercise => _isEnglish ? "Exercise" : "Egzersiz";
  String get exercises => _isEnglish ? "Exercises" : "Egzersizler";
  
  // Result Screen
  String get programReady => _isEnglish ? "Your Program is Ready! 🔥" : "Programın Hazır! 🔥";
  String get error => _isEnglish ? "Error" : "Hata";
  String get programLoadError => _isEnglish ? "Could not load program." : "Program yüklenemedi.";
  String get saveButton => _isEnglish ? "Save" : "Kaydet";
  String get programSaved => _isEnglish ? "saved!" : "kaydedildi!";
  String get programAlreadySaved => _isEnglish ? "This program is already saved!" : "Bu program zaten kaydedilmiş!";
  String get totalSets => _isEnglish ? "Total Sets" : "Toplam Set";
  String get minutes => _isEnglish ? "Minutes" : "Dakika";
  
  // Home Dashboard
  String get welcome => _isEnglish ? "Welcome! 👋" : "Hoş Geldin! 👋";
  String get readyForGoals => _isEnglish ? "Ready to reach your goals?" : "Hedeflerine ulaşmaya hazır mısın?";
  String get recentPrograms => _isEnglish ? "Recent Programs" : "Son Programlar";
  String get viewAll => _isEnglish ? "View All" : "Tümünü Gör";
  String get createNewProgram => _isEnglish ? "Create New Program" : "Yeni Program Oluştur";
  String get customWorkoutProgram => _isEnglish ? "Custom workout program for your goals" : "Hedeflerine özel antrenman programı";
  String get statistics => _isEnglish ? "Statistics" : "İstatistikler";
  String get program => _isEnglish ? "Program" : "Program";
  String get programs => _isEnglish ? "Programs" : "Program";
  String get totalDays => _isEnglish ? "Total Days" : "Toplam Gün";
  String get savedPrograms => _isEnglish ? "Saved Programs" : "Kaydedilmiş Programlar";
  String get noProgramsYet => _isEnglish ? "No programs yet" : "Henüz program yok";
  String get createFirstProgram => _isEnglish ? "Create your first workout program!" : "İlk antrenman programını oluştur!";
  String get daysPerWeek => _isEnglish ? "days/week" : "gün/hafta";
  String get delete => _isEnglish ? "Delete" : "Sil";
  String get rename => _isEnglish ? "Rename" : "Yeniden Adlandır";
  String get deleteConfirm => _isEnglish ? "Delete this program?" : "Bu programı sil?";
  String get renameProgram => _isEnglish ? "Rename Program" : "Programı Yeniden Adlandır";
  String get newName => _isEnglish ? "New name" : "Yeni isim";
  String get newProgram => _isEnglish ? "New Program" : "Yeni Program";
  String get programDeleted => _isEnglish ? "Program deleted" : "Program silindi";
  
  // Date formatting
  String get today => _isEnglish ? "Today" : "Bugün";
  String get yesterday => _isEnglish ? "Yesterday" : "Dün";
  String get daysAgo => _isEnglish ? "days ago" : "gün önce";
  String get weeksAgo => _isEnglish ? "weeks ago" : "hafta önce";
  String get monthsAgo => _isEnglish ? "months ago" : "ay önce";
  String get location => _isEnglish ? "Location" : "Konum";
  String get errorOccurred => _isEnglish ? "An error occurred" : "Bir hata oluştu";
  
  // Helper to get "day" or "days" based on count
  String daysCount(int count) => _isEnglish 
    ? (count == 1 ? "day" : "days")
    : "gün";

  // Helper to get localized day name
  String getDayName(String day) {
    final lowerDay = day.toLowerCase().trim();
    if (lowerDay.contains('monday') || lowerDay.contains('pazartesi')) return monday;
    if (lowerDay.contains('tuesday') || lowerDay.contains('salı') || lowerDay.contains('sali')) return tuesday;
    if (lowerDay.contains('wednesday') || lowerDay.contains('çarşamba') || lowerDay.contains('carsamba')) return wednesday;
    if (lowerDay.contains('thursday') || lowerDay.contains('perşembe') || lowerDay.contains('persembe')) return thursday;
    if (lowerDay.contains('friday') || lowerDay.contains('cuma')) return friday;
    if (lowerDay.contains('saturday') || lowerDay.contains('cumartesi')) return saturday;
    if (lowerDay.contains('sunday') || lowerDay.contains('pazar')) return sunday;
    return day;
  }

  // Helper to get localized goal
  String getGoal(String goal) {
    final lowerGoal = goal.toLowerCase().trim();
    if (lowerGoal.contains('lose') || lowerGoal.contains('kilo')) return loseWeight;
    if (lowerGoal.contains('muscle') || lowerGoal.contains('kas')) return buildMuscle;
    if (lowerGoal.contains('stronger') || lowerGoal.contains('güç')) return getStronger;
    if (lowerGoal.contains('fit')) return getFit;
    return goal;
  }

  // Helper to get localized level
  String getLevel(String level) {
    final lowerLevel = level.toLowerCase().trim();
    if (lowerLevel.contains('beginner') || lowerLevel.contains('başlangıç') || lowerLevel.contains('baslangic')) return beginner;
    if (lowerLevel.contains('intermediate') || lowerLevel.contains('orta')) return intermediate;
    if (lowerLevel.contains('advanced') || lowerLevel.contains('ileri')) return advanced;
    return level;
  }

  // Helper to get localized location
  String getLocation(String location) {
    final lowerLocation = location.toLowerCase().trim();
    if (lowerLocation.contains('gym') || lowerLocation.contains('spor')) return gym;
    if (lowerLocation.contains('home') || lowerLocation.contains('ev')) return homeDumbbell;
    return location;
  }

  // Helper to format date
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return today;
    } else if (difference.inDays == 1) {
      return yesterday;
    } else if (difference.inDays < 7) {
      return '${difference.inDays} $daysAgo';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks $weeksAgo';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months $monthsAgo';
    }
  }

  // Manual Program Creation
  String get createProgramTitle => _isEnglish ? "Create Program" : "Program Oluştur";
  String get designYourProgram => _isEnglish ? "Design Your Program" : "Kendi Programını Tasarla";
  String get designProgramDesc => _isEnglish 
    ? "Define program details and start adding exercises." 
    : "Program detaylarını belirle ve egzersizlerini eklemeye başla.";
  String get weeklyTraining => _isEnglish ? "Weekly Training" : "Haftalık Antrenman";
  String get createAndEdit => _isEnglish ? "Create and Edit" : "Oluştur ve Düzenle";
  String get createWithAI => _isEnglish ? "Create with AI" : "AI ile Oluştur";
  String get createWithAIDesc => _isEnglish ? "Let AI create a custom program for you" : "Yapay zeka size özel program hazırlasın";
  String get createManually => _isEnglish ? "Create Manually" : "Kendin Oluştur";
  String get createManuallyDesc => _isEnglish ? "Design your program from scratch" : "Programını sıfırdan kendin tasarla";
  
  // Edit Program
  String get editProgram => _isEnglish ? "Edit Program" : "Programı Düzenle";
  String get addExercise => _isEnglish ? "Add Exercise" : "Egzersiz Ekle";
  String get replace => _isEnglish ? "Replace" : "Değiştir";
  String get setsReps => _isEnglish ? "Sets/Reps" : "Set/Rep";
  String get deleteExercise => _isEnglish ? "Delete Exercise" : "Egzersizi Sil";
  String get deleteExerciseConfirm => _isEnglish ? "Are you sure you want to delete this exercise?" : "Bu egzersizi silmek istediğinize emin misiniz?";
  String get programUpdated => _isEnglish ? "Program updated!" : "Program güncellendi!";
  String get saveChanges => _isEnglish ? "Save Changes?" : "Değişiklikleri Kaydet?";
  String get unsavedChangesConfirm => _isEnglish ? "You have unsaved changes. Are you sure you want to exit?" : "Kaydedilmemiş değişiklikler var. Çıkmak istediğinize emin misiniz?";
  String get dontSave => _isEnglish ? "Don't Save" : "Kaydetme";
  String replacedWith(String exercise) => _isEnglish ? "Replaced with $exercise" : "$exercise ile değiştirildi";
  String get editSetsReps => _isEnglish ? "Edit Sets & Reps" : "Set ve Tekrar Düzenle";
  String get setCount => _isEnglish ? "Set Count" : "Set Sayısı";
  String get repsCount => _isEnglish ? "Reps (e.g., 8-10)" : "Tekrar (örn: 8-10)";
  
  // Active Workout
  String get completed => _isEnglish ? "completed! 🎉" : "tamamlandı! 🎉";
  String get workoutCompleted => _isEnglish ? "Workout Completed! 🎉" : "Antrenman Tamamlandı! 🎉";
  String get complete => _isEnglish ? "Complete" : "Tamamla";
  String get duration => _isEnglish ? "Duration" : "Süre";
  String get volume => _isEnglish ? "Volume" : "Hacim";
  String get finishWorkout => _isEnglish ? "Finish Workout?" : "Antrenmanı Bitir?";
  String get finishWorkoutConfirm => _isEnglish ? "Finish workout? Progress will not be saved." : "Antrenmanı bitirir misiniz? İlerleme kaydedilmeyecek.";
  String get continueWorkout => _isEnglish ? "Continue" : "Devam Et";
  String get finish => _isEnglish ? "Finish" : "Bitir";
  String get exerciseCompleted => _isEnglish ? "Exercise Completed!" : "Egzersiz Tamamlandı!";
  String get nextExercise => _isEnglish ? "Next Exercise" : "Sonraki Egzersiz";
  String get previous => _isEnglish ? "Previous" : "Önceki";
  String get skip => _isEnglish ? "Skip" : "Atla";
  
  // Exercise Picker
  String get selectExercise => _isEnglish ? "Select Exercise" : "Egzersiz Seç";
  String get searchExercise => _isEnglish ? "Search exercise..." : "Egzersiz ara...";
  String get allMuscles => _isEnglish ? "All Muscles" : "Tüm Kaslar";
  String exercisesFound(int count) => _isEnglish ? "$count exercises found" : "$count egzersiz bulundu";
  String get clearFilters => _isEnglish ? "Clear Filters" : "Filtreleri Temizle";
  String get noExercisesFound => _isEnglish ? "No exercises found" : "Egzersiz bulunamadı";

  // Helper to get localized body part / focus
  String getBodyPart(String focus) {
    final lowerFocus = focus.toLowerCase().trim();
    
    // Common combinations
    if (lowerFocus.contains('chest') && lowerFocus.contains('triceps')) return _isEnglish ? "Chest & Triceps" : "Göğüs & Arka Kol";
    if (lowerFocus.contains('back') && lowerFocus.contains('biceps')) return _isEnglish ? "Back & Biceps" : "Sırt & Ön Kol";
    if (lowerFocus.contains('legs') && lowerFocus.contains('shoulders')) return _isEnglish ? "Legs & Shoulders" : "Bacak & Omuz";
    if ((lowerFocus.contains('active') || lowerFocus.contains('aktif')) && lowerFocus.contains('core')) return _isEnglish ? "Active Recovery & Core" : "Aktif Dinlenme & Core";
    
    // Single body parts
    if (lowerFocus.contains('chest') || lowerFocus.contains('göğüs') || lowerFocus.contains('gogus')) return _isEnglish ? "Chest" : "Göğüs";
    if (lowerFocus.contains('back') || lowerFocus.contains('sırt') || lowerFocus.contains('sirt')) return _isEnglish ? "Back" : "Sırt";
    if (lowerFocus.contains('legs') || lowerFocus.contains('bacak')) return _isEnglish ? "Legs" : "Bacak";
    if (lowerFocus.contains('shoulders') || lowerFocus.contains('omuz')) return _isEnglish ? "Shoulders" : "Omuz";
    if (lowerFocus.contains('arms') || lowerFocus.contains('kol')) return _isEnglish ? "Arms" : "Kol";
    if (lowerFocus.contains('abs') || lowerFocus.contains('karın') || lowerFocus.contains('karin')) return _isEnglish ? "Abs" : "Karın";
    if (lowerFocus.contains('cardio') || lowerFocus.contains('kardiyo')) return _isEnglish ? "Cardio" : "Kardiyo";
    if (lowerFocus.contains('full') || lowerFocus.contains('tüm') || lowerFocus.contains('tum')) return _isEnglish ? "Full Body" : "Tüm Vücut";
    if (lowerFocus.contains('upper') || lowerFocus.contains('üst') || lowerFocus.contains('ust')) return _isEnglish ? "Upper Body" : "Üst Vücut";
    if (lowerFocus.contains('lower') || lowerFocus.contains('alt')) return _isEnglish ? "Lower Body" : "Alt Vücut";
    if (lowerFocus.contains('active') || lowerFocus.contains('aktif')) return _isEnglish ? "Active Recovery" : "Aktif Dinlenme";
    if (lowerFocus.contains('rest') || lowerFocus.contains('dinlenme')) return _isEnglish ? "Rest Day" : "Dinlenme Günü";
    
    return focus;
  }

  // Helper to get localized muscle name
  String getMuscleName(String muscle) {
    final lowerMuscle = muscle.toLowerCase().trim();
    switch (lowerMuscle) {
      case 'chest': return _isEnglish ? "Chest" : "Göğüs";
      case 'lats': 
      case 'back': return _isEnglish ? "Back" : "Sırt";
      case 'shoulders': return _isEnglish ? "Shoulders" : "Omuz";
      case 'quadriceps': 
      case 'legs': return _isEnglish ? "Legs" : "Ön Bacak";
      case 'hamstrings': return _isEnglish ? "Hamstrings" : "Arka Bacak";
      case 'glutes': return _isEnglish ? "Glutes" : "Kalça";
      case 'biceps': return _isEnglish ? "Biceps" : "Biceps";
      case 'triceps': return _isEnglish ? "Triceps" : "Triceps";
      case 'abs': return _isEnglish ? "Abs" : "Karın";
      case 'calves': return _isEnglish ? "Calves" : "Baldır";
      case 'traps': return _isEnglish ? "Traps" : "Trapez";
      case 'forearms': return _isEnglish ? "Forearms" : "Ön Kol";
      default: return muscle;
    }
  }

  // Helper to get localized equipment name
  String getEquipmentName(String equipment) {
    final lowerEquipment = equipment.toLowerCase().trim();
    switch (lowerEquipment) {
      case 'barbell': return _isEnglish ? "Barbell" : "Barbell";
      case 'dumbbell': return _isEnglish ? "Dumbbell" : "Dumbbell";
      case 'cable': return _isEnglish ? "Cable" : "Kablo";
      case 'body weight': 
      case 'bodyweight': return _isEnglish ? "Body Weight" : "Vücut Ağırlığı";
      case 'machine': return _isEnglish ? "Machine" : "Makine";
      case 'kettlebell': return _isEnglish ? "Kettlebell" : "Kettlebell";
      case 'bands': return _isEnglish ? "Bands" : "Direnç Bandı";
      default: return equipment;
    }
  }
}
