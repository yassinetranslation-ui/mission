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

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your child\'s learning journey'**
  String get signInSubtitle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @registerFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registerFailed;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createYourAccount;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start turning lessons into adventures'**
  String get registerSubtitle;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeUser(String name);

  /// No description provided for @heyChild.
  ///
  /// In en, this message translates to:
  /// **'Hey {name}!'**
  String heyChild(String name);

  /// No description provided for @readyForQuest.
  ///
  /// In en, this message translates to:
  /// **'Ready for today\'s quest?'**
  String get readyForQuest;

  /// No description provided for @activeMission.
  ///
  /// In en, this message translates to:
  /// **'Active Mission'**
  String get activeMission;

  /// No description provided for @startMissionNow.
  ///
  /// In en, this message translates to:
  /// **'Start Mission Now'**
  String get startMissionNow;

  /// No description provided for @moreMissions.
  ///
  /// In en, this message translates to:
  /// **'More Missions'**
  String get moreMissions;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @childrenProfiles.
  ///
  /// In en, this message translates to:
  /// **'Children Profiles'**
  String get childrenProfiles;

  /// No description provided for @noChildrenYet.
  ///
  /// In en, this message translates to:
  /// **'No child profiles added yet'**
  String get noChildrenYet;

  /// No description provided for @addChildDesc.
  ///
  /// In en, this message translates to:
  /// **'Add your child to start creating custom games'**
  String get addChildDesc;

  /// No description provided for @addFirstChild.
  ///
  /// In en, this message translates to:
  /// **'Add First Child'**
  String get addFirstChild;

  /// No description provided for @uploadNewLesson.
  ///
  /// In en, this message translates to:
  /// **'Upload New Lesson'**
  String get uploadNewLesson;

  /// No description provided for @uploadHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload a photo or PDF to generate an interactive mission'**
  String get uploadHomeSubtitle;

  /// No description provided for @childMode.
  ///
  /// In en, this message translates to:
  /// **'Child Mode'**
  String get childMode;

  /// No description provided for @parentZone.
  ///
  /// In en, this message translates to:
  /// **'Parent Zone'**
  String get parentZone;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age {age}'**
  String ageLabel(int age);

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @missions.
  ///
  /// In en, this message translates to:
  /// **'Missions'**
  String get missions;

  /// No description provided for @games.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games;

  /// No description provided for @hero.
  ///
  /// In en, this message translates to:
  /// **'Hero'**
  String get hero;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @switchLanguage.
  ///
  /// In en, this message translates to:
  /// **'Switch Language'**
  String get switchLanguage;

  /// No description provided for @explorer.
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get explorer;

  /// No description provided for @parent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get parent;

  /// No description provided for @settingsAndProfile.
  ///
  /// In en, this message translates to:
  /// **'Settings & Profile'**
  String get settingsAndProfile;

  /// No description provided for @appPreferences.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPreferences;

  /// No description provided for @studyReminders.
  ///
  /// In en, this message translates to:
  /// **'Study Reminders & Streaks'**
  String get studyReminders;

  /// No description provided for @studyRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Notify when a streak is at risk'**
  String get studyRemindersDesc;

  /// No description provided for @offlineCache.
  ///
  /// In en, this message translates to:
  /// **'Offline Games Cache'**
  String get offlineCache;

  /// No description provided for @offlineCacheDesc.
  ///
  /// In en, this message translates to:
  /// **'Clear cached missions'**
  String get offlineCacheDesc;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @cacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Offline game cache cleared successfully.'**
  String get cacheCleared;

  /// No description provided for @modesNavigation.
  ///
  /// In en, this message translates to:
  /// **'Modes & Navigation'**
  String get modesNavigation;

  /// No description provided for @switchToChildHub.
  ///
  /// In en, this message translates to:
  /// **'Switch to Child Game Hub'**
  String get switchToChildHub;

  /// No description provided for @switchToChildHubDesc.
  ///
  /// In en, this message translates to:
  /// **'Open the gamified kid experience'**
  String get switchToChildHubDesc;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirm;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @onboardTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Misson'**
  String get onboardTitle1;

  /// No description provided for @onboardDesc1.
  ///
  /// In en, this message translates to:
  /// **'Transform your child\'s learning with AI-powered interactive missions.'**
  String get onboardDesc1;

  /// No description provided for @onboardTitle2.
  ///
  /// In en, this message translates to:
  /// **'Personalized Learning'**
  String get onboardTitle2;

  /// No description provided for @onboardDesc2.
  ///
  /// In en, this message translates to:
  /// **'Generate custom games and exercises tailored to your child\'s needs.'**
  String get onboardDesc2;

  /// No description provided for @onboardTitle3.
  ///
  /// In en, this message translates to:
  /// **'Track Progress'**
  String get onboardTitle3;

  /// No description provided for @onboardDesc3.
  ///
  /// In en, this message translates to:
  /// **'Monitor achievements and discover areas for improvement.'**
  String get onboardDesc3;

  /// No description provided for @createChildProfile.
  ///
  /// In en, this message translates to:
  /// **'Create Child Profile'**
  String get createChildProfile;

  /// No description provided for @createChildSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your child\'s profile to get started'**
  String get createChildSubtitle;

  /// No description provided for @childNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Child\'s Name'**
  String get childNameLabel;

  /// No description provided for @enterChildName.
  ///
  /// In en, this message translates to:
  /// **'Enter their name'**
  String get enterChildName;

  /// No description provided for @ageHint.
  ///
  /// In en, this message translates to:
  /// **'Enter their age'**
  String get ageHint;

  /// No description provided for @gradeLevel.
  ///
  /// In en, this message translates to:
  /// **'Grade Level'**
  String get gradeLevel;

  /// No description provided for @completeSetup.
  ///
  /// In en, this message translates to:
  /// **'Complete Setup'**
  String get completeSetup;

  /// No description provided for @pleaseEnterAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter an age'**
  String get pleaseEnterAge;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get invalidNumber;

  /// No description provided for @failedCreateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to create profile'**
  String get failedCreateProfile;

  /// No description provided for @myChildren.
  ///
  /// In en, this message translates to:
  /// **'My Children'**
  String get myChildren;

  /// No description provided for @noChildrenTitle.
  ///
  /// In en, this message translates to:
  /// **'No Children Profiles'**
  String get noChildrenTitle;

  /// No description provided for @noChildrenDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a child profile to track their progress and create games.'**
  String get noChildrenDescription;

  /// No description provided for @addNewChild.
  ///
  /// In en, this message translates to:
  /// **'Add New Child'**
  String get addNewChild;

  /// No description provided for @childNameExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. Omar, Sarah'**
  String get childNameExample;

  /// No description provided for @ageExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. 8'**
  String get ageExample;

  /// No description provided for @validAgeRange.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid age (1-18)'**
  String get validAgeRange;

  /// No description provided for @favoriteSubjects.
  ///
  /// In en, this message translates to:
  /// **'Favorite / Target Subjects'**
  String get favoriteSubjects;

  /// No description provided for @addChildProfile.
  ///
  /// In en, this message translates to:
  /// **'Add Child Profile'**
  String get addChildProfile;

  /// No description provided for @failedAddChild.
  ///
  /// In en, this message translates to:
  /// **'Failed to add child'**
  String get failedAddChild;

  /// No description provided for @grade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get grade;

  /// No description provided for @uploadContent.
  ///
  /// In en, this message translates to:
  /// **'Upload Educational Content'**
  String get uploadContent;

  /// No description provided for @uploadContentDesc.
  ///
  /// In en, this message translates to:
  /// **'Upload a textbook page, worksheet, or PDF to generate an interactive mission.'**
  String get uploadContentDesc;

  /// No description provided for @takePickPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take / Pick Photo'**
  String get takePickPhoto;

  /// No description provided for @photoFormats.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG, Screenshot'**
  String get photoFormats;

  /// No description provided for @textbookWorksheet.
  ///
  /// In en, this message translates to:
  /// **'Textbook or Worksheet'**
  String get textbookWorksheet;

  /// No description provided for @lessonTitleTopic.
  ///
  /// In en, this message translates to:
  /// **'Lesson Title / Topic'**
  String get lessonTitleTopic;

  /// No description provided for @lessonTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Water Cycle, Fractions'**
  String get lessonTitleHint;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title for the lesson'**
  String get pleaseEnterTitle;

  /// No description provided for @assignToChild.
  ///
  /// In en, this message translates to:
  /// **'Assign to Child'**
  String get assignToChild;

  /// No description provided for @estimatedDuration.
  ///
  /// In en, this message translates to:
  /// **'Estimated Duration'**
  String get estimatedDuration;

  /// No description provided for @selectFilePrompt.
  ///
  /// In en, this message translates to:
  /// **'Please select a lesson image or PDF to upload.'**
  String get selectFilePrompt;

  /// No description provided for @failedPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get failedPickImage;

  /// No description provided for @failedPickDocument.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick document'**
  String get failedPickDocument;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get uploadFailed;

  /// No description provided for @createEduGame.
  ///
  /// In en, this message translates to:
  /// **'Create My Educational Game'**
  String get createEduGame;

  /// No description provided for @aiMissionGenerator.
  ///
  /// In en, this message translates to:
  /// **'AI Mission Generator'**
  String get aiMissionGenerator;

  /// No description provided for @genStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Reading educational content'**
  String get genStep1Title;

  /// No description provided for @genStep1Sub.
  ///
  /// In en, this message translates to:
  /// **'Extracting text, diagrams, and structures...'**
  String get genStep1Sub;

  /// No description provided for @genStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Deconstructing concepts'**
  String get genStep2Title;

  /// No description provided for @genStep2Sub.
  ///
  /// In en, this message translates to:
  /// **'Building a pedagogical knowledge graph...'**
  String get genStep2Sub;

  /// No description provided for @genStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Identifying learning objectives'**
  String get genStep3Title;

  /// No description provided for @genStep3Sub.
  ///
  /// In en, this message translates to:
  /// **'Defining mastery goals and target facts...'**
  String get genStep3Sub;

  /// No description provided for @genStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Designing the mission narrative'**
  String get genStep4Title;

  /// No description provided for @genStep4Sub.
  ///
  /// In en, this message translates to:
  /// **'Crafting storyline, characters, and quests...'**
  String get genStep4Sub;

  /// No description provided for @genStep5Title.
  ///
  /// In en, this message translates to:
  /// **'Synthesizing interactive challenges'**
  String get genStep5Title;

  /// No description provided for @genStep5Sub.
  ///
  /// In en, this message translates to:
  /// **'Multiple choice, matching, ordering, and boss battle...'**
  String get genStep5Sub;

  /// No description provided for @genStep6Title.
  ///
  /// In en, this message translates to:
  /// **'Mission generation complete!'**
  String get genStep6Title;

  /// No description provided for @genStep6Sub.
  ///
  /// In en, this message translates to:
  /// **'Ready to play natively in the app!'**
  String get genStep6Sub;

  /// No description provided for @generationError.
  ///
  /// In en, this message translates to:
  /// **'Generation Encountered an Error'**
  String get generationError;

  /// No description provided for @transformingLesson.
  ///
  /// In en, this message translates to:
  /// **'Transforming Lesson Into Game'**
  String get transformingLesson;

  /// No description provided for @claudeAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Claude AI is analyzing educational concepts and building your game mission.'**
  String get claudeAnalyzing;

  /// No description provided for @eduLessonGame.
  ///
  /// In en, this message translates to:
  /// **'Educational Lesson Game'**
  String get eduLessonGame;

  /// No description provided for @missionReady.
  ///
  /// In en, this message translates to:
  /// **'Mission Ready!'**
  String get missionReady;

  /// No description provided for @extractedKnowledgeMap.
  ///
  /// In en, this message translates to:
  /// **'Extracted Knowledge Map'**
  String get extractedKnowledgeMap;

  /// No description provided for @keyConceptsLabel.
  ///
  /// In en, this message translates to:
  /// **'Key Concepts'**
  String get keyConceptsLabel;

  /// No description provided for @learningObjectivesLabel.
  ///
  /// In en, this message translates to:
  /// **'Learning Objectives'**
  String get learningObjectivesLabel;

  /// No description provided for @previewPlayMission.
  ///
  /// In en, this message translates to:
  /// **'Preview & Play Mission'**
  String get previewPlayMission;

  /// No description provided for @returnToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Return to Dashboard'**
  String get returnToDashboard;

  /// No description provided for @mission.
  ///
  /// In en, this message translates to:
  /// **'Mission'**
  String get mission;

  /// No description provided for @exitMission.
  ///
  /// In en, this message translates to:
  /// **'Exit Mission?'**
  String get exitMission;

  /// No description provided for @exitMissionBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit? Your current level progress will be lost.'**
  String get exitMissionBody;

  /// No description provided for @keepPlaying.
  ///
  /// In en, this message translates to:
  /// **'Keep Playing'**
  String get keepPlaying;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @missionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mission Completed!'**
  String get missionCompleted;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @backToMissions.
  ///
  /// In en, this message translates to:
  /// **'Back to Missions'**
  String get backToMissions;

  /// No description provided for @failedLoadGame.
  ///
  /// In en, this message translates to:
  /// **'Failed to load game.'**
  String get failedLoadGame;

  /// No description provided for @unknownLevel.
  ///
  /// In en, this message translates to:
  /// **'Unknown level type'**
  String get unknownLevel;

  /// No description provided for @finishMission.
  ///
  /// In en, this message translates to:
  /// **'Finish Mission'**
  String get finishMission;

  /// No description provided for @missionsQuests.
  ///
  /// In en, this message translates to:
  /// **'Missions & Quests'**
  String get missionsQuests;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @customMission.
  ///
  /// In en, this message translates to:
  /// **'Custom Mission'**
  String get customMission;

  /// No description provided for @levels.
  ///
  /// In en, this message translates to:
  /// **'Levels'**
  String get levels;

  /// No description provided for @bossFight.
  ///
  /// In en, this message translates to:
  /// **'Boss Fight'**
  String get bossFight;

  /// No description provided for @badgesUnlocked.
  ///
  /// In en, this message translates to:
  /// **'{count} / {total} Badges Unlocked'**
  String badgesUnlocked(int count, int total);

  /// No description provided for @keepPlayingCollect.
  ///
  /// In en, this message translates to:
  /// **'Keep playing missions to collect them all!'**
  String get keepPlayingCollect;

  /// No description provided for @explorerBadges.
  ///
  /// In en, this message translates to:
  /// **'Explorer Badges'**
  String get explorerBadges;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @awesome.
  ///
  /// In en, this message translates to:
  /// **'Awesome!'**
  String get awesome;

  /// No description provided for @missionPreview.
  ///
  /// In en, this message translates to:
  /// **'Mission Preview'**
  String get missionPreview;

  /// No description provided for @generatedMissionPreview.
  ///
  /// In en, this message translates to:
  /// **'Generated Mission Preview'**
  String get generatedMissionPreview;

  /// No description provided for @playMissionNow.
  ///
  /// In en, this message translates to:
  /// **'Play Mission Now'**
  String get playMissionNow;

  /// No description provided for @couldNotLoadPreview.
  ///
  /// In en, this message translates to:
  /// **'Could not load game preview.'**
  String get couldNotLoadPreview;

  /// No description provided for @missionRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Mission Roadmap'**
  String get missionRoadmap;

  /// No description provided for @challenge.
  ///
  /// In en, this message translates to:
  /// **'Challenge'**
  String get challenge;

  /// No description provided for @hint.
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get hint;

  /// No description provided for @hideHint.
  ///
  /// In en, this message translates to:
  /// **'Hide Hint'**
  String get hideHint;

  /// No description provided for @correctFeedback.
  ///
  /// In en, this message translates to:
  /// **'Awesome! That\'s correct! 🎉'**
  String get correctFeedback;

  /// No description provided for @wrongFeedback.
  ///
  /// In en, this message translates to:
  /// **'Good try! Here\'s why:'**
  String get wrongFeedback;

  /// No description provided for @matchingQuest.
  ///
  /// In en, this message translates to:
  /// **'Matching Quest'**
  String get matchingQuest;

  /// No description provided for @matchedCount.
  ///
  /// In en, this message translates to:
  /// **'{count}/{total} Matched'**
  String matchedCount(int count, int total);

  /// No description provided for @notAMatch.
  ///
  /// In en, this message translates to:
  /// **'Not quite a match, try again!'**
  String get notAMatch;

  /// No description provided for @allMatched.
  ///
  /// In en, this message translates to:
  /// **'All Pairs Matched Perfectly! 🌟'**
  String get allMatched;

  /// No description provided for @bossBattle.
  ///
  /// In en, this message translates to:
  /// **'BOSS BATTLE'**
  String get bossBattle;

  /// No description provided for @bossDefeated.
  ///
  /// In en, this message translates to:
  /// **'BOSS DEFEATED! 🏆'**
  String get bossDefeated;

  /// No description provided for @bossDefeatedBody.
  ///
  /// In en, this message translates to:
  /// **'You cleared all challenges and mastered the mission!'**
  String get bossDefeatedBody;

  /// No description provided for @orderingQuest.
  ///
  /// In en, this message translates to:
  /// **'Sequence Mission'**
  String get orderingQuest;

  /// No description provided for @checkOrder.
  ///
  /// In en, this message translates to:
  /// **'Verify Order'**
  String get checkOrder;

  /// No description provided for @correctOrder.
  ///
  /// In en, this message translates to:
  /// **'Correct Sequence! 🎯'**
  String get correctOrder;

  /// No description provided for @wrongOrder.
  ///
  /// In en, this message translates to:
  /// **'Not quite the right order, try again!'**
  String get wrongOrder;

  /// No description provided for @dragInstruction.
  ///
  /// In en, this message translates to:
  /// **'Drag items up or down to place them in the correct order.'**
  String get dragInstruction;

  /// No description provided for @sequenceExplanation.
  ///
  /// In en, this message translates to:
  /// **'Sequence Explanation:'**
  String get sequenceExplanation;

  /// No description provided for @heroProfile.
  ///
  /// In en, this message translates to:
  /// **'Hero Profile'**
  String get heroProfile;

  /// No description provided for @parentDashboard.
  ///
  /// In en, this message translates to:
  /// **'Parent Dashboard'**
  String get parentDashboard;

  /// No description provided for @activeStreak.
  ///
  /// In en, this message translates to:
  /// **'Active Streak'**
  String get activeStreak;

  /// No description provided for @totalXpLabel.
  ///
  /// In en, this message translates to:
  /// **'Total XP'**
  String get totalXpLabel;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @collected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get collected;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @questsWord.
  ///
  /// In en, this message translates to:
  /// **'Quests'**
  String get questsWord;

  /// No description provided for @playTodaysQuests.
  ///
  /// In en, this message translates to:
  /// **'Play Today\'s Quests'**
  String get playTodaysQuests;

  /// No description provided for @switchToParentMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to Parent Mode'**
  String get switchToParentMode;

  /// No description provided for @editChildProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Child Profile'**
  String get editChildProfile;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @failedUpdateChild.
  ///
  /// In en, this message translates to:
  /// **'Failed to update child'**
  String get failedUpdateChild;

  /// No description provided for @deleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Delete Profile'**
  String get deleteProfile;

  /// No description provided for @deleteProfileConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}\'s profile? This will remove all their progress.'**
  String deleteProfileConfirm(String name);

  /// No description provided for @failedDeleteChild.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete child'**
  String get failedDeleteChild;

  /// No description provided for @childDetails.
  ///
  /// In en, this message translates to:
  /// **'Child Details'**
  String get childDetails;

  /// No description provided for @childNotFound.
  ///
  /// In en, this message translates to:
  /// **'Child profile not found'**
  String get childNotFound;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @playAs.
  ///
  /// In en, this message translates to:
  /// **'Play as {name}'**
  String playAs(String name);

  /// No description provided for @viewProgressReports.
  ///
  /// In en, this message translates to:
  /// **'View Progress & Reports'**
  String get viewProgressReports;

  /// No description provided for @uploadLessonFor.
  ///
  /// In en, this message translates to:
  /// **'Upload Lesson for {name}'**
  String uploadLessonFor(String name);

  /// No description provided for @childReport.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s Report'**
  String childReport(String name);

  /// No description provided for @noLearningData.
  ///
  /// In en, this message translates to:
  /// **'No learning data available yet.'**
  String get noLearningData;

  /// No description provided for @onTrack.
  ///
  /// In en, this message translates to:
  /// **'On Track 🚀'**
  String get onTrack;

  /// No description provided for @targetedPracticeNeeded.
  ///
  /// In en, this message translates to:
  /// **'Targeted Practice Needed'**
  String get targetedPracticeNeeded;

  /// No description provided for @areasForFocus.
  ///
  /// In en, this message translates to:
  /// **'Areas for Focus'**
  String get areasForFocus;

  /// No description provided for @microMissionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Targeted micro-missions will reinforce these concepts quickly.'**
  String get microMissionsDesc;

  /// No description provided for @generateAdaptivePractice.
  ///
  /// In en, this message translates to:
  /// **'Generate Adaptive Practice Mission'**
  String get generateAdaptivePractice;

  /// No description provided for @conceptBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Concept Breakdown'**
  String get conceptBreakdown;

  /// No description provided for @attempts.
  ///
  /// In en, this message translates to:
  /// **'Attempts'**
  String get attempts;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'accuracy'**
  String get accuracy;

  /// No description provided for @recommendedSteps.
  ///
  /// In en, this message translates to:
  /// **'Recommended Steps for Parents'**
  String get recommendedSteps;

  /// No description provided for @failedGeneratePractice.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate practice'**
  String get failedGeneratePractice;

  /// No description provided for @masteredTier.
  ///
  /// In en, this message translates to:
  /// **'Mastered 🌟'**
  String get masteredTier;

  /// No description provided for @goodTier.
  ///
  /// In en, this message translates to:
  /// **'Good 👍'**
  String get goodTier;

  /// No description provided for @developingTier.
  ///
  /// In en, this message translates to:
  /// **'Developing 📈'**
  String get developingTier;

  /// No description provided for @needsPracticeTier.
  ///
  /// In en, this message translates to:
  /// **'Needs Practice 🎯'**
  String get needsPracticeTier;

  /// No description provided for @lessonReport.
  ///
  /// In en, this message translates to:
  /// **'Lesson Report'**
  String get lessonReport;

  /// No description provided for @noReportData.
  ///
  /// In en, this message translates to:
  /// **'No report data available.'**
  String get noReportData;

  /// No description provided for @strengths.
  ///
  /// In en, this message translates to:
  /// **'Strengths'**
  String get strengths;

  /// No description provided for @weaknesses.
  ///
  /// In en, this message translates to:
  /// **'Areas to Improve'**
  String get weaknesses;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @noReportForLesson.
  ///
  /// In en, this message translates to:
  /// **'No report available for this lesson.'**
  String get noReportForLesson;
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
