import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'GymGenius'**
  String get appTitle;

  /// No description provided for @genderQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s your gender?'**
  String get genderQuestion;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @goalQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s your goal?'**
  String get goalQuestion;

  /// No description provided for @loseWeight.
  ///
  /// In en, this message translates to:
  /// **'Lose Weight'**
  String get loseWeight;

  /// No description provided for @buildMuscle.
  ///
  /// In en, this message translates to:
  /// **'Build Muscle'**
  String get buildMuscle;

  /// No description provided for @getStronger.
  ///
  /// In en, this message translates to:
  /// **'Get Stronger'**
  String get getStronger;

  /// No description provided for @getFit.
  ///
  /// In en, this message translates to:
  /// **'Get Fit'**
  String get getFit;

  /// No description provided for @levelQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s your level?'**
  String get levelQuestion;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @planDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan Details'**
  String get planDetailsTitle;

  /// No description provided for @whereToWorkout.
  ///
  /// In en, this message translates to:
  /// **'Where will you workout?'**
  String get whereToWorkout;

  /// No description provided for @gym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get gym;

  /// No description provided for @homeDumbbell.
  ///
  /// In en, this message translates to:
  /// **'Home (Dumbbell)'**
  String get homeDumbbell;

  /// No description provided for @weeklyWorkout.
  ///
  /// In en, this message translates to:
  /// **'Weekly Workout'**
  String get weeklyWorkout;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @createProgramButton.
  ///
  /// In en, this message translates to:
  /// **'CREATE PROGRAM 🚀'**
  String get createProgramButton;

  /// No description provided for @myPrograms.
  ///
  /// In en, this message translates to:
  /// **'My Programs'**
  String get myPrograms;

  /// No description provided for @errorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your connection.'**
  String get errorNoInternet;

  /// No description provided for @errorApiKey.
  ///
  /// In en, this message translates to:
  /// **'API key not configured. Please contact app developer.'**
  String get errorApiKey;

  /// No description provided for @errorEmptyResponse.
  ///
  /// In en, this message translates to:
  /// **'AI service did not respond. Please try again.'**
  String get errorEmptyResponse;

  /// No description provided for @errorParsing.
  ///
  /// In en, this message translates to:
  /// **'Error processing program data. Please try again.'**
  String get errorParsing;

  /// No description provided for @errorEmptyProgram.
  ///
  /// In en, this message translates to:
  /// **'Could not create program. Please try different settings.'**
  String get errorEmptyProgram;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while creating program. Please try again.'**
  String get errorGeneric;

  /// No description provided for @saveProgram.
  ///
  /// In en, this message translates to:
  /// **'Save Program'**
  String get saveProgram;

  /// No description provided for @programName.
  ///
  /// In en, this message translates to:
  /// **'Give your program a name'**
  String get programName;

  /// No description provided for @programNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., My Summer Program'**
  String get programNameHint;

  /// No description provided for @programNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get programNameError;

  /// No description provided for @programNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get programNameTooShort;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @sets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get sets;

  /// No description provided for @reps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get reps;

  /// No description provided for @exercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exercise;

  /// No description provided for @exercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercises;

  /// No description provided for @programReady.
  ///
  /// In en, this message translates to:
  /// **'Your Program is Ready! 🔥'**
  String get programReady;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @programLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load program.'**
  String get programLoadError;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @programSaved.
  ///
  /// In en, this message translates to:
  /// **'saved!'**
  String get programSaved;

  /// No description provided for @programAlreadySaved.
  ///
  /// In en, this message translates to:
  /// **'This program is already saved!'**
  String get programAlreadySaved;

  /// No description provided for @totalSets.
  ///
  /// In en, this message translates to:
  /// **'Total Sets'**
  String get totalSets;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome! 👋'**
  String get welcome;

  /// No description provided for @readyForGoals.
  ///
  /// In en, this message translates to:
  /// **'Ready to reach your goals?'**
  String get readyForGoals;

  /// No description provided for @recentPrograms.
  ///
  /// In en, this message translates to:
  /// **'Recent Programs'**
  String get recentPrograms;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @createNewProgram.
  ///
  /// In en, this message translates to:
  /// **'Create New Program'**
  String get createNewProgram;

  /// No description provided for @customWorkoutProgram.
  ///
  /// In en, this message translates to:
  /// **'Custom workout program for your goals'**
  String get customWorkoutProgram;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @program.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get program;

  /// No description provided for @programs.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get programs;

  /// No description provided for @totalDays.
  ///
  /// In en, this message translates to:
  /// **'Total Days'**
  String get totalDays;

  /// No description provided for @savedPrograms.
  ///
  /// In en, this message translates to:
  /// **'Saved Programs'**
  String get savedPrograms;

  /// No description provided for @noProgramsYet.
  ///
  /// In en, this message translates to:
  /// **'No programs yet'**
  String get noProgramsYet;

  /// No description provided for @createFirstProgram.
  ///
  /// In en, this message translates to:
  /// **'Create your first workout program!'**
  String get createFirstProgram;

  /// No description provided for @daysPerWeek.
  ///
  /// In en, this message translates to:
  /// **'days/week'**
  String get daysPerWeek;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this program?'**
  String get deleteConfirm;

  /// No description provided for @renameProgram.
  ///
  /// In en, this message translates to:
  /// **'Rename Program'**
  String get renameProgram;

  /// No description provided for @newName.
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get newName;

  /// No description provided for @newProgram.
  ///
  /// In en, this message translates to:
  /// **'New Program'**
  String get newProgram;

  /// No description provided for @programDeleted.
  ///
  /// In en, this message translates to:
  /// **'Program deleted'**
  String get programDeleted;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get daysAgo;

  /// No description provided for @weeksAgo.
  ///
  /// In en, this message translates to:
  /// **'weeks ago'**
  String get weeksAgo;

  /// No description provided for @monthsAgo.
  ///
  /// In en, this message translates to:
  /// **'months ago'**
  String get monthsAgo;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @createProgramTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Program'**
  String get createProgramTitle;

  /// No description provided for @designYourProgram.
  ///
  /// In en, this message translates to:
  /// **'Design Your Program'**
  String get designYourProgram;

  /// No description provided for @designProgramDesc.
  ///
  /// In en, this message translates to:
  /// **'Define program details and start adding exercises.'**
  String get designProgramDesc;

  /// No description provided for @weeklyTraining.
  ///
  /// In en, this message translates to:
  /// **'Weekly Training'**
  String get weeklyTraining;

  /// No description provided for @createAndEdit.
  ///
  /// In en, this message translates to:
  /// **'Create and Edit'**
  String get createAndEdit;

  /// No description provided for @createWithAI.
  ///
  /// In en, this message translates to:
  /// **'Create with AI'**
  String get createWithAI;

  /// No description provided for @createWithAIDesc.
  ///
  /// In en, this message translates to:
  /// **'Let AI create a custom program for you'**
  String get createWithAIDesc;

  /// No description provided for @createManually.
  ///
  /// In en, this message translates to:
  /// **'Create Manually'**
  String get createManually;

  /// No description provided for @createManuallyDesc.
  ///
  /// In en, this message translates to:
  /// **'Design your program from scratch'**
  String get createManuallyDesc;

  /// No description provided for @editProgram.
  ///
  /// In en, this message translates to:
  /// **'Edit Program'**
  String get editProgram;

  /// No description provided for @addExercise.
  ///
  /// In en, this message translates to:
  /// **'Add Exercise'**
  String get addExercise;

  /// No description provided for @replace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replace;

  /// No description provided for @setsReps.
  ///
  /// In en, this message translates to:
  /// **'Sets/Reps'**
  String get setsReps;

  /// No description provided for @deleteExercise.
  ///
  /// In en, this message translates to:
  /// **'Delete Exercise'**
  String get deleteExercise;

  /// No description provided for @deleteExerciseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this exercise?'**
  String get deleteExerciseConfirm;

  /// No description provided for @programUpdated.
  ///
  /// In en, this message translates to:
  /// **'Program updated!'**
  String get programUpdated;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes?'**
  String get saveChanges;

  /// No description provided for @unsavedChangesConfirm.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to exit?'**
  String get unsavedChangesConfirm;

  /// No description provided for @dontSave.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Save'**
  String get dontSave;

  /// No description provided for @replacedWith.
  ///
  /// In en, this message translates to:
  /// **'Replaced with'**
  String get replacedWith;

  /// No description provided for @editSetsReps.
  ///
  /// In en, this message translates to:
  /// **'Edit Sets & Reps'**
  String get editSetsReps;

  /// No description provided for @setCount.
  ///
  /// In en, this message translates to:
  /// **'Set Count'**
  String get setCount;

  /// No description provided for @repsCount.
  ///
  /// In en, this message translates to:
  /// **'Reps (e.g., 8-10)'**
  String get repsCount;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'completed! 🎉'**
  String get completed;

  /// No description provided for @workoutCompleted.
  ///
  /// In en, this message translates to:
  /// **'Workout Completed! 🎉'**
  String get workoutCompleted;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// No description provided for @finishWorkout.
  ///
  /// In en, this message translates to:
  /// **'Finish Workout?'**
  String get finishWorkout;

  /// No description provided for @finishWorkoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Finish workout? Progress will not be saved.'**
  String get finishWorkoutConfirm;

  /// No description provided for @continueWorkout.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueWorkout;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @exerciseCompleted.
  ///
  /// In en, this message translates to:
  /// **'Exercise Completed!'**
  String get exerciseCompleted;

  /// No description provided for @nextExercise.
  ///
  /// In en, this message translates to:
  /// **'Next Exercise'**
  String get nextExercise;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @selectExercise.
  ///
  /// In en, this message translates to:
  /// **'Select Exercise'**
  String get selectExercise;

  /// No description provided for @searchExercise.
  ///
  /// In en, this message translates to:
  /// **'Search exercise...'**
  String get searchExercise;

  /// No description provided for @allMuscles.
  ///
  /// In en, this message translates to:
  /// **'All Muscles'**
  String get allMuscles;

  /// No description provided for @exercisesFound.
  ///
  /// In en, this message translates to:
  /// **'exercises found'**
  String get exercisesFound;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @noExercisesFound.
  ///
  /// In en, this message translates to:
  /// **'No exercises found'**
  String get noExercisesFound;

  /// No description provided for @equipmentQuestion.
  ///
  /// In en, this message translates to:
  /// **'What equipment do you have?'**
  String get equipmentQuestion;

  /// No description provided for @dumbbells.
  ///
  /// In en, this message translates to:
  /// **'Dumbbells'**
  String get dumbbells;

  /// No description provided for @resistanceBands.
  ///
  /// In en, this message translates to:
  /// **'Resistance Bands'**
  String get resistanceBands;

  /// No description provided for @bothEquipment.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get bothEquipment;

  /// No description provided for @noEquipment.
  ///
  /// In en, this message translates to:
  /// **'No Equipment'**
  String get noEquipment;

  /// No description provided for @focusAreasQuestion.
  ///
  /// In en, this message translates to:
  /// **'Which areas do you want to focus on?'**
  String get focusAreasQuestion;

  /// No description provided for @selectUpTo3.
  ///
  /// In en, this message translates to:
  /// **'Select areas you want to focus on'**
  String get selectUpTo3;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @arms.
  ///
  /// In en, this message translates to:
  /// **'Arms'**
  String get arms;

  /// No description provided for @legs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get legs;

  /// No description provided for @core.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get core;

  /// No description provided for @chest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get chest;

  /// No description provided for @lats.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get lats;

  /// No description provided for @shoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get shoulders;

  /// No description provided for @quadriceps.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get quadriceps;

  /// No description provided for @hamstrings.
  ///
  /// In en, this message translates to:
  /// **'Hamstrings'**
  String get hamstrings;

  /// No description provided for @glutes.
  ///
  /// In en, this message translates to:
  /// **'Glutes'**
  String get glutes;

  /// No description provided for @biceps.
  ///
  /// In en, this message translates to:
  /// **'Biceps'**
  String get biceps;

  /// No description provided for @triceps.
  ///
  /// In en, this message translates to:
  /// **'Triceps'**
  String get triceps;

  /// No description provided for @abs.
  ///
  /// In en, this message translates to:
  /// **'Abs'**
  String get abs;

  /// No description provided for @calves.
  ///
  /// In en, this message translates to:
  /// **'Calves'**
  String get calves;

  /// No description provided for @traps.
  ///
  /// In en, this message translates to:
  /// **'Traps'**
  String get traps;

  /// No description provided for @forearms.
  ///
  /// In en, this message translates to:
  /// **'Forearms'**
  String get forearms;

  /// No description provided for @barbell.
  ///
  /// In en, this message translates to:
  /// **'Barbell'**
  String get barbell;

  /// No description provided for @dumbbell.
  ///
  /// In en, this message translates to:
  /// **'Dumbbell'**
  String get dumbbell;

  /// No description provided for @cable.
  ///
  /// In en, this message translates to:
  /// **'Cable'**
  String get cable;

  /// No description provided for @bodyWeight.
  ///
  /// In en, this message translates to:
  /// **'Body Weight'**
  String get bodyWeight;

  /// No description provided for @machine.
  ///
  /// In en, this message translates to:
  /// **'Machine'**
  String get machine;

  /// No description provided for @kettlebell.
  ///
  /// In en, this message translates to:
  /// **'Kettlebell'**
  String get kettlebell;

  /// No description provided for @bands.
  ///
  /// In en, this message translates to:
  /// **'Bands'**
  String get bands;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @bodyMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Body Measurements'**
  String get bodyMeasurements;

  /// No description provided for @progressTracking.
  ///
  /// In en, this message translates to:
  /// **'Progress Tracking'**
  String get progressTracking;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @yourAge.
  ///
  /// In en, this message translates to:
  /// **'Your Age'**
  String get yourAge;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @yourHeight.
  ///
  /// In en, this message translates to:
  /// **'Your Height'**
  String get yourHeight;

  /// No description provided for @cm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get cm;

  /// No description provided for @targetWeight.
  ///
  /// In en, this message translates to:
  /// **'Target Weight'**
  String get targetWeight;

  /// No description provided for @yourTargetWeight.
  ///
  /// In en, this message translates to:
  /// **'Your target weight'**
  String get yourTargetWeight;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @bmi.
  ///
  /// In en, this message translates to:
  /// **'Body Mass Index (BMI)'**
  String get bmi;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @underweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get underweight;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @overweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get overweight;

  /// No description provided for @obese.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get obese;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @measurements.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get measurements;

  /// No description provided for @addNewMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Add New Measurement'**
  String get addNewMeasurement;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @weightRequired.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg) *'**
  String get weightRequired;

  /// No description provided for @chestMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Chest (cm)'**
  String get chestMeasurement;

  /// No description provided for @waistMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Waist (cm)'**
  String get waistMeasurement;

  /// No description provided for @hipsMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Hips (cm)'**
  String get hipsMeasurement;

  /// No description provided for @armsMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Arms (cm)'**
  String get armsMeasurement;

  /// No description provided for @thighsMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Thighs (cm)'**
  String get thighsMeasurement;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @currentWeight.
  ///
  /// In en, this message translates to:
  /// **'Current Weight'**
  String get currentWeight;

  /// No description provided for @firstMeasurement.
  ///
  /// In en, this message translates to:
  /// **'First measurement'**
  String get firstMeasurement;

  /// No description provided for @weightChart.
  ///
  /// In en, this message translates to:
  /// **'Weight Chart'**
  String get weightChart;

  /// No description provided for @measurementHistory.
  ///
  /// In en, this message translates to:
  /// **'Measurement History'**
  String get measurementHistory;

  /// No description provided for @noMeasurementsYet.
  ///
  /// In en, this message translates to:
  /// **'No measurements yet'**
  String get noMeasurementsYet;

  /// No description provided for @addFirstMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Add your first measurement to track progress'**
  String get addFirstMeasurement;

  /// No description provided for @measurementAdded.
  ///
  /// In en, this message translates to:
  /// **'Measurement added'**
  String get measurementAdded;

  /// No description provided for @thisFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get thisFieldRequired;

  /// No description provided for @fitnessScore.
  ///
  /// In en, this message translates to:
  /// **'Your Fitness Score'**
  String get fitnessScore;

  /// No description provided for @totalWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalWorkouts;

  /// No description provided for @workouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get workouts;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get currentStreak;

  /// No description provided for @totalVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get totalVolume;

  /// No description provided for @averageTime.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get averageTime;

  /// No description provided for @weeklyActivity.
  ///
  /// In en, this message translates to:
  /// **'Weekly Activity'**
  String get weeklyActivity;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @achievementsUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Achievements Unlocked'**
  String get achievementsUnlocked;

  /// No description provided for @earnedAchievements.
  ///
  /// In en, this message translates to:
  /// **'Earned Achievements'**
  String get earnedAchievements;

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked!'**
  String get unlocked;

  /// No description provided for @notUnlockedYet.
  ///
  /// In en, this message translates to:
  /// **'Not unlocked yet'**
  String get notUnlockedYet;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @unlockedOn.
  ///
  /// In en, this message translates to:
  /// **'Unlocked on:'**
  String get unlockedOn;

  /// No description provided for @scoreLegend.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get scoreLegend;

  /// No description provided for @scoreGreat.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get scoreGreat;

  /// No description provided for @scoreGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get scoreGood;

  /// No description provided for @scoreBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get scoreBeginner;

  /// No description provided for @scoreKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep Going'**
  String get scoreKeepGoing;

  /// No description provided for @dayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get daySun;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get streakDays;

  /// No description provided for @streakDaysPlural.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get streakDaysPlural;

  /// No description provided for @startYourStreak.
  ///
  /// In en, this message translates to:
  /// **'Start Your Streak!'**
  String get startYourStreak;

  /// No description provided for @bestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get bestStreak;

  /// No description provided for @workoutTodayKeepStreak.
  ///
  /// In en, this message translates to:
  /// **'Workout today to keep your streak!'**
  String get workoutTodayKeepStreak;

  /// No description provided for @nextMilestone.
  ///
  /// In en, this message translates to:
  /// **'Next milestone'**
  String get nextMilestone;

  /// No description provided for @completeWorkoutStartStreak.
  ///
  /// In en, this message translates to:
  /// **'Complete a workout to start your streak!'**
  String get completeWorkoutStartStreak;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @xp.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get xp;

  /// No description provided for @totalWorkoutsCount.
  ///
  /// In en, this message translates to:
  /// **'workouts'**
  String get totalWorkoutsCount;

  /// No description provided for @totalPRsCount.
  ///
  /// In en, this message translates to:
  /// **'PRs'**
  String get totalPRsCount;

  /// No description provided for @personalRecord.
  ///
  /// In en, this message translates to:
  /// **'Personal Record'**
  String get personalRecord;

  /// No description provided for @newPersonalRecord.
  ///
  /// In en, this message translates to:
  /// **'NEW PERSONAL RECORD!'**
  String get newPersonalRecord;

  /// No description provided for @pr.
  ///
  /// In en, this message translates to:
  /// **'PR'**
  String get pr;

  /// No description provided for @lastWorkout.
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get lastWorkout;

  /// No description provided for @lastTime.
  ///
  /// In en, this message translates to:
  /// **'Last time'**
  String get lastTime;

  /// No description provided for @suggestion.
  ///
  /// In en, this message translates to:
  /// **'Try'**
  String get suggestion;

  /// No description provided for @allSetsGoodForm.
  ///
  /// In en, this message translates to:
  /// **'Complete all sets with good form'**
  String get allSetsGoodForm;

  /// No description provided for @trackPerformance.
  ///
  /// In en, this message translates to:
  /// **'Track your performance'**
  String get trackPerformance;

  /// No description provided for @tryMoreWeight.
  ///
  /// In en, this message translates to:
  /// **'Try +2.5kg or +1 rep'**
  String get tryMoreWeight;

  /// No description provided for @maintainWeight.
  ///
  /// In en, this message translates to:
  /// **'Great! Try to maintain'**
  String get maintainWeight;

  /// No description provided for @restWell.
  ///
  /// In en, this message translates to:
  /// **'Rest well, you got this!'**
  String get restWell;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get week;

  /// No description provided for @weeksPlural.
  ///
  /// In en, this message translates to:
  /// **'weeks'**
  String get weeksPlural;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get month;

  /// No description provided for @monthsPlural.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get monthsPlural;

  /// No description provided for @ago.
  ///
  /// In en, this message translates to:
  /// **'ago'**
  String get ago;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Workout Reminder'**
  String get dailyReminder;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get reminderTime;

  /// No description provided for @streakWarnings.
  ///
  /// In en, this message translates to:
  /// **'Streak Warnings'**
  String get streakWarnings;

  /// No description provided for @achievementNotifications.
  ///
  /// In en, this message translates to:
  /// **'Achievement Notifications'**
  String get achievementNotifications;

  /// No description provided for @restDayReminders.
  ///
  /// In en, this message translates to:
  /// **'Rest Day Reminders'**
  String get restDayReminders;

  /// No description provided for @prCelebrations.
  ///
  /// In en, this message translates to:
  /// **'Personal Record Celebrations'**
  String get prCelebrations;

  /// No description provided for @testNotification.
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get testNotification;

  /// No description provided for @notificationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Notification permission required'**
  String get notificationPermissionRequired;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @notifDailyWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Time to Workout! 💪'**
  String get notifDailyWorkoutTitle;

  /// No description provided for @notifDailyWorkoutBody.
  ///
  /// In en, this message translates to:
  /// **'Your workout is waiting for you. Let\'s keep that streak going!'**
  String get notifDailyWorkoutBody;

  /// No description provided for @notifStreakWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Break Your Streak! 🔥'**
  String get notifStreakWarningTitle;

  /// No description provided for @notifStreakWarningBody.
  ///
  /// In en, this message translates to:
  /// **'You have a {streak} day streak! Complete a quick workout to keep it alive.'**
  String notifStreakWarningBody(Object streak);

  /// No description provided for @notifAchievementTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievement Unlocked! 🏆'**
  String get notifAchievementTitle;

  /// No description provided for @notifPRTitle.
  ///
  /// In en, this message translates to:
  /// **'New Personal Record! 🎉'**
  String get notifPRTitle;

  /// No description provided for @notifPRBody.
  ///
  /// In en, this message translates to:
  /// **'You just hit a PR on {exercise}! {weight}kg x {reps} reps'**
  String notifPRBody(Object exercise, Object reps, Object weight);

  /// No description provided for @notifRestDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Rest Day '**
  String get notifRestDayTitle;

  /// No description provided for @notifRestDayBody.
  ///
  /// In en, this message translates to:
  /// **'Recovery is crucial! Take it easy today and come back stronger.'**
  String get notifRestDayBody;

  /// No description provided for @notifWeeklySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Summary 📊'**
  String get notifWeeklySummaryTitle;

  /// No description provided for @notifWeeklySummaryBody.
  ///
  /// In en, this message translates to:
  /// **'You completed {count} workouts this week! Check your progress.'**
  String notifWeeklySummaryBody(Object count);

  /// No description provided for @exerciseDetail.
  ///
  /// In en, this message translates to:
  /// **'Exercise Detail'**
  String get exerciseDetail;

  /// No description provided for @howToDoIt.
  ///
  /// In en, this message translates to:
  /// **'How To Do It'**
  String get howToDoIt;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @commonMistakes.
  ///
  /// In en, this message translates to:
  /// **'Common Mistakes'**
  String get commonMistakes;

  /// No description provided for @musclesWorked.
  ///
  /// In en, this message translates to:
  /// **'Muscles Worked'**
  String get musclesWorked;

  /// No description provided for @primaryMuscle.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primaryMuscle;

  /// No description provided for @secondaryMuscle.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get secondaryMuscle;

  /// No description provided for @watchVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch Video'**
  String get watchVideo;

  /// No description provided for @detailedInstructionsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Detailed instructions coming soon!'**
  String get detailedInstructionsComingSoon;

  /// No description provided for @restTime.
  ///
  /// In en, this message translates to:
  /// **'Rest Time'**
  String get restTime;

  /// No description provided for @restTimer.
  ///
  /// In en, this message translates to:
  /// **'Rest Timer'**
  String get restTimer;

  /// No description provided for @selectRestDuration.
  ///
  /// In en, this message translates to:
  /// **'Select Rest Duration'**
  String get selectRestDuration;

  /// No description provided for @customDuration.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customDuration;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @addTime.
  ///
  /// In en, this message translates to:
  /// **'+15s'**
  String get addTime;

  /// No description provided for @removeTime.
  ///
  /// In en, this message translates to:
  /// **'-15s'**
  String get removeTime;

  /// No description provided for @skipRest.
  ///
  /// In en, this message translates to:
  /// **'Skip Rest'**
  String get skipRest;

  /// No description provided for @startRest.
  ///
  /// In en, this message translates to:
  /// **'Start Rest'**
  String get startRest;

  /// No description provided for @restComplete.
  ///
  /// In en, this message translates to:
  /// **'Rest Complete!'**
  String get restComplete;

  /// No description provided for @readyForNextSet.
  ///
  /// In en, this message translates to:
  /// **'Ready for next set'**
  String get readyForNextSet;

  /// No description provided for @waterIntake.
  ///
  /// In en, this message translates to:
  /// **'Water Intake'**
  String get waterIntake;

  /// No description provided for @dailyWaterGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyWaterGoal;

  /// No description provided for @waterGoal.
  ///
  /// In en, this message translates to:
  /// **'Water Goal'**
  String get waterGoal;

  /// No description provided for @glasses.
  ///
  /// In en, this message translates to:
  /// **'glasses'**
  String get glasses;

  /// No description provided for @addGlass.
  ///
  /// In en, this message translates to:
  /// **'Add Glass'**
  String get addGlass;

  /// No description provided for @setGoal.
  ///
  /// In en, this message translates to:
  /// **'Set Goal'**
  String get setGoal;

  /// No description provided for @goalReached.
  ///
  /// In en, this message translates to:
  /// **'Goal Reached!'**
  String get goalReached;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @consumed.
  ///
  /// In en, this message translates to:
  /// **'Consumed'**
  String get consumed;

  /// No description provided for @ml.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get ml;

  /// No description provided for @liters.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get liters;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
