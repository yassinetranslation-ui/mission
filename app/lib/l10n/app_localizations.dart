import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Misson'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Learn through play, powered by AI'**
  String get tagline;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @letsGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get started'**
  String get letsGetStarted;

  /// No description provided for @whoWillBeLearning.
  ///
  /// In en, this message translates to:
  /// **'Who will be learning?'**
  String get whoWillBeLearning;

  /// No description provided for @childAge.
  ///
  /// In en, this message translates to:
  /// **'Child\'s Age'**
  String get childAge;

  /// No description provided for @preferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Preferred Language'**
  String get preferredLanguage;

  /// No description provided for @whatSubjects.
  ///
  /// In en, this message translates to:
  /// **'What subjects are they interested in?'**
  String get whatSubjects;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @addChild.
  ///
  /// In en, this message translates to:
  /// **'Add Child'**
  String get addChild;

  /// No description provided for @uploadLesson.
  ///
  /// In en, this message translates to:
  /// **'Upload Lesson'**
  String get uploadLesson;

  /// No description provided for @generateGame.
  ///
  /// In en, this message translates to:
  /// **'Generate Game'**
  String get generateGame;

  /// No description provided for @viewProgress.
  ///
  /// In en, this message translates to:
  /// **'View Progress'**
  String get viewProgress;

  /// No description provided for @viewReport.
  ///
  /// In en, this message translates to:
  /// **'View Report'**
  String get viewReport;

  /// No description provided for @generatePractice.
  ///
  /// In en, this message translates to:
  /// **'Generate Practice'**
  String get generatePractice;

  /// No description provided for @recentLearning.
  ///
  /// In en, this message translates to:
  /// **'Recent Learning'**
  String get recentLearning;

  /// No description provided for @aiInsight.
  ///
  /// In en, this message translates to:
  /// **'AI Insight'**
  String get aiInsight;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @myMissions.
  ///
  /// In en, this message translates to:
  /// **'My Missions'**
  String get myMissions;

  /// No description provided for @continueMission.
  ///
  /// In en, this message translates to:
  /// **'Continue Mission'**
  String get continueMission;

  /// No description provided for @newGame.
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get newGame;

  /// No description provided for @recommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended for You'**
  String get recommendedForYou;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

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

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @turnLessonIntoGame.
  ///
  /// In en, this message translates to:
  /// **'Turn a lesson into a game'**
  String get turnLessonIntoGame;

  /// No description provided for @uploadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload materials to create a custom mission'**
  String get uploadSubtitle;

  /// No description provided for @uploadScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Upload Screenshot'**
  String get uploadScreenshot;

  /// No description provided for @uploadPdf.
  ///
  /// In en, this message translates to:
  /// **'Upload PDF'**
  String get uploadPdf;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get uploadDocument;

  /// No description provided for @selectChild.
  ///
  /// In en, this message translates to:
  /// **'Select Child'**
  String get selectChild;

  /// No description provided for @gameDuration.
  ///
  /// In en, this message translates to:
  /// **'Game Duration'**
  String get gameDuration;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @adaptive.
  ///
  /// In en, this message translates to:
  /// **'Adaptive'**
  String get adaptive;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @createMyGame.
  ///
  /// In en, this message translates to:
  /// **'Create My Game'**
  String get createMyGame;

  /// No description provided for @readingLesson.
  ///
  /// In en, this message translates to:
  /// **'Reading lesson...'**
  String get readingLesson;

  /// No description provided for @understandingConcepts.
  ///
  /// In en, this message translates to:
  /// **'Understanding concepts...'**
  String get understandingConcepts;

  /// No description provided for @findingObjectives.
  ///
  /// In en, this message translates to:
  /// **'Finding learning objectives...'**
  String get findingObjectives;

  /// No description provided for @designingMission.
  ///
  /// In en, this message translates to:
  /// **'Designing mission...'**
  String get designingMission;

  /// No description provided for @buildingChallenges.
  ///
  /// In en, this message translates to:
  /// **'Building challenges...'**
  String get buildingChallenges;

  /// No description provided for @gameReady.
  ///
  /// In en, this message translates to:
  /// **'Game is ready!'**
  String get gameReady;

  /// No description provided for @startMission.
  ///
  /// In en, this message translates to:
  /// **'Start Mission'**
  String get startMission;

  /// No description provided for @nextLevel.
  ///
  /// In en, this message translates to:
  /// **'Next Level'**
  String get nextLevel;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correct;

  /// No description provided for @incorrect.
  ///
  /// In en, this message translates to:
  /// **'Not quite'**
  String get incorrect;

  /// No description provided for @bossLevel.
  ///
  /// In en, this message translates to:
  /// **'Boss Level!'**
  String get bossLevel;

  /// No description provided for @missionComplete.
  ///
  /// In en, this message translates to:
  /// **'Mission Complete!'**
  String get missionComplete;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @xpEarned.
  ///
  /// In en, this message translates to:
  /// **'XP Earned'**
  String get xpEarned;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @explanation.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get explanation;

  /// No description provided for @mastery.
  ///
  /// In en, this message translates to:
  /// **'Mastery'**
  String get mastery;

  /// No description provided for @needsPractice.
  ///
  /// In en, this message translates to:
  /// **'Needs Practice'**
  String get needsPractice;

  /// No description provided for @developing.
  ///
  /// In en, this message translates to:
  /// **'Developing'**
  String get developing;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @mastered.
  ///
  /// In en, this message translates to:
  /// **'Mastered'**
  String get mastered;

  /// No description provided for @overallMastery.
  ///
  /// In en, this message translates to:
  /// **'Overall Mastery'**
  String get overallMastery;

  /// No description provided for @concepts.
  ///
  /// In en, this message translates to:
  /// **'Concepts'**
  String get concepts;

  /// No description provided for @weakAreas.
  ///
  /// In en, this message translates to:
  /// **'Weak Areas'**
  String get weakAreas;

  /// No description provided for @practiceRecommended.
  ///
  /// In en, this message translates to:
  /// **'Practice Recommended'**
  String get practiceRecommended;

  /// No description provided for @learningReport.
  ///
  /// In en, this message translates to:
  /// **'Learning Report'**
  String get learningReport;

  /// No description provided for @aiLearningInsight.
  ///
  /// In en, this message translates to:
  /// **'AI Learning Insight'**
  String get aiLearningInsight;

  /// No description provided for @recommendedAction.
  ///
  /// In en, this message translates to:
  /// **'Recommended Action'**
  String get recommendedAction;

  /// No description provided for @startPractice.
  ///
  /// In en, this message translates to:
  /// **'Start Practice'**
  String get startPractice;

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

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternet;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @firstMission.
  ///
  /// In en, this message translates to:
  /// **'First Mission'**
  String get firstMission;

  /// No description provided for @scienceExplorer.
  ///
  /// In en, this message translates to:
  /// **'Science Explorer'**
  String get scienceExplorer;

  /// No description provided for @perfectScore.
  ///
  /// In en, this message translates to:
  /// **'Perfect Score!'**
  String get perfectScore;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{days} Day Streak'**
  String streakDays(int days);

  /// No description provided for @conceptMaster.
  ///
  /// In en, this message translates to:
  /// **'Concept Master'**
  String get conceptMaster;

  /// No description provided for @bossSlayer.
  ///
  /// In en, this message translates to:
  /// **'Boss Slayer'**
  String get bossSlayer;

  /// No description provided for @math.
  ///
  /// In en, this message translates to:
  /// **'Math'**
  String get math;

  /// No description provided for @science.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get science;

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @geography.
  ///
  /// In en, this message translates to:
  /// **'Geography'**
  String get geography;

  /// No description provided for @ages6to8.
  ///
  /// In en, this message translates to:
  /// **'Ages 6-8'**
  String get ages6to8;

  /// No description provided for @ages9to11.
  ///
  /// In en, this message translates to:
  /// **'Ages 9-11'**
  String get ages9to11;

  /// No description provided for @ages12to14.
  ///
  /// In en, this message translates to:
  /// **'Ages 12-14'**
  String get ages12to14;

  /// No description provided for @ages15plus.
  ///
  /// In en, this message translates to:
  /// **'Ages 15+'**
  String get ages15plus;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @min5.
  ///
  /// In en, this message translates to:
  /// **'5 Min'**
  String get min5;

  /// No description provided for @min10.
  ///
  /// In en, this message translates to:
  /// **'10 Min'**
  String get min10;

  /// No description provided for @min15.
  ///
  /// In en, this message translates to:
  /// **'15 Min'**
  String get min15;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
