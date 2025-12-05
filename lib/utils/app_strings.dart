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
  
  // Equipment and Focus Areas (NEW)
  String get equipmentQuestion => _isEnglish ? "What equipment do you have?" : "Hangi ekipmanlara sahipsiniz?";
  String get dumbbells => _isEnglish ? "Dumbbells" : "Dumbbell";
  String get resistanceBands => _isEnglish ? "Resistance Bands" : "Direnç Bandı";
  String get bothEquipment => _isEnglish ? "Both" : "Her İkisi";
  String get noEquipment => _isEnglish ? "No Equipment" : "Ekipman Yok";
  
  String get focusAreasQuestion => _isEnglish ? "Which areas do you want to focus on?" : "Hangi bölgelere odaklanmak istiyorsunuz?";
  String get selectUpTo3 => _isEnglish ? "Select areas you want to focus on" : "Odaklanmak istediğiniz bölgeleri seçin";
  String get continueButton => _isEnglish ? "Continue" : "Devam";
  String get selectedCount => _isEnglish ? "selected" : "seçili";
  String get chest => _isEnglish ? "Chest" : "Göğüs";
  String get back => _isEnglish ? "Back" : "Sırt";
  String get shoulders => _isEnglish ? "Shoulders" : "Omuzlar";
  String get arms => _isEnglish ? "Arms" : "Kollar";
  String get legs => _isEnglish ? "Legs" : "Bacaklar";
  String get core => _isEnglish ? "Core" : "Karın";
  
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
  
  // Authentication & Registration
  String get register => _isEnglish ? "Register" : "Kayıt Ol";
  String get login => _isEnglish ? "Login" : "Giriş Yap";
  String get createAccount => _isEnglish ? "Create Account" : "Hesap Oluştur";
  String get alreadyHaveAccount => _isEnglish ? "Already have an account? Login" : "Zaten hesabınız var mı? Giriş Yap";
  String get dontHaveAccount => _isEnglish ? "Don't have an account? Sign up" : "Hesabınız yok mu? Kayıt Ol";
  
  // Email validation
  String get emailHint => _isEnglish ? "Email" : "E-posta";
  String get emailRequired => _isEnglish ? "Email is required" : "E-posta gerekli";
  String get emailInvalid => _isEnglish ? "Please enter a valid email" : "Geçerli bir e-posta girin";
  
  // Username validation
  String get usernameHint => _isEnglish ? "Username" : "Kullanıcı Adı";
  String get usernameRequired => _isEnglish ? "Username is required" : "Kullanıcı adı gerekli";
  String get usernameMinLength => _isEnglish ? "Username must be at least 3 characters" : "Kullanıcı adı en az 3 karakter olmalı";
  String get usernameMaxLength => _isEnglish ? "Username must be less than 20 characters" : "Kullanıcı adı 20 karakterden az olmalı";
  String get usernameFormat => _isEnglish ? "Username can only contain lowercase letters, numbers and underscores" : "Kullanıcı adı sadece küçük harf, rakam ve alt çizgi içerebilir";
  String get usernameAlreadyTaken => _isEnglish ? "Username is already taken" : "Kullanıcı adı zaten alınmış";
  
  // Password validation
  String get passwordHint => _isEnglish ? "Password" : "Şifre";
  String get passwordRequired => _isEnglish ? "Password is required" : "Şifre gerekli";
  String get passwordMinLength => _isEnglish ? "Password must be at least 6 characters" : "Şifre en az 6 karakter olmalı";
  String get confirmPassword => _isEnglish ? "Confirm Password" : "Şifreyi Onayla";
  String get confirmPasswordRequired => _isEnglish ? "Please confirm your password" : "Lütfen şifrenizi onaylayın";
  String get passwordsDoNotMatch => _isEnglish ? "Passwords do not match" : "Şifreler eşleşmiyor";
  
  // Registration messages
  String get registerSuccess => _isEnglish ? "Registration successful!" : "Kayıt başarılı!";
  String get registerSuccessDataSaved => _isEnglish ? "Account created! Your workout data has been saved." : "Hesap oluşturuldu! Antrenman verileriniz kaydedildi.";
  String get registerFailed => _isEnglish ? "Registration failed. Please try again." : "Kayıt başarısız. Lütfen tekrar deneyin.";
  String get guestAccountLinking => _isEnglish ? "You're currently using a guest account. Create an account to save your data permanently." : "Şu anda misafir hesap kullanıyorsunuz. Verilerinizi kalıcı olarak kaydetmek için hesap oluşturun.";
  String get saveGuestAccount => _isEnglish ? "Save Guest Account" : "Misafir Hesabı Kaydet";
  
  // Login messages
  String get loginSuccess => _isEnglish ? "Login successful!" : "Giriş başarılı!";
  String get loginFailed => _isEnglish ? "Login failed. Please check your credentials." : "Giriş başarısız. Lütfen bilgilerinizi kontrol edin.";
  String get welcomeBack => _isEnglish ? "Welcome Back!" : "Tekrar Hoş Geldin!";
  
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

  // Favorite Exercises (Quick Win Feature)
  String get favorites => _isEnglish ? "Favorites" : "Favoriler";
  String get allExercises => _isEnglish ? "All Exercises" : "Tüm Egzersizler";
  String get addedToFavorites => _isEnglish ? "Added to favorites" : "Favorilere eklendi";
  String get removedFromFavorites => _isEnglish ? "Removed from favorites" : "Favorilerden çıkarıldı";
  String get noFavoritesYet => _isEnglish ? "No favorites yet" : "Henüz favori yok";
  String get tapStarToAddFavorites => _isEnglish ? "Tap the star icon to add exercises to favorites" : "Favorilere eklemek için yıldız ikonuna tıklayın";

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

  // NEW PERSONALIZATION FEATURES
  // Profile
  String get profile => _isEnglish ? "Profile" : "Profil";
  String get bodyMeasurements => _isEnglish ? "Body Measurements" : "Vücut Ölçüleri";
  String get progressTracking => _isEnglish ? "Progress Tracking" : "Gelişim Takibi";
  String get name => _isEnglish ? "Name" : "İsim";
  String get yourName => _isEnglish ? "Your Name" : "Adınız";
  String get nameRequired => _isEnglish ? "Name is required" : "İsim gerekli";
  String get gender => _isEnglish ? "Gender" : "Cinsiyet";
  String get age => _isEnglish ? "Age" : "Yaş";
  String get yourAge => _isEnglish ? "Your Age" : "Yaşınız";
  String get years => _isEnglish ? "years" : "yıl";
  String get height => _isEnglish ? "Height" : "Boy";
  String get yourHeight => _isEnglish ? "Your Height" : "Boyunuz";
  String get cm => _isEnglish ? "cm" : "cm";
  String get targetWeight => _isEnglish ? "Target Weight" : "Hedef Kilo";
  String get yourTargetWeight => _isEnglish ? "Your target weight" : "Hedef kilonuz";
  String get kg => _isEnglish ? "kg" : "kg";
  String get bmi => _isEnglish ? "Body Mass Index (BMI)" : "Vücut Kitle İndeksi (BMI)";
  String get unknown => _isEnglish ? "Unknown" : "Bilinmiyor";
  String get underweight => _isEnglish ? "Underweight" : "Zayıf";
  String get normal => _isEnglish ? "Normal" : "Normal";
  String get overweight => _isEnglish ? "Overweight" : "Fazla Kilolu";
  String get obese => _isEnglish ? "Obese" : "Obez";
  String get profileUpdated => _isEnglish ? "Profile updated" : "Profil güncellendi";

  // Measurements
  String get measurements => _isEnglish ? "Measurements" : "Ölçüler";
  String get addNewMeasurement => _isEnglish ? "Add New Measurement" : "Yeni Ölçüm Ekle";
  String get weight => _isEnglish ? "Weight" : "Kilo";
  String get weightRequired => _isEnglish ? "Weight (kg) *" : "Kilo (kg) *";
  String get chestMeasurement => _isEnglish ? "Chest (cm)" : "Göğüs (cm)";
  String get waistMeasurement => _isEnglish ? "Waist (cm)" : "Bel (cm)";
  String get hipsMeasurement => _isEnglish ? "Hips (cm)" : "Kalça (cm)";
  String get armsMeasurement => _isEnglish ? "Arms (cm)" : "Kol (cm)";
  String get thighsMeasurement => _isEnglish ? "Thighs (cm)" : "Bacak (cm)";
  String get notes => _isEnglish ? "Notes" : "Notlar";
  String get currentWeight => _isEnglish ? "Current Weight" : "Mevcut Kilo";
  String get firstMeasurement => _isEnglish ? "First measurement" : "İlk ölçüm";
  String get weightChart => _isEnglish ? "Weight Chart" : "Kilo Grafiği";
  String get measurementHistory => _isEnglish ? "Measurement History" : "Geçmiş Ölçümler";
  String get noMeasurementsYet => _isEnglish ? "No measurements yet" : "Henüz ölçüm yok";
  String get addFirstMeasurement => _isEnglish ? "Add your first measurement to track progress" : "İlerlemenizi takip etmek için ilk ölçümünüzü ekleyin";
  String get measurementAdded => _isEnglish ? "Measurement added" : "Ölçüm eklendi";
  String get thisFieldRequired => _isEnglish ? "This field is required" : "Bu alan gerekli";

  // Statistics
  String get fitnessScore => _isEnglish ? "Your Fitness Score" : "Fitness Skorunuz";
  String get totalWorkouts => _isEnglish ? "Total" : "Toplam";
  String get workouts => _isEnglish ? "Workouts" : "Antrenman";
  String get currentStreak => _isEnglish ? "Streak" : "Seri";
  String get totalVolume => _isEnglish ? "Volume" : "Hacim";
  String get averageTime => _isEnglish ? "Average" : "Ortalama";
  String get weeklyActivity => _isEnglish ? "Weekly Activity" : "Haftalık Aktivite";
  String get achievements => _isEnglish ? "Achievements" : "Başarılar";
  String get achievementsUnlocked => _isEnglish ? "Achievements Unlocked" : "Başarı Açıldı";
  String get earnedAchievements => _isEnglish ? "Earned Achievements" : "Kazanılan Başarılar";
  String get unlocked => _isEnglish ? "Unlocked!" : "Açıldı!";
  String get notUnlockedYet => _isEnglish ? "Not unlocked yet" : "Henüz açılmadı";
  String get close => _isEnglish ? "Close" : "Kapat";
  String get unlockedOn => _isEnglish ? "Unlocked on:" : "Açıldı:";

  // Score labels
  String get scoreLegend => _isEnglish ? "Legend" : "Efsane";
  String get scoreGreat => _isEnglish ? "Great" : "Harika";
  String get scoreGood => _isEnglish ? "Good" : "İyi";
  String get scoreBeginner => _isEnglish ? "Beginner" : "Başlangıç";
  String get scoreKeepGoing => _isEnglish ? "Keep Going" : "Devam Et";

  // Day short names
  String get dayMon => _isEnglish ? "Mon" : "Pzt";
  String get dayTue => _isEnglish ? "Tue" : "Sal";
  String get dayWed => _isEnglish ? "Wed" : "Çar";
  String get dayThu => _isEnglish ? "Thu" : "Per";
  String get dayFri => _isEnglish ? "Fri" : "Cum";
  String get daySat => _isEnglish ? "Sat" : "Cmt";
  String get daySun => _isEnglish ? "Sun" : "Paz";

  // Helper to get score label based on score value
  String getScoreLabel(int score) {
    if (score >= 80) return scoreLegend;
    if (score >= 60) return scoreGreat;
    if (score >= 40) return scoreGood;
    if (score >= 20) return scoreBeginner;
    return scoreKeepGoing;
  }

  // Helper to get short day name by index (0 = Mon)
  String getDayShortName(int dayIndex) {
    switch (dayIndex) {
      case 0: return dayMon;
      case 1: return dayTue;
      case 2: return dayWed;
      case 3: return dayThu;
      case 4: return dayFri;
      case 5: return daySat;
      case 6: return daySun;
      default: return '';
    }
  }

  // Progress screen specific
  String get progress => _isEnglish ? "Progress" : "İlerleme";
  String get thisWeek => _isEnglish ? "This Week" : "Bu Hafta";
  String get thisMonth => _isEnglish ? "This Month" : "Bu Ay";
  String get workoutCalendar => _isEnglish ? "Workout Calendar" : "Antrenman Takvimi";
  String get completedLabel => _isEnglish ? "Completed" : "Tamamlandı"; // For calendar legend
  String get recentWorkouts => _isEnglish ? "Recent Workouts" : "Son Antrenmanlar";
  String get set => _isEnglish ? "set" : "set";
  String get rep => _isEnglish ? "rep" : "tekrar";

  // Month names
  String get january => _isEnglish ? "January" : "Ocak";
  String get february => _isEnglish ? "February" : "Şubat";
  String get march => _isEnglish ? "March" : "Mart";
  String get april => _isEnglish ? "April" : "Nisan";
  String get may => _isEnglish ? "May" : "Mayıs";
  String get june => _isEnglish ? "June" : "Haziran";
  String get july => _isEnglish ? "July" : "Temmuz";
  String get august => _isEnglish ? "August" : "Ağustos";
  String get september => _isEnglish ? "September" : "Eylül";
  String get october => _isEnglish ? "October" : "Ekim";
  String get november => _isEnglish ? "November" : "Kasım";
  String get december => _isEnglish ? "December" : "Aralık";

  // Helper to get month name by number (1-12)
  String getMonthName(int month) {
    switch (month) {
      case 1: return january;
      case 2: return february;
      case 3: return march;
      case 4: return april;
      case 5: return may;
      case 6: return june;
      case 7: return july;
      case 8: return august;
      case 9: return september;
      case 10: return october;
      case 11: return november;
      case 12: return december;
      default: return '';
    }
  }

  // Rest Timer
  String get restTime => _isEnglish ? "Rest Time" : "Dinlenme Süresi";
  String get restTimer => _isEnglish ? "Rest Timer" : "Dinlenme Zamanlayıcısı";
  String get selectRestDuration => _isEnglish ? "Select Rest Duration" : "Dinlenme Süresi Seç";
  String get customDuration => _isEnglish ? "Custom" : "Özel";
  String get seconds => _isEnglish ? "seconds" : "saniye";
  String get addTime => _isEnglish ? "+15s" : "+15sn";
  String get removeTime => _isEnglish ? "-15s" : "-15sn";
  String get skipRest => _isEnglish ? "Skip Rest" : "Dinlenmeyi Atla";
  String get startRest => _isEnglish ? "Start Rest" : "Dinlenmeyi Başlat";
  String get restComplete => _isEnglish ? "Rest Complete!" : "Dinlenme Tamamlandı!";
  String get readyForNextSet => _isEnglish ? "Ready for next set" : "Sonraki set için hazır";

  // Water Tracker
  String get waterIntake => _isEnglish ? "Water Intake" : "Su Tüketimi";
  String get dailyWaterGoal => _isEnglish ? "Daily Goal" : "Günlük Hedef";
  String get waterGoal => _isEnglish ? "Water Goal" : "Su Hedefi";
  String get glasses => _isEnglish ? "glasses" : "bardak";
  String get addGlass => _isEnglish ? "Add Glass" : "Bardak Ekle";
  String get setGoal => _isEnglish ? "Set Goal" : "Hedef Belirle";
  String get goalReached => _isEnglish ? "Goal Reached!" : "Hedef Tamamlandı!";
  String get remaining => _isEnglish ? "Remaining" : "Kalan";
  String get consumed => _isEnglish ? "Consumed" : "İçilen";
  String get ml => _isEnglish ? "ml" : "ml";
  String get liters => _isEnglish ? "L" : "L";
  
  // Rest Day
  String get restDay => _isEnglish ? "Rest Day" : "Dinlenme Günü";
  String get restDayMessage => _isEnglish 
    ? "Take this day to recover and let your muscles rebuild stronger. Rest is a crucial part of your fitness journey!" 
    : "Bugün dinlen ve kasların daha güçlü bir şekilde yeniden inşa edilsin. Dinlenme, fitness yolculuğunun en önemli parçasıdır!";
  String get restDayTip => _isEnglish 
    ? "Stay active with light stretching or walking" 
    : "Hafif esneme veya yürüyüşle aktif kal";
  
  // Body Metrics Calculator
  String get bodyMetricsCalculator => _isEnglish ? "Body Metrics Calculator" : "Vücut Metrikleri Hesaplayıcı";
  String get optionalMeasurements => _isEnglish ? "Optional Measurements" : "Opsiyonel Ölçümler";
  String get navyMethodNote => _isEnglish 
    ? "Required for Navy Method (body fat percentage)" 
    : "Navy Method için gerekli (vücut yağ oranı)";
  String get neckMeasurement => _isEnglish ? "Neck" : "Boyun";
  String get calculate => _isEnglish ? "Calculate" : "Hesapla";
  String get results => _isEnglish ? "Results" : "Sonuçlar";
  String get bodyFatPercentage => _isEnglish ? "Body Fat Percentage" : "Vücut Yağ Oranı";
  String get waistHipRatio => _isEnglish ? "Waist-Hip Ratio" : "Bel-Kalça Oranı";
  
  // Body fat categories
  String get essentialFat => _isEnglish ? "Essential Fat" : "Temel Yağ";
  String get athlete => _isEnglish ? "Athlete" : "Atlet";
  String get fitness => _isEnglish ? "Fitness" : "Fit";
  String get average => _isEnglish ? "Average" : "Ortalama";
  String get highBodyFat => _isEnglish ? "High" : "Yüksek";
  
  // Health risk categories
  String get lowRisk => _isEnglish ? "Low Risk" : "Düşük Risk";
  String get moderateRisk => _isEnglish ? "Moderate Risk" : "Orta Risk";
  String get highRisk => _isEnglish ? "High Risk" : "Yüksek Risk";
  
  // Enhanced Onboarding - Equipment Types
  String get fullGym => _isEnglish ? "Full Gym" : "Tam Donanımlı Salon";
  String get fullGymDesc => _isEnglish ? "All equipment available" : "Tüm ekipmanlara erişim";
  String get barbells => _isEnglish ? "Barbells" : "Halterler";
  String get barbellsDesc => _isEnglish ? "Barbell exercises" : "Halter çalışmaları";
  String get dumbbell => _isEnglish ? "Dumbbells" : "Dum bıllar";
  String get dumbbellDesc => _isEnglish ? "Dumbbell training" : "Dambıl antrenmanları";
  String get kettlebells => _isEnglish ? "Kettlebells" : "Kettlebell'ler";
  String get kettlebellsDesc => _isEnglish ? "Kettlebell workouts" : "Kettlebell çalışmaları";
  String get machines => _isEnglish ? "Machines" : "Makineler";
  String get machinesDesc => _isEnglish ? "Machine-based training" : "Makine tabanlı antrenman";
  String get bodyweightOnly => _isEnglish ? "No Equipment" : "Hiçbiri";
  String get bodyweightOnlyDesc => _isEnglish ? "Bodyweight exercises only" : "Sadece vücut ağırlığı";
  String get equipmentSelectionTitle => _isEnglish ? "What equipment do you have access to?" : "Hangi ekipmanlara sahipsiniz?";
  String get equipmentSelectionDesc => _isEnglish ? "Select all that apply" : "Ayrıntıları daha sonra değiştirebilirsiniz";
  
  // Anatomical Body Parts
  String get selectFocusAreas => _isEnglish ? "Select focus areas you want to train" : "Odaklanmak istediğin alanları seç";
  String get frontView => _isEnglish ? "Front" : "Ön";
  String get backView => _isEnglish ? "Back" : "Arka";
  String get glutes => _isEnglish ? "Glutes" : "Kalçalar";
  String get fullBody => _isEnglish ? "Full Body" : "Tüm Vücut";
  
  // Body Type
  String get bodyTypeQuestion => _isEnglish ? "What's your body type?" : "Vücut tipiniz?";
  String get bodyTypeOptional => _isEnglish ? "(Optional)" : "(Opsiyonel)";
  String get ectomorph => _isEnglish ? "Ectomorph" : "Ectomorph";
  String get ectomorphDesc => _isEnglish ? "Lean, fast metabolism" : "İnce, hızlı metabolizma";
  String get mesomorph => _isEnglish ? "Mesomorph" : "Mesomorph";
  String get mesomorphDesc => _isEnglish ? "Athletic, muscular build" : "Atletik, kaslı yapı";
  String get endomorph => _isEnglish ? "Endomorph" : "Endomorph";
  String get endomorphDesc => _isEnglish ? "Stores fat easily" : "Kolay kilo alır";
  String get skipQuestion => _isEnglish ? "Skip" : "Atla";
  
  // Experience Level (detailed)
  String get experienceQuestion => _isEnglish ? "How long have you been training?" : "Ne kadar süredir antrenman yapıyorsun?";
  String get newbie => _isEnglish ? "New (0-6 months)" : "Yeni (0-6 ay)";
  String get beginnerExp => _isEnglish ? "Beginner (6-12 months)" : "Başlangıç (6-12 ay)";
  String get intermediateExp => _isEnglish ? "Intermediate (1-2 years)" : "Orta (1-2 yıl)";
  String get removeFriend => _isEnglish ? "Remove Friend" : "Arkadaşı Çıkar";
  String get friendRequest => _isEnglish ? "Friend request" : "Arkadaşlık isteği";
  String get friendRequestSent => _isEnglish ? "✅ Friend request sent!" : "✅ Arkadaşlık isteği gönderildi!";
  String get friendRequestAccepted => _isEnglish ? "✅ Friend request accepted!" : "✅ Arkadaşlık isteği kabul edildi!";
  String get friendRemoved => _isEnglish ? "Friend removed" : "Arkadaş çıkarıldı";
  String get requestRejected => _isEnglish ? "Request rejected" : "İstek reddedildi";
  String get accept => _isEnglish ? "Accept" : "Kabul Et";
  String get reject => _isEnglish ? "Reject" : "Reddet";
  String get friend => _isEnglish ? "Friend" : "Arkadaş";
  String get noFriendsYet => _isEnglish ? "No friends yet\nAdd friends to compete!" : "Henüz arkadaşın yok\nYarışmak için arkadaş ekle!";
  String get noPendingRequests => _isEnglish ? "No pending requests" : "Bekleyen istek yok";
  String get removeFriendConfirm => _isEnglish ? "Are you sure you want to remove this friend?" : "Bu arkadaşı çıkarmak istediğinize emin misiniz?";
  
  // Search Users
  String get searchUsers => _isEnglish ? "🔍 Search Users" : "🔍 Kullanıcı Ara";
  String get searchByUsername => _isEnglish ? "Search by username (@username)..." : "Kullanıcı adıyla ara (@kullaniciadi)...";
  String get searchForFriends => _isEnglish ? "Search for friends\nby their name" : "İsimlerine göre\narkadaş ara";
  String get noUsersFound => _isEnglish ? "No users found" : "Kullanıcı bulunamadı";
  String get add => _isEnglish ? "Add" : "Ekle";
  String get searchError => _isEnglish ? "Search error" : "Arama hatası";
  String get user => _isEnglish ? "User" : "Kullanıcı";
  String get alreadyFriends => _isEnglish ? "You are already friends!" : "Zaten arkadaşsınız!";
  String get requestAlreadySent => _isEnglish ? "Friend request already sent!" : "Arkadaşlık isteği zaten gönderildi!";
  
  // Leaderboard
  String get leaderboard => _isEnglish ? "🏆 Leaderboard" : "🏆 Lider Tablosu";
  String get showFriends => _isEnglish ? "Show Friends" : "Arkadaşları Göster";
  String get showGlobal => _isEnglish ? "Show Global" : "Herkesi Göster";
  String get kgTotal => _isEnglish ? "kg total" : "kg toplam";
  String get you => _isEnglish ? "YOU" : "SEN";
  String get noLeaderboardData => _isEnglish ? "No leaderboard data yet\nComplete workouts to rank!" : "Henüz lider tablosu verisi yok\nSıralamaya girmek için antrenman tamamla!";
  String get errorLoadingLeaderboard => _isEnglish ? "Error loading leaderboard" : "Lider tablosu yüklenirken hata";
  
  // Settings Screen
  String get settingsTitle => _isEnglish ? "Settings" : "Ayarlar";
  String get themeTitle => _isEnglish ? "THEME" : "TEMA";
  String get themeSystem => _isEnglish ? "System" : "Sistem";
  String get themeSystemDesc => _isEnglish ? "Follow system theme" : "Cihaz temasını takip et";
  String get themeLight => _isEnglish ? "Light" : "Aydınlık";
  String get themeLightDesc => _isEnglish ? "Use light theme" : "Aydınlık tema kullan";
  String get themeDark => _isEnglish ? "Dark" : "Karanlık";
  String get themeDarkDesc => _isEnglish ? "Use dark theme" : "Karanlık tema kullan";
  String get notificationsTitle => _isEnglish ? "NOTIFICATIONS" : "BİLDİRİMLER";
  String get notificationSettingsDesc => _isEnglish ? "Workout reminders and notifications" : "Antrenman hatırlatıcıları ve bildirimler";
  String get themeInfo => _isEnglish ? "Your theme preference is saved and used every time you open the app." : "Tema tercihiniz kaydedilir ve uygulamayı her açtığınızda kullanılır.";

  // Friends Screen
  String get friendsTitle => _isEnglish ? "Friends" : "Arkadaşlar";
  String get friends => _isEnglish ? "Friends" : "Arkadaşlar";
  String get requests => _isEnglish ? "Requests" : "İstekler";
  String get addFriend => _isEnglish ? "Add Friend" : "Arkadaş Ekle";
  String get addFriends => _isEnglish ? "Add Friends" : "Arkadaş Ekle";

  // Onboarding - Injuries
  String get injuryQuestion => _isEnglish ? "Do you have any injuries?" : "Herhangi bir sakatlığınız var mı?";
  String get advancedExp => _isEnglish ? "Advanced (2+ years)" : "İleri (2+ yıl)";
  String get backPain => _isEnglish ? "Back Pain" : "Sırt Ağrısı";
  String get kneePain => _isEnglish ? "Knee Pain" : "Diz Ağrısı";
  String get shoulderPain => _isEnglish ? "Shoulder Pain" : "Omuz Ağrısı";
  String get otherInjury => _isEnglish ? "Other" : "Diğer";
  String get noInjuries => _isEnglish ? "No Injuries" : "Sakatlık Yok";

  // Notification Settings
  String get notificationSettings => _isEnglish ? "Notification Settings" : "Bildirim Ayarları";
  String get notifications => _isEnglish ? "Notifications" : "Bildirimler";
  String get notificationPermissionRequired => _isEnglish ? "Notification permission is required" : "Bildirim izni gerekli";
  String get enableNotifications => _isEnglish ? "Enable Notifications" : "Bildirimleri Aç";
  String get dailyReminder => _isEnglish ? "Daily Reminder" : "Günlük Hatırlatıcı";
  String get reminderTime => _isEnglish ? "Reminder Time" : "Hatırlatma Zamanı";
  String get streakWarnings => _isEnglish ? "Streak Warnings" : "Seri Uyarıları";
  String get achievementNotifications => _isEnglish ? "Achievements" : "Başarılar";
  String get prCelebrations => _isEnglish ? "PR Celebrations" : "Rekor Kutlamaları";
  String get restDayReminders => _isEnglish ? "Rest Day Reminders" : "Dinlenme Günü Hatırlatıcıları";
  String get testNotification => _isEnglish ? "Test Notification" : "Test Bildirimi";
  String get notifDailyWorkoutBody => _isEnglish ? "Time for your workout! 💪" : "Antrenman zamanı! 💪";
}
