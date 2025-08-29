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
    Locale('en'),
  ];

  /// Welcome message for admin users
  ///
  /// In en, this message translates to:
  /// **'Welcome, Admin'**
  String get welcomeAdmin;

  /// Welcome message for supervisor users
  ///
  /// In en, this message translates to:
  /// **'Welcome, Supervisor'**
  String get welcomeSupervisor;

  /// Welcome message for auditor users
  ///
  /// In en, this message translates to:
  /// **'Welcome, Auditor'**
  String get welcomeAuditor;

  /// Edit profile button text
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Log out button text
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// Privacy and security section title
  ///
  /// In en, this message translates to:
  /// **'Privacy and Security'**
  String get privacyAndSecurity;

  /// Privacy settings option
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// Security settings option
  ///
  /// In en, this message translates to:
  /// **'Security Settings'**
  String get securitySettings;

  /// Two-factor authentication option
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorAuthentication;

  /// Language option
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Message when user has no email set
  ///
  /// In en, this message translates to:
  /// **'No email set'**
  String get noEmailSet;

  /// Auditor role display name
  ///
  /// In en, this message translates to:
  /// **'Auditor'**
  String get auditor;

  /// Supervisor role display name
  ///
  /// In en, this message translates to:
  /// **'Supervisor'**
  String get supervisor;

  /// Admin role display name
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// Default user role display name
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// Notification preferences section title
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notificationPreferences;

  /// Harassment alerts setting title
  ///
  /// In en, this message translates to:
  /// **'Harassment Alerts'**
  String get harassmentAlerts;

  /// Harassment alerts setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Receive alerts for potential harassment incidents'**
  String get harassmentAlertsSubtitle;

  /// Inactivity notifications setting title
  ///
  /// In en, this message translates to:
  /// **'Inactivity Notifications'**
  String get inactivityNotifications;

  /// Inactivity notifications setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Receive notifications when no activity is detected'**
  String get inactivityNotificationsSubtitle;

  /// Mobile usage alerts setting title
  ///
  /// In en, this message translates to:
  /// **'Mobile Usage Alerts'**
  String get mobileUsageAlerts;

  /// Mobile usage alerts setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Receive alerts when unusual mobile usage is detected'**
  String get mobileUsageAlertsSubtitle;

  /// Report settings section title
  ///
  /// In en, this message translates to:
  /// **'Report Settings'**
  String get reportSettings;

  /// Auto-download weekly reports setting title
  ///
  /// In en, this message translates to:
  /// **'Auto-download weekly reports'**
  String get autoDownloadWeeklyReports;

  /// Auto-download weekly reports setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Automatically download weekly reports in your preferred format.'**
  String get autoDownloadWeeklyReportsSubtitle;

  /// Report format setting title
  ///
  /// In en, this message translates to:
  /// **'Report Format'**
  String get reportFormat;

  /// PDF format option
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// Excel format option
  ///
  /// In en, this message translates to:
  /// **'Excel'**
  String get excel;

  /// Manage branches option
  ///
  /// In en, this message translates to:
  /// **'Manage Branches'**
  String get manageBranches;

  /// Manage users screen title
  ///
  /// In en, this message translates to:
  /// **'Manage Users'**
  String get manageUsers;

  /// AI alert sensitivity section title
  ///
  /// In en, this message translates to:
  /// **'AI Alert Sensitivity'**
  String get aiAlertSensitivity;

  /// Low sensitivity level
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// Medium sensitivity level
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// High sensitivity level
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Signup button text
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// Select role placeholder
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get selectRole;

  /// Select role placeholder
  ///
  /// In en, this message translates to:
  /// **'Select your role'**
  String get selectYourRole;

  /// Please select role validation
  ///
  /// In en, this message translates to:
  /// **'Please select a role'**
  String get pleaseSelectRole;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Email field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// Email validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Password field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// Password validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Divider text between login options
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// Google sign in button text
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// Loading text for sign in
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signingIn;

  /// Sign up prompt text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Full name field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// Name validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Confirm password field placeholder
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// Confirm password validation error
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// Password mismatch error
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Terms acceptance text
  ///
  /// In en, this message translates to:
  /// **'I accept the terms and Privacy policy'**
  String get acceptTerms;

  /// Read terms link text
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// Terms acceptance error
  ///
  /// In en, this message translates to:
  /// **'You must accept the terms and privacy policy'**
  String get mustAcceptTerms;

  /// Login prompt text
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Welcome message with role placeholder
  ///
  /// In en, this message translates to:
  /// **'Welcome, {role}'**
  String welcomeMessage(String role);

  /// Today's activity section title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Activity'**
  String get todaysActivity;

  /// Average behaviour score label
  ///
  /// In en, this message translates to:
  /// **'Average Behaviour score'**
  String get averageBehaviourScore;

  /// Top branch label
  ///
  /// In en, this message translates to:
  /// **'Top Branch'**
  String get topBranch;

  /// Productivity label
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get productivity;

  /// Staff performance section title
  ///
  /// In en, this message translates to:
  /// **'Staff Performance'**
  String get staffPerformance;

  /// Top employees section title
  ///
  /// In en, this message translates to:
  /// **'Top Employees'**
  String get topEmployees;

  /// Top employees this week section title
  ///
  /// In en, this message translates to:
  /// **'Top Employees This Week'**
  String get topEmployeesThisWeek;

  /// Branch performance section title
  ///
  /// In en, this message translates to:
  /// **'Branch Performance'**
  String get branchPerformance;

  /// Branches performance section title
  ///
  /// In en, this message translates to:
  /// **'Branches Performance'**
  String get branchesPerformance;

  /// Recent behaviours section title
  ///
  /// In en, this message translates to:
  /// **'Recent Behaviours'**
  String get recentBehaviours;

  /// View all button text
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Export report button text
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get exportReport;

  /// No description provided for @aiTag.
  ///
  /// In en, this message translates to:
  /// **'AI Tag'**
  String get aiTag;

  /// No description provided for @positive.
  ///
  /// In en, this message translates to:
  /// **'Positive'**
  String get positive;

  /// No description provided for @negative.
  ///
  /// In en, this message translates to:
  /// **'Negative'**
  String get negative;

  /// No description provided for @neutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get neutral;

  /// All branches filter option
  ///
  /// In en, this message translates to:
  /// **'All Branches'**
  String get allBranches;

  /// This week filter option
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// Employee filter option
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// Behavior type filter option
  ///
  /// In en, this message translates to:
  /// **'Behavior Type'**
  String get behaviorType;

  /// Filter by branch modal title
  ///
  /// In en, this message translates to:
  /// **'Filter by Branch'**
  String get filterByBranch;

  /// All branches filter description
  ///
  /// In en, this message translates to:
  /// **'Show data from all branches'**
  String get showDataFromAllBranches;

  /// No address placeholder
  ///
  /// In en, this message translates to:
  /// **'No address'**
  String get noAddress;

  /// Branch switch confirmation message
  ///
  /// In en, this message translates to:
  /// **'Switched to {branchName}'**
  String switchedToBranch(String branchName);

  /// Filter applied confirmation message
  ///
  /// In en, this message translates to:
  /// **'Filter applied: {branchName}'**
  String filterApplied(String branchName);

  /// Secret key modal title
  ///
  /// In en, this message translates to:
  /// **'Do you have a secret key? If Yes'**
  String get doYouHaveSecretKey;

  /// Secret key input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your secret key'**
  String get enterYourSecretKey;

  /// Yes button text
  ///
  /// In en, this message translates to:
  /// **'YES'**
  String get yes;

  /// No button text
  ///
  /// In en, this message translates to:
  /// **'NO'**
  String get no;

  /// Dashboard tab label
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Reports tab label
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// Staff screen title
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staff;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Analytics screen title
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// Notifications screen title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Profile screen title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Change password screen title
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Current password field label
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// New password field label
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// Confirm new password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Loading text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error text
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success text
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Search placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No data message
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// Refresh button text
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get networkError;

  /// Incorrect credentials error message
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password. Please try again.'**
  String get incorrectCredentials;

  /// Google sign-in failed error message
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. Please try again.'**
  String get googleSignInFailed;

  /// Different role error message
  ///
  /// In en, this message translates to:
  /// **'An account with this email exists but with a different role. Please try logging in with your correct role, or sign up with a different email.'**
  String get differentRoleError;

  /// No account found error message
  ///
  /// In en, this message translates to:
  /// **'No account found with this Google account and role. Please sign up first.'**
  String get noAccountFound;

  /// Account already linked error message
  ///
  /// In en, this message translates to:
  /// **'This Google account is already linked to another user. Please try logging in with your existing account.'**
  String get accountAlreadyLinked;

  /// Network error during Google sign-in
  ///
  /// In en, this message translates to:
  /// **'Network error during Google sign-in. Please check your internet connection.'**
  String get networkErrorGoogle;

  /// Google sign-in cancelled message
  ///
  /// In en, this message translates to:
  /// **'Google sign-in was cancelled.'**
  String get googleSignInCancelled;

  /// Authentication error message
  ///
  /// In en, this message translates to:
  /// **'Authentication error during Google sign-in. Please try again.'**
  String get authenticationError;

  /// Verification code failed message
  ///
  /// In en, this message translates to:
  /// **'Failed to send verification code. Please try again.'**
  String get verificationCodeFailed;

  /// Email already exists error message
  ///
  /// In en, this message translates to:
  /// **'This email is already registered. Please try logging in instead.'**
  String get emailAlreadyExists;

  /// Google sign-up failed error message
  ///
  /// In en, this message translates to:
  /// **'Google sign-up failed. Please try again.'**
  String get googleSignUpFailed;

  /// Account already exists error message
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists. Please try logging in, or sign up with a different email.'**
  String get accountAlreadyExists;

  /// Google sign-up cancelled message
  ///
  /// In en, this message translates to:
  /// **'Google sign-up was cancelled.'**
  String get googleSignUpCancelled;

  /// Contact support message in header
  ///
  /// In en, this message translates to:
  /// **'Please contact Support for Company Details'**
  String get contactSupport;

  /// Users tab label for admin
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// Health suggestion for taking stretch breaks
  ///
  /// In en, this message translates to:
  /// **'Take a 10-min stretch break every 2 hours'**
  String get stretchBreakSuggestion;

  /// Underperforming zones section title
  ///
  /// In en, this message translates to:
  /// **'Underperforming zones'**
  String get underperformingZones;

  /// AI Insights section title
  ///
  /// In en, this message translates to:
  /// **'AI Insights'**
  String get aiInsights;

  /// Attendance pattern insight title
  ///
  /// In en, this message translates to:
  /// **'Attendance Pattern'**
  String get attendancePattern;

  /// High absenteeism detected message
  ///
  /// In en, this message translates to:
  /// **'High absenteeism detected on Mondays. Consider reviewing work schedules.'**
  String get highAbsenteeismDetected;

  /// Performance insight title
  ///
  /// In en, this message translates to:
  /// **'Performance Insight'**
  String get performanceInsight;

  /// Team engagement peaks message
  ///
  /// In en, this message translates to:
  /// **'Team engagement peaks during afternoon shifts. Optimize task allocation.'**
  String get teamEngagementPeaks;

  /// Positive behavior description
  ///
  /// In en, this message translates to:
  /// **'Excellent customer service provided'**
  String get excellentCustomerService;

  /// Negative behavior description
  ///
  /// In en, this message translates to:
  /// **'Harassment behavior detected at Kitchen'**
  String get harassmentBehaviorDetected;

  /// Neutral behavior description
  ///
  /// In en, this message translates to:
  /// **'Extended break time observed'**
  String get extendedBreakTimeObserved;

  /// No description provided for @frontDesk.
  ///
  /// In en, this message translates to:
  /// **'Front Desk'**
  String get frontDesk;

  /// Service area department
  ///
  /// In en, this message translates to:
  /// **'Service area'**
  String get serviceArea;

  /// No description provided for @restArea.
  ///
  /// In en, this message translates to:
  /// **'Rest area'**
  String get restArea;

  /// Switch branch popup title
  ///
  /// In en, this message translates to:
  /// **'Switch Branch'**
  String get switchBranch;

  /// Search branch label
  ///
  /// In en, this message translates to:
  /// **'Search Branch'**
  String get searchBranch;

  /// Search branches placeholder
  ///
  /// In en, this message translates to:
  /// **'Search branches...'**
  String get searchBranches;

  /// No branches found message
  ///
  /// In en, this message translates to:
  /// **'No branches found'**
  String get noBranchesFound;

  /// No branches available message
  ///
  /// In en, this message translates to:
  /// **'No branches available'**
  String get noBranchesAvailable;

  /// Try different search term message
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearchTerm;

  /// Unknown branch fallback text
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownBranch;

  /// Unknown address fallback text
  ///
  /// In en, this message translates to:
  /// **'Unknown Address'**
  String get unknownAddress;

  /// Report screen title
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// View analytics button text
  ///
  /// In en, this message translates to:
  /// **'View Analytics'**
  String get viewAnalytics;

  /// Daily period tab
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// Weekly period tab
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// Monthly period tab
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// Incident label
  ///
  /// In en, this message translates to:
  /// **'Incident'**
  String get incident;

  /// Behaviors report type
  ///
  /// In en, this message translates to:
  /// **'Behaviors'**
  String get behaviors;

  /// Away time label
  ///
  /// In en, this message translates to:
  /// **'Away time'**
  String get awayTime;

  /// Last 7 days subtitle
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get lastSevenDays;

  /// Incident report type
  ///
  /// In en, this message translates to:
  /// **'Incident Report'**
  String get incidentReport;

  /// Behavior report type
  ///
  /// In en, this message translates to:
  /// **'Behavior Report'**
  String get behaviorReport;

  /// Away time report title
  ///
  /// In en, this message translates to:
  /// **'Away Time Report'**
  String get awayTimeReport;

  /// Search staff placeholder
  ///
  /// In en, this message translates to:
  /// **'Search Staff..'**
  String get searchStaff;

  /// All departments filter option
  ///
  /// In en, this message translates to:
  /// **'All Departments'**
  String get allDepartments;

  /// Score filter all option
  ///
  /// In en, this message translates to:
  /// **'Score: All'**
  String get scoreAll;

  /// Service counter zone name
  ///
  /// In en, this message translates to:
  /// **'Service Counter'**
  String get serviceCounter;

  /// Unknown user fallback
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// Unknown role fallback
  ///
  /// In en, this message translates to:
  /// **'Unknown Role'**
  String get unknownRole;

  /// Manage branch screen title
  ///
  /// In en, this message translates to:
  /// **'Manage Branch'**
  String get manageBranch;

  /// Add new branch button and screen title
  ///
  /// In en, this message translates to:
  /// **'Add New Branch'**
  String get addNewBranch;

  /// Add first branch instruction
  ///
  /// In en, this message translates to:
  /// **'Add your first branch to get started'**
  String get addFirstBranch;

  /// Branch name field label
  ///
  /// In en, this message translates to:
  /// **'Branch Name'**
  String get branchName;

  /// Branch address field label
  ///
  /// In en, this message translates to:
  /// **'Branch Address'**
  String get branchAddress;

  /// Enter branch name placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter branch name'**
  String get enterBranchName;

  /// Enter branch address placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter branch address'**
  String get enterBranchAddress;

  /// Branch name required validation
  ///
  /// In en, this message translates to:
  /// **'Branch name is required'**
  String get branchNameRequired;

  /// Branch address required validation
  ///
  /// In en, this message translates to:
  /// **'Branch address is required'**
  String get branchAddressRequired;

  /// Add branch button text
  ///
  /// In en, this message translates to:
  /// **'Add Branch'**
  String get addBranch;

  /// Branch added success message
  ///
  /// In en, this message translates to:
  /// **'Branch added successfully!'**
  String get branchAddedSuccessfully;

  /// Add new user button and screen title
  ///
  /// In en, this message translates to:
  /// **'Add New User'**
  String get addNewUser;

  /// No users found message
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// Enter full name placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get enterFullName;

  /// Full name required validation
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Enter phone number placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// Phone number required validation
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberRequired;

  /// Role field label
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// Add user button text
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get addUser;

  /// User added success message
  ///
  /// In en, this message translates to:
  /// **'User added successfully!'**
  String get userAddedSuccessfully;

  /// Last online label
  ///
  /// In en, this message translates to:
  /// **'Last online'**
  String get lastOnline;

  /// Never logged in status
  ///
  /// In en, this message translates to:
  /// **'Never logged in'**
  String get neverLoggedIn;

  /// Just now status
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// Unknown status
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Secret key validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your secret key'**
  String get pleaseEnterSecretKey;

  /// Employee profile screen title
  ///
  /// In en, this message translates to:
  /// **'Employee Profile'**
  String get employeeProfile;

  /// Behavior score section title
  ///
  /// In en, this message translates to:
  /// **'Behavior Score'**
  String get behaviorScore;

  /// Attendance label
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// Productivity comparison message
  ///
  /// In en, this message translates to:
  /// **'{name} is {percentage}% more productive than average'**
  String moreProductiveThanAverage(String name, String percentage);

  /// Performance comparison section title
  ///
  /// In en, this message translates to:
  /// **'Performance Comparison'**
  String get performanceComparison;

  /// Average daily score label
  ///
  /// In en, this message translates to:
  /// **'Avg Daily Score'**
  String get avgDailyScore;

  /// Work time label
  ///
  /// In en, this message translates to:
  /// **'Work Time'**
  String get workTime;

  /// Performance label
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// Compare staff section title
  ///
  /// In en, this message translates to:
  /// **'Compare Staff'**
  String get compareStaff;

  /// Away from zone message
  ///
  /// In en, this message translates to:
  /// **'{name} is away from assigned zone for {duration}'**
  String awayFromZone(String name, String duration);

  /// View camera live text
  ///
  /// In en, this message translates to:
  /// **'View camera live'**
  String get viewCameraLive;

  /// Frame snapshots section title
  ///
  /// In en, this message translates to:
  /// **'Frame Snapshots'**
  String get frameSnapshots;

  /// Captured from footage description
  ///
  /// In en, this message translates to:
  /// **'Captured from security footage'**
  String get capturedFromFootage;

  /// Video review section title
  ///
  /// In en, this message translates to:
  /// **'Video Review'**
  String get videoReview;

  /// Download report section title
  ///
  /// In en, this message translates to:
  /// **'Download Report'**
  String get downloadReport;

  /// Work hours label
  ///
  /// In en, this message translates to:
  /// **'Work Hours'**
  String get workHours;

  /// Break time label
  ///
  /// In en, this message translates to:
  /// **'Break Time'**
  String get breakTime;

  /// Export detailed report description
  ///
  /// In en, this message translates to:
  /// **'Export the detailed report in PDF format'**
  String get exportDetailedReportPdf;

  /// Include AI insights toggle label
  ///
  /// In en, this message translates to:
  /// **'Include AI Insights'**
  String get includeAiInsights;

  /// Include snapshots toggle label
  ///
  /// In en, this message translates to:
  /// **'Include Snapshots'**
  String get includeSnapshots;

  /// Download employee summary button text
  ///
  /// In en, this message translates to:
  /// **'Download Employee Summary'**
  String get downloadEmployeeSummary;

  /// Yesterday label
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Zone absence title
  ///
  /// In en, this message translates to:
  /// **'Zone Absence'**
  String get zoneAbsence;

  /// Zone label
  ///
  /// In en, this message translates to:
  /// **'Zone'**
  String get zone;

  /// Minutes label
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// For preposition used with duration
  ///
  /// In en, this message translates to:
  /// **'for'**
  String get forDuration;

  /// Export all reports button text
  ///
  /// In en, this message translates to:
  /// **'Export All Reports'**
  String get exportAllReports;

  /// Critical severity level
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get critical;

  /// Warning severity level
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// Fight detection incident type
  ///
  /// In en, this message translates to:
  /// **'Fight Detected'**
  String get fightDetected;

  /// Harassment alert incident type
  ///
  /// In en, this message translates to:
  /// **'Harassment Alert'**
  String get harassmentAlert;

  /// Phone usage incident type
  ///
  /// In en, this message translates to:
  /// **'Phone Usage'**
  String get phoneUsage;

  /// Long break alert incident type
  ///
  /// In en, this message translates to:
  /// **'Long Break Alert'**
  String get longBreakAlert;

  /// Altercation incident description
  ///
  /// In en, this message translates to:
  /// **'Altercation at Checkout Zone'**
  String get altercationAtCheckoutZone;

  /// AI confidence description with percentage
  ///
  /// In en, this message translates to:
  /// **'AI confidence, Kitchen Zone {percentage}%'**
  String aiConfidenceKitchenZone(String percentage);

  /// Detection during work hours description
  ///
  /// In en, this message translates to:
  /// **'Detected during work hours'**
  String get detectedDuringWorkHours;

  /// Checkout counter distance description
  ///
  /// In en, this message translates to:
  /// **'Checkout Counter: {minutes} mins away'**
  String checkoutCounterMinsAway(String minutes);

  /// Minutes ago time indicator
  ///
  /// In en, this message translates to:
  /// **'mins ago {minutes}'**
  String minsAgo(String minutes);

  /// Kitchen zone location
  ///
  /// In en, this message translates to:
  /// **'Kitchen Zone'**
  String get kitchenZone;

  /// Checkout zone location
  ///
  /// In en, this message translates to:
  /// **'Checkout Zone'**
  String get checkoutZone;

  /// Checkout counter location
  ///
  /// In en, this message translates to:
  /// **'Checkout Counter'**
  String get checkoutCounter;

  /// Customer assistance satisfaction description
  ///
  /// In en, this message translates to:
  /// **'Customer assisted - 90% satisfaction'**
  String get customerAssisted90Satisfaction;

  /// One hour ago time indicator
  ///
  /// In en, this message translates to:
  /// **'1 hour ago'**
  String get hourAgo;

  /// Filter events popup title
  ///
  /// In en, this message translates to:
  /// **'Filter Events'**
  String get filterEvents;

  /// Date range filter section title
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// Today date option
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Last 7 days option
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get last7Days;

  /// Custom date range option
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// Zone selection placeholder
  ///
  /// In en, this message translates to:
  /// **'Select zones'**
  String get selectZones;

  /// Severity filter section title
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get severity;

  /// Normal severity level
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// Moderate severity level
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// Suspicious severity level
  ///
  /// In en, this message translates to:
  /// **'Suspicious'**
  String get suspicious;

  /// Reset button text
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Apply button text
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Zone A option
  ///
  /// In en, this message translates to:
  /// **'Zone A'**
  String get zoneA;

  /// Zone B option
  ///
  /// In en, this message translates to:
  /// **'Zone B'**
  String get zoneB;

  /// Zone C option
  ///
  /// In en, this message translates to:
  /// **'Zone C'**
  String get zoneC;

  /// Zone D option
  ///
  /// In en, this message translates to:
  /// **'Zone D'**
  String get zoneD;

  /// Report type field label
  ///
  /// In en, this message translates to:
  /// **'Report Type'**
  String get reportType;

  /// Report type selection placeholder
  ///
  /// In en, this message translates to:
  /// **'Select report type'**
  String get selectReportType;

  /// Performance report type
  ///
  /// In en, this message translates to:
  /// **'Performance Report'**
  String get performanceReport;

  /// Attendance report type
  ///
  /// In en, this message translates to:
  /// **'Attendance Report'**
  String get attendanceReport;

  /// Date range selection placeholder
  ///
  /// In en, this message translates to:
  /// **'Select date range'**
  String get selectDateRange;

  /// Last 30 days option
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30Days;

  /// Last 3 months option
  ///
  /// In en, this message translates to:
  /// **'Last 3 months'**
  String get last3Months;

  /// Last 6 months option
  ///
  /// In en, this message translates to:
  /// **'Last 6 months'**
  String get last6Months;

  /// Custom range option
  ///
  /// In en, this message translates to:
  /// **'Custom range'**
  String get customRange;

  /// Employee field label
  ///
  /// In en, this message translates to:
  /// **'Employee (optional)'**
  String get employeeOptional;

  /// All employees placeholder
  ///
  /// In en, this message translates to:
  /// **'All employees'**
  String get allEmployees;

  /// Export format field label
  ///
  /// In en, this message translates to:
  /// **'Export Format'**
  String get exportFormat;

  /// Include charts/graphs toggle label
  ///
  /// In en, this message translates to:
  /// **'Include Charts/Graphs'**
  String get includeChartsGraphs;

  /// Report type validation message
  ///
  /// In en, this message translates to:
  /// **'Please select a report type'**
  String get pleaseSelectReportType;

  /// Date range validation message
  ///
  /// In en, this message translates to:
  /// **'Please select a date range'**
  String get pleaseSelectDateRange;

  /// Zone breakdown section title
  ///
  /// In en, this message translates to:
  /// **'Zone Breakdown'**
  String get zoneBreakdown;

  /// Total events chart title
  ///
  /// In en, this message translates to:
  /// **'Total Events'**
  String get totalEvents;

  /// Behaviour event type
  ///
  /// In en, this message translates to:
  /// **'Behaviour'**
  String get behaviour;

  /// Awaytime event type
  ///
  /// In en, this message translates to:
  /// **'Awaytime'**
  String get awaytime;

  /// Customer area zone name
  ///
  /// In en, this message translates to:
  /// **'Customer Area'**
  String get customerArea;

  /// Time spent label
  ///
  /// In en, this message translates to:
  /// **'Time Spent'**
  String get timeSpent;

  /// Incidents label
  ///
  /// In en, this message translates to:
  /// **'Incidents'**
  String get incidents;

  /// Behavior label
  ///
  /// In en, this message translates to:
  /// **'Behaviour'**
  String get behavior;

  /// One time occurrence
  ///
  /// In en, this message translates to:
  /// **'1 time'**
  String get oneTime;

  /// Time duration format
  ///
  /// In en, this message translates to:
  /// **'1 hr 21 min'**
  String get hrMin;

  /// Events title
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// Single event label
  ///
  /// In en, this message translates to:
  /// **'event'**
  String get event;

  /// View detailed analysis button text
  ///
  /// In en, this message translates to:
  /// **'View Detailed Analysis'**
  String get viewDetailedAnalysis;

  /// Last 24 hours activity breakdown subtitle
  ///
  /// In en, this message translates to:
  /// **'Last 24 hours activity breakdown'**
  String get last24HoursActivity;

  /// All filter button
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Aggression filter button
  ///
  /// In en, this message translates to:
  /// **'Aggression'**
  String get aggression;

  /// Absent filter button
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get absent;

  /// Idle filter button
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get idle;

  /// Last 24 hours detailed activity analysis subtitle
  ///
  /// In en, this message translates to:
  /// **'Last 24 hours Detailed Activity Analysis'**
  String get last24HoursDetailedActivity;

  /// Export button text
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// Event time segments screen title
  ///
  /// In en, this message translates to:
  /// **'Event Time Segments'**
  String get eventTimeSegments;

  /// Time range table header
  ///
  /// In en, this message translates to:
  /// **'Time Range'**
  String get timeRange;

  /// Peak time label
  ///
  /// In en, this message translates to:
  /// **'Peak'**
  String get peak;

  /// Harassment incident type
  ///
  /// In en, this message translates to:
  /// **'Harassment'**
  String get harassment;

  /// No event label
  ///
  /// In en, this message translates to:
  /// **'No event'**
  String get noEvent;

  /// Incident analysis section title
  ///
  /// In en, this message translates to:
  /// **'Incident Analysis'**
  String get incidentAnalysis;

  /// Incident start time label
  ///
  /// In en, this message translates to:
  /// **'Incident Start Time'**
  String get incidentStartTime;

  /// Incident end time label
  ///
  /// In en, this message translates to:
  /// **'Incident End Time'**
  String get incidentEndTime;

  /// Staff involve label
  ///
  /// In en, this message translates to:
  /// **'Staff involve'**
  String get staffInvolve;

  /// Duration label
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Incident type label
  ///
  /// In en, this message translates to:
  /// **'Incident Type'**
  String get incidentType;

  /// Counter zone label
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get counter;

  /// Downloading file progress message
  ///
  /// In en, this message translates to:
  /// **'Downloading File...'**
  String get downloadingFile;

  /// Download progress percentage
  ///
  /// In en, this message translates to:
  /// **'{percent}% Complete'**
  String percentComplete(int percent);

  /// Cancel download button text
  ///
  /// In en, this message translates to:
  /// **'Cancel Download'**
  String get cancelDownload;

  /// Processing image message
  ///
  /// In en, this message translates to:
  /// **'Processing image...'**
  String get processingImage;

  /// Image too large error message
  ///
  /// In en, this message translates to:
  /// **'Image is too large. Please select a smaller image.'**
  String get imageTooLargeSelectSmaller;

  /// Profile updated success message
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccessfully;

  /// Failed to update profile error message
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get failedToUpdateProfile;

  /// Session expired error message
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please log in again.'**
  String get sessionExpiredPleaseLogin;

  /// Email already in use error message
  ///
  /// In en, this message translates to:
  /// **'This email is already in use by another account.'**
  String get emailAlreadyInUse;

  /// Phone number already in use error message
  ///
  /// In en, this message translates to:
  /// **'This phone number is already in use by another account.'**
  String get phoneNumberAlreadyInUse;

  /// Failed to process image error message
  ///
  /// In en, this message translates to:
  /// **'Failed to process the selected image. Please try another image.'**
  String get failedToProcessImage;

  /// Invalid session error message
  ///
  /// In en, this message translates to:
  /// **'Invalid session. Please log in again.'**
  String get invalidSessionPleaseLogin;

  /// Failed to update profile with error details
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile: {error}'**
  String failedToUpdateProfileWithError(String error);

  /// Change photo button text
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// Photo library option
  ///
  /// In en, this message translates to:
  /// **'Photo Library'**
  String get photoLibrary;

  /// Camera option
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No user session found error message
  ///
  /// In en, this message translates to:
  /// **'No user session found. Please log in again.'**
  String get noUserSessionFound;

  /// Failed to pick image error message
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image: {error}'**
  String failedToPickImage(String error);

  /// Failed to load profile error message
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile: {error}'**
  String failedToLoadProfile(String error);

  /// Please enter valid email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterValidEmail;

  /// Please enter valid phone number validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhoneNumber;

  /// Display name field label
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// Enter display name placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your display name'**
  String get enterDisplayName;

  /// Save changes button text
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Bio field label
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// Bio field placeholder
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get tellUsAboutYourself;

  /// Bio character limit validation message
  ///
  /// In en, this message translates to:
  /// **'Bio cannot exceed 500 characters'**
  String get bioCannotExceed500Characters;
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
    'that was used.',
  );
}
