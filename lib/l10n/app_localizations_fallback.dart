import 'package:flutter/foundation.dart';
import 'app_localizations.dart';

/// A wrapper class that provides fallback functionality for missing translations
/// Falls back to English if a translation is missing or throws an error
class AppLocalizationsFallback extends AppLocalizations {
  final AppLocalizations _primary;
  final AppLocalizations _fallback;

  AppLocalizationsFallback(this._primary, this._fallback)
    : super(_primary.localeName);

  /// Helper method to safely get a translation with fallback
  String _getWithFallback(
    String Function() primaryGetter,
    String Function() fallbackGetter,
    String key,
  ) {
    try {
      final result = primaryGetter();
      // Check if the result is empty or null
      if (result.isEmpty) {
        debugPrint(
          'Empty translation for key "$key" in locale "${_primary.localeName}", using fallback',
        );
        return fallbackGetter();
      }
      return result;
    } catch (e) {
      debugPrint(
        'Error getting translation for key "$key" in locale "${_primary.localeName}": $e',
      );
      debugPrint('Using fallback translation');
      try {
        return fallbackGetter();
      } catch (fallbackError) {
        debugPrint(
          'Error getting fallback translation for key "$key": $fallbackError',
        );
        return key; // Return the key itself as last resort
      }
    }
  }

  @override
  String get welcomeAdmin => _getWithFallback(
    () => _primary.welcomeAdmin,
    () => _fallback.welcomeAdmin,
    'welcomeAdmin',
  );

  @override
  String get welcomeSupervisor => _getWithFallback(
    () => _primary.welcomeSupervisor,
    () => _fallback.welcomeSupervisor,
    'welcomeSupervisor',
  );

  @override
  String get welcomeAuditor => _getWithFallback(
    () => _primary.welcomeAuditor,
    () => _fallback.welcomeAuditor,
    'welcomeAuditor',
  );

  @override
  String get editProfile => _getWithFallback(
    () => _primary.editProfile,
    () => _fallback.editProfile,
    'editProfile',
  );

  @override
  String get logOut =>
      _getWithFallback(() => _primary.logOut, () => _fallback.logOut, 'logOut');

  @override
  String get privacyAndSecurity => _getWithFallback(
    () => _primary.privacyAndSecurity,
    () => _fallback.privacyAndSecurity,
    'privacyAndSecurity',
  );

  @override
  String get privacySettings => _getWithFallback(
    () => _primary.privacySettings,
    () => _fallback.privacySettings,
    'privacySettings',
  );

  @override
  String get securitySettings => _getWithFallback(
    () => _primary.securitySettings,
    () => _fallback.securitySettings,
    'securitySettings',
  );

  @override
  String get twoFactorAuthentication => _getWithFallback(
    () => _primary.twoFactorAuthentication,
    () => _fallback.twoFactorAuthentication,
    'twoFactorAuthentication',
  );

  @override
  String get language => _getWithFallback(
    () => _primary.language,
    () => _fallback.language,
    'language',
  );

  @override
  String get noEmailSet => _getWithFallback(
    () => _primary.noEmailSet,
    () => _fallback.noEmailSet,
    'noEmailSet',
  );

  @override
  String get auditor => _getWithFallback(
    () => _primary.auditor,
    () => _fallback.auditor,
    'auditor',
  );

  @override
  String get supervisor => _getWithFallback(
    () => _primary.supervisor,
    () => _fallback.supervisor,
    'supervisor',
  );

  @override
  String get admin =>
      _getWithFallback(() => _primary.admin, () => _fallback.admin, 'admin');

  @override
  String get user =>
      _getWithFallback(() => _primary.user, () => _fallback.user, 'user');

  @override
  String get notificationPreferences => _getWithFallback(
    () => _primary.notificationPreferences,
    () => _fallback.notificationPreferences,
    'notificationPreferences',
  );

  @override
  String get harassmentAlerts => _getWithFallback(
    () => _primary.harassmentAlerts,
    () => _fallback.harassmentAlerts,
    'harassmentAlerts',
  );

  @override
  String get harassmentAlertsSubtitle => _getWithFallback(
    () => _primary.harassmentAlertsSubtitle,
    () => _fallback.harassmentAlertsSubtitle,
    'harassmentAlertsSubtitle',
  );

  @override
  String get inactivityNotifications => _getWithFallback(
    () => _primary.inactivityNotifications,
    () => _fallback.inactivityNotifications,
    'inactivityNotifications',
  );

  @override
  String get inactivityNotificationsSubtitle => _getWithFallback(
    () => _primary.inactivityNotificationsSubtitle,
    () => _fallback.inactivityNotificationsSubtitle,
    'inactivityNotificationsSubtitle',
  );

  @override
  String get mobileUsageAlerts => _getWithFallback(
    () => _primary.mobileUsageAlerts,
    () => _fallback.mobileUsageAlerts,
    'mobileUsageAlerts',
  );

  @override
  String get mobileUsageAlertsSubtitle => _getWithFallback(
    () => _primary.mobileUsageAlertsSubtitle,
    () => _fallback.mobileUsageAlertsSubtitle,
    'mobileUsageAlertsSubtitle',
  );

  @override
  String get reportSettings => _getWithFallback(
    () => _primary.reportSettings,
    () => _fallback.reportSettings,
    'reportSettings',
  );

  @override
  String get autoDownloadWeeklyReports => _getWithFallback(
    () => _primary.autoDownloadWeeklyReports,
    () => _fallback.autoDownloadWeeklyReports,
    'autoDownloadWeeklyReports',
  );

  @override
  String get autoDownloadWeeklyReportsSubtitle => _getWithFallback(
    () => _primary.autoDownloadWeeklyReportsSubtitle,
    () => _fallback.autoDownloadWeeklyReportsSubtitle,
    'autoDownloadWeeklyReportsSubtitle',
  );

  @override
  String get reportFormat => _getWithFallback(
    () => _primary.reportFormat,
    () => _fallback.reportFormat,
    'reportFormat',
  );

  @override
  String get pdf =>
      _getWithFallback(() => _primary.pdf, () => _fallback.pdf, 'pdf');

  @override
  String get excel =>
      _getWithFallback(() => _primary.excel, () => _fallback.excel, 'excel');

  @override
  String get manageBranches => _getWithFallback(
    () => _primary.manageBranches,
    () => _fallback.manageBranches,
    'manageBranches',
  );

  @override
  String get manageUsers => _getWithFallback(
    () => _primary.manageUsers,
    () => _fallback.manageUsers,
    'manageUsers',
  );

  @override
  String get aiAlertSensitivity => _getWithFallback(
    () => _primary.aiAlertSensitivity,
    () => _fallback.aiAlertSensitivity,
    'aiAlertSensitivity',
  );

  @override
  String get low =>
      _getWithFallback(() => _primary.low, () => _fallback.low, 'low');

  @override
  String get medium =>
      _getWithFallback(() => _primary.medium, () => _fallback.medium, 'medium');

  @override
  String get high =>
      _getWithFallback(() => _primary.high, () => _fallback.high, 'high');

  @override
  String get login =>
      _getWithFallback(() => _primary.login, () => _fallback.login, 'login');

  @override
  String get signup =>
      _getWithFallback(() => _primary.signup, () => _fallback.signup, 'signup');

  @override
  String get selectRole => _getWithFallback(
    () => _primary.selectRole,
    () => _fallback.selectRole,
    'selectRole',
  );

  @override
  String get selectYourRole => _getWithFallback(
    () => _primary.selectYourRole,
    () => _fallback.selectYourRole,
    'selectYourRole',
  );

  @override
  String get pleaseSelectRole => _getWithFallback(
    () => _primary.pleaseSelectRole,
    () => _fallback.pleaseSelectRole,
    'pleaseSelectRole',
  );

  @override
  String get email =>
      _getWithFallback(() => _primary.email, () => _fallback.email, 'email');

  @override
  String get enterYourEmail => _getWithFallback(
    () => _primary.enterYourEmail,
    () => _fallback.enterYourEmail,
    'enterYourEmail',
  );

  @override
  String get pleaseEnterEmail => _getWithFallback(
    () => _primary.pleaseEnterEmail,
    () => _fallback.pleaseEnterEmail,
    'pleaseEnterEmail',
  );

  @override
  String get password => _getWithFallback(
    () => _primary.password,
    () => _fallback.password,
    'password',
  );

  @override
  String get enterYourPassword => _getWithFallback(
    () => _primary.enterYourPassword,
    () => _fallback.enterYourPassword,
    'enterYourPassword',
  );

  @override
  String get pleaseEnterPassword => _getWithFallback(
    () => _primary.pleaseEnterPassword,
    () => _fallback.pleaseEnterPassword,
    'pleaseEnterPassword',
  );

  @override
  String get forgotPassword => _getWithFallback(
    () => _primary.forgotPassword,
    () => _fallback.forgotPassword,
    'forgotPassword',
  );

  @override
  String get or =>
      _getWithFallback(() => _primary.or, () => _fallback.or, 'or');

  @override
  String get continueWithGoogle => _getWithFallback(
    () => _primary.continueWithGoogle,
    () => _fallback.continueWithGoogle,
    'continueWithGoogle',
  );

  @override
  String get signingIn => _getWithFallback(
    () => _primary.signingIn,
    () => _fallback.signingIn,
    'signingIn',
  );

  @override
  String get dontHaveAccount => _getWithFallback(
    () => _primary.dontHaveAccount,
    () => _fallback.dontHaveAccount,
    'dontHaveAccount',
  );

  @override
  String get fullName => _getWithFallback(
    () => _primary.fullName,
    () => _fallback.fullName,
    'fullName',
  );

  @override
  String get enterYourFullName => _getWithFallback(
    () => _primary.enterYourFullName,
    () => _fallback.enterYourFullName,
    'enterYourFullName',
  );

  @override
  String get pleaseEnterName => _getWithFallback(
    () => _primary.pleaseEnterName,
    () => _fallback.pleaseEnterName,
    'pleaseEnterName',
  );

  @override
  String get confirmPassword => _getWithFallback(
    () => _primary.confirmPassword,
    () => _fallback.confirmPassword,
    'confirmPassword',
  );

  @override
  String get confirmYourPassword => _getWithFallback(
    () => _primary.confirmYourPassword,
    () => _fallback.confirmYourPassword,
    'confirmYourPassword',
  );

  @override
  String get pleaseConfirmPassword => _getWithFallback(
    () => _primary.pleaseConfirmPassword,
    () => _fallback.pleaseConfirmPassword,
    'pleaseConfirmPassword',
  );

  @override
  String get passwordsDoNotMatch => _getWithFallback(
    () => _primary.passwordsDoNotMatch,
    () => _fallback.passwordsDoNotMatch,
    'passwordsDoNotMatch',
  );

  @override
  String get acceptTerms => _getWithFallback(
    () => _primary.acceptTerms,
    () => _fallback.acceptTerms,
    'acceptTerms',
  );

  @override
  String get read =>
      _getWithFallback(() => _primary.read, () => _fallback.read, 'read');

  @override
  String get mustAcceptTerms => _getWithFallback(
    () => _primary.mustAcceptTerms,
    () => _fallback.mustAcceptTerms,
    'mustAcceptTerms',
  );

  @override
  String get alreadyHaveAccount => _getWithFallback(
    () => _primary.alreadyHaveAccount,
    () => _fallback.alreadyHaveAccount,
    'alreadyHaveAccount',
  );

  @override
  String welcomeMessage(String role) {
    try {
      return _primary.welcomeMessage(role);
    } catch (e) {
      debugPrint(
        'Error getting welcomeMessage for role "$role" in locale "${_primary.localeName}": $e',
      );
      debugPrint('Using fallback translation');
      try {
        return _fallback.welcomeMessage(role);
      } catch (fallbackError) {
        debugPrint(
          'Error getting fallback welcomeMessage for role "$role": $fallbackError',
        );
        return 'Welcome, $role'; // Return a default message as last resort
      }
    }
  }

  @override
  String get todaysActivity => _getWithFallback(
    () => _primary.todaysActivity,
    () => _fallback.todaysActivity,
    'todaysActivity',
  );

  @override
  String get averageBehaviourScore => _getWithFallback(
    () => _primary.averageBehaviourScore,
    () => _fallback.averageBehaviourScore,
    'averageBehaviourScore',
  );

  @override
  String get topBranch => _getWithFallback(
    () => _primary.topBranch,
    () => _fallback.topBranch,
    'topBranch',
  );

  @override
  String get productivity => _getWithFallback(
    () => _primary.productivity,
    () => _fallback.productivity,
    'productivity',
  );

  @override
  String get staffPerformance => _getWithFallback(
    () => _primary.staffPerformance,
    () => _fallback.staffPerformance,
    'staffPerformance',
  );

  @override
  String get topEmployees => _getWithFallback(
    () => _primary.topEmployees,
    () => _fallback.topEmployees,
    'topEmployees',
  );

  @override
  String get branchPerformance => _getWithFallback(
    () => _primary.branchPerformance,
    () => _fallback.branchPerformance,
    'branchPerformance',
  );

  @override
  String get recentBehaviours => _getWithFallback(
    () => _primary.recentBehaviours,
    () => _fallback.recentBehaviours,
    'recentBehaviours',
  );

  @override
  String get allBranches => _getWithFallback(
    () => _primary.allBranches,
    () => _fallback.allBranches,
    'allBranches',
  );

  @override
  String get thisWeek => _getWithFallback(
    () => _primary.thisWeek,
    () => _fallback.thisWeek,
    'thisWeek',
  );

  @override
  String get employee => _getWithFallback(
    () => _primary.employee,
    () => _fallback.employee,
    'employee',
  );

  @override
  String get behaviorType => _getWithFallback(
    () => _primary.behaviorType,
    () => _fallback.behaviorType,
    'behaviorType',
  );

  @override
  String get filterByBranch => _getWithFallback(
    () => _primary.filterByBranch,
    () => _fallback.filterByBranch,
    'filterByBranch',
  );

  @override
  String get showDataFromAllBranches => _getWithFallback(
    () => _primary.showDataFromAllBranches,
    () => _fallback.showDataFromAllBranches,
    'showDataFromAllBranches',
  );

  @override
  String get noAddress => _getWithFallback(
    () => _primary.noAddress,
    () => _fallback.noAddress,
    'noAddress',
  );

  @override
  String switchedToBranch(String branchName) {
    try {
      return _primary.switchedToBranch(branchName);
    } catch (e) {
      debugPrint(
        'Error getting switchedToBranch for branch "$branchName" in locale "${_primary.localeName}": $e',
      );
      debugPrint('Using fallback translation');
      try {
        return _fallback.switchedToBranch(branchName);
      } catch (fallbackError) {
        debugPrint(
          'Error getting fallback switchedToBranch for branch "$branchName": $fallbackError',
        );
        return 'Switched to $branchName'; // Return a default message as last resort
      }
    }
  }

  @override
  String filterApplied(String branchName) {
    try {
      return _primary.filterApplied(branchName);
    } catch (e) {
      debugPrint(
        'Error getting filterApplied for branch "$branchName" in locale "${_primary.localeName}": $e',
      );
      debugPrint('Using fallback translation');
      try {
        return _fallback.filterApplied(branchName);
      } catch (fallbackError) {
        debugPrint(
          'Error getting fallback filterApplied for branch "$branchName": $fallbackError',
        );
        return 'Filter applied: $branchName'; // Return a default message as last resort
      }
    }
  }

  @override
  String get doYouHaveSecretKey => _getWithFallback(
    () => _primary.doYouHaveSecretKey,
    () => _fallback.doYouHaveSecretKey,
    'doYouHaveSecretKey',
  );

  @override
  String get enterYourSecretKey => _getWithFallback(
    () => _primary.enterYourSecretKey,
    () => _fallback.enterYourSecretKey,
    'enterYourSecretKey',
  );

  @override
  String get yes =>
      _getWithFallback(() => _primary.yes, () => _fallback.yes, 'yes');

  @override
  String get no =>
      _getWithFallback(() => _primary.no, () => _fallback.no, 'no');

  @override
  String get dashboard => _getWithFallback(
    () => _primary.dashboard,
    () => _fallback.dashboard,
    'dashboard',
  );

  @override
  String get reports => _getWithFallback(
    () => _primary.reports,
    () => _fallback.reports,
    'reports',
  );

  @override
  String get staff =>
      _getWithFallback(() => _primary.staff, () => _fallback.staff, 'staff');

  @override
  String get settings => _getWithFallback(
    () => _primary.settings,
    () => _fallback.settings,
    'settings',
  );

  @override
  String get analytics => _getWithFallback(
    () => _primary.analytics,
    () => _fallback.analytics,
    'analytics',
  );

  @override
  String get notifications => _getWithFallback(
    () => _primary.notifications,
    () => _fallback.notifications,
    'notifications',
  );

  @override
  String get profile => _getWithFallback(
    () => _primary.profile,
    () => _fallback.profile,
    'profile',
  );

  @override
  String get changePassword => _getWithFallback(
    () => _primary.changePassword,
    () => _fallback.changePassword,
    'changePassword',
  );

  @override
  String get currentPassword => _getWithFallback(
    () => _primary.currentPassword,
    () => _fallback.currentPassword,
    'currentPassword',
  );

  @override
  String get newPassword => _getWithFallback(
    () => _primary.newPassword,
    () => _fallback.newPassword,
    'newPassword',
  );

  @override
  String get confirmNewPassword => _getWithFallback(
    () => _primary.confirmNewPassword,
    () => _fallback.confirmNewPassword,
    'confirmNewPassword',
  );

  @override
  String get save =>
      _getWithFallback(() => _primary.save, () => _fallback.save, 'save');

  @override
  String get cancel =>
      _getWithFallback(() => _primary.cancel, () => _fallback.cancel, 'cancel');

  @override
  String get loading => _getWithFallback(
    () => _primary.loading,
    () => _fallback.loading,
    'loading',
  );

  @override
  String get error =>
      _getWithFallback(() => _primary.error, () => _fallback.error, 'error');

  @override
  String get success => _getWithFallback(
    () => _primary.success,
    () => _fallback.success,
    'success',
  );

  @override
  String get retry =>
      _getWithFallback(() => _primary.retry, () => _fallback.retry, 'retry');

  @override
  String get close =>
      _getWithFallback(() => _primary.close, () => _fallback.close, 'close');

  @override
  String get search =>
      _getWithFallback(() => _primary.search, () => _fallback.search, 'search');

  @override
  String get noDataAvailable => _getWithFallback(
    () => _primary.noDataAvailable,
    () => _fallback.noDataAvailable,
    'noDataAvailable',
  );

  @override
  String get refresh => _getWithFallback(
    () => _primary.refresh,
    () => _fallback.refresh,
    'refresh',
  );

  @override
  String get networkError => _getWithFallback(
    () => _primary.networkError,
    () => _fallback.networkError,
    'networkError',
  );

  @override
  String get incorrectCredentials => _getWithFallback(
    () => _primary.incorrectCredentials,
    () => _fallback.incorrectCredentials,
    'incorrectCredentials',
  );

  @override
  String get googleSignInFailed => _getWithFallback(
    () => _primary.googleSignInFailed,
    () => _fallback.googleSignInFailed,
    'googleSignInFailed',
  );

  @override
  String get differentRoleError => _getWithFallback(
    () => _primary.differentRoleError,
    () => _fallback.differentRoleError,
    'differentRoleError',
  );

  @override
  String get noAccountFound => _getWithFallback(
    () => _primary.noAccountFound,
    () => _fallback.noAccountFound,
    'noAccountFound',
  );

  @override
  String get accountAlreadyLinked => _getWithFallback(
    () => _primary.accountAlreadyLinked,
    () => _fallback.accountAlreadyLinked,
    'accountAlreadyLinked',
  );

  @override
  String get networkErrorGoogle => _getWithFallback(
    () => _primary.networkErrorGoogle,
    () => _fallback.networkErrorGoogle,
    'networkErrorGoogle',
  );

  @override
  String get googleSignInCancelled => _getWithFallback(
    () => _primary.googleSignInCancelled,
    () => _fallback.googleSignInCancelled,
    'googleSignInCancelled',
  );

  @override
  String get authenticationError => _getWithFallback(
    () => _primary.authenticationError,
    () => _fallback.authenticationError,
    'authenticationError',
  );

  @override
  String get verificationCodeFailed => _getWithFallback(
    () => _primary.verificationCodeFailed,
    () => _fallback.verificationCodeFailed,
    'verificationCodeFailed',
  );

  @override
  String get emailAlreadyExists => _getWithFallback(
    () => _primary.emailAlreadyExists,
    () => _fallback.emailAlreadyExists,
    'emailAlreadyExists',
  );

  @override
  String get googleSignUpFailed => _getWithFallback(
    () => _primary.googleSignUpFailed,
    () => _fallback.googleSignUpFailed,
    'googleSignUpFailed',
  );

  @override
  String get accountAlreadyExists => _getWithFallback(
    () => _primary.accountAlreadyExists,
    () => _fallback.accountAlreadyExists,
    'accountAlreadyExists',
  );

  @override
  String get googleSignUpCancelled => _getWithFallback(
    () => _primary.googleSignUpCancelled,
    () => _fallback.googleSignUpCancelled,
    'googleSignUpCancelled',
  );

  @override
  String get contactSupport => _getWithFallback(
    () => _primary.contactSupport,
    () => _fallback.contactSupport,
    'contactSupport',
  );

  @override
  String get users =>
      _getWithFallback(() => _primary.users, () => _fallback.users, 'users');

  @override
  String get stretchBreakSuggestion => _getWithFallback(
    () => _primary.stretchBreakSuggestion,
    () => _fallback.stretchBreakSuggestion,
    'stretchBreakSuggestion',
  );

  @override
  String get underperformingZones => _getWithFallback(
    () => _primary.underperformingZones,
    () => _fallback.underperformingZones,
    'underperformingZones',
  );

  @override
  String get aiInsights => _getWithFallback(
    () => _primary.aiInsights,
    () => _fallback.aiInsights,
    'aiInsights',
  );

  @override
  String get attendancePattern => _getWithFallback(
    () => _primary.attendancePattern,
    () => _fallback.attendancePattern,
    'attendancePattern',
  );

  @override
  String get highAbsenteeismDetected => _getWithFallback(
    () => _primary.highAbsenteeismDetected,
    () => _fallback.highAbsenteeismDetected,
    'highAbsenteeismDetected',
  );

  @override
  String get performanceInsight => _getWithFallback(
    () => _primary.performanceInsight,
    () => _fallback.performanceInsight,
    'performanceInsight',
  );

  @override
  String get teamEngagementPeaks => _getWithFallback(
    () => _primary.teamEngagementPeaks,
    () => _fallback.teamEngagementPeaks,
    'teamEngagementPeaks',
  );

  @override
  String get excellentCustomerService => _getWithFallback(
    () => _primary.excellentCustomerService,
    () => _fallback.excellentCustomerService,
    'excellentCustomerService',
  );

  @override
  String get harassmentBehaviorDetected => _getWithFallback(
    () => _primary.harassmentBehaviorDetected,
    () => _fallback.harassmentBehaviorDetected,
    'harassmentBehaviorDetected',
  );

  @override
  String get extendedBreakTimeObserved => _getWithFallback(
    () => _primary.extendedBreakTimeObserved,
    () => _fallback.extendedBreakTimeObserved,
    'extendedBreakTimeObserved',
  );

  @override
  String get frontDesk => _getWithFallback(
    () => _primary.frontDesk,
    () => _fallback.frontDesk,
    'frontDesk',
  );

  @override
  String get serviceArea => _getWithFallback(
    () => _primary.serviceArea,
    () => _fallback.serviceArea,
    'serviceArea',
  );

  @override
  String get restArea => _getWithFallback(
    () => _primary.restArea,
    () => _fallback.restArea,
    'restArea',
  );

  @override
  String get switchBranch => _getWithFallback(
    () => _primary.switchBranch,
    () => _fallback.switchBranch,
    'switchBranch',
  );

  @override
  String get searchBranch => _getWithFallback(
    () => _primary.searchBranch,
    () => _fallback.searchBranch,
    'searchBranch',
  );

  @override
  String get searchBranches => _getWithFallback(
    () => _primary.searchBranches,
    () => _fallback.searchBranches,
    'searchBranches',
  );

  @override
  String get noBranchesFound => _getWithFallback(
    () => _primary.noBranchesFound,
    () => _fallback.noBranchesFound,
    'noBranchesFound',
  );

  @override
  String get noBranchesAvailable => _getWithFallback(
    () => _primary.noBranchesAvailable,
    () => _fallback.noBranchesAvailable,
    'noBranchesAvailable',
  );

  @override
  String get tryDifferentSearchTerm => _getWithFallback(
    () => _primary.tryDifferentSearchTerm,
    () => _fallback.tryDifferentSearchTerm,
    'tryDifferentSearchTerm',
  );

  @override
  String get unknownBranch => _getWithFallback(
    () => _primary.unknownBranch,
    () => _fallback.unknownBranch,
    'unknownBranch',
  );

  @override
  String get unknownAddress => _getWithFallback(
    () => _primary.unknownAddress,
    () => _fallback.unknownAddress,
    'unknownAddress',
  );

  @override
  String get report =>
      _getWithFallback(() => _primary.report, () => _fallback.report, 'report');

  @override
  String get viewAnalytics => _getWithFallback(
    () => _primary.viewAnalytics,
    () => _fallback.viewAnalytics,
    'viewAnalytics',
  );

  @override
  String get daily =>
      _getWithFallback(() => _primary.daily, () => _fallback.daily, 'daily');

  @override
  String get weekly =>
      _getWithFallback(() => _primary.weekly, () => _fallback.weekly, 'weekly');

  @override
  String get monthly => _getWithFallback(
    () => _primary.monthly,
    () => _fallback.monthly,
    'monthly',
  );

  @override
  String get incident => _getWithFallback(
    () => _primary.incident,
    () => _fallback.incident,
    'incident',
  );

  @override
  String get behaviors => _getWithFallback(
    () => _primary.behaviors,
    () => _fallback.behaviors,
    'behaviors',
  );

  @override
  String get awayTime => _getWithFallback(
    () => _primary.awayTime,
    () => _fallback.awayTime,
    'awayTime',
  );

  @override
  String get lastSevenDays => _getWithFallback(
    () => _primary.lastSevenDays,
    () => _fallback.lastSevenDays,
    'lastSevenDays',
  );

  @override
  String get incidentReport => _getWithFallback(
    () => _primary.incidentReport,
    () => _fallback.incidentReport,
    'incidentReport',
  );

  @override
  String get behaviorReport => _getWithFallback(
    () => _primary.behaviorReport,
    () => _fallback.behaviorReport,
    'behaviorReport',
  );

  @override
  String get awayTimeReport => _getWithFallback(
    () => _primary.awayTimeReport,
    () => _fallback.awayTimeReport,
    'awayTimeReport',
  );

  @override
  String get searchStaff => _getWithFallback(
    () => _primary.searchStaff,
    () => _fallback.searchStaff,
    'searchStaff',
  );

  @override
  String get allDepartments => _getWithFallback(
    () => _primary.allDepartments,
    () => _fallback.allDepartments,
    'allDepartments',
  );

  @override
  String get scoreAll => _getWithFallback(
    () => _primary.scoreAll,
    () => _fallback.scoreAll,
    'scoreAll',
  );

  @override
  String get serviceCounter => _getWithFallback(
    () => _primary.serviceCounter,
    () => _fallback.serviceCounter,
    'serviceCounter',
  );

  @override
  String get unknownUser => _getWithFallback(
    () => _primary.unknownUser,
    () => _fallback.unknownUser,
    'unknownUser',
  );

  @override
  String get unknownRole => _getWithFallback(
    () => _primary.unknownRole,
    () => _fallback.unknownRole,
    'unknownRole',
  );

  @override
  String get manageBranch => _getWithFallback(
    () => _primary.manageBranch,
    () => _fallback.manageBranch,
    'manageBranch',
  );

  @override
  String get addNewBranch => _getWithFallback(
    () => _primary.addNewBranch,
    () => _fallback.addNewBranch,
    'addNewBranch',
  );

  @override
  String get addFirstBranch => _getWithFallback(
    () => _primary.addFirstBranch,
    () => _fallback.addFirstBranch,
    'addFirstBranch',
  );

  @override
  String get branchName => _getWithFallback(
    () => _primary.branchName,
    () => _fallback.branchName,
    'branchName',
  );

  @override
  String get branchAddress => _getWithFallback(
    () => _primary.branchAddress,
    () => _fallback.branchAddress,
    'branchAddress',
  );

  @override
  String get enterBranchName => _getWithFallback(
    () => _primary.enterBranchName,
    () => _fallback.enterBranchName,
    'enterBranchName',
  );

  @override
  String get enterBranchAddress => _getWithFallback(
    () => _primary.enterBranchAddress,
    () => _fallback.enterBranchAddress,
    'enterBranchAddress',
  );

  @override
  String get branchNameRequired => _getWithFallback(
    () => _primary.branchNameRequired,
    () => _fallback.branchNameRequired,
    'branchNameRequired',
  );

  @override
  String get branchAddressRequired => _getWithFallback(
    () => _primary.branchAddressRequired,
    () => _fallback.branchAddressRequired,
    'branchAddressRequired',
  );

  @override
  String get addBranch => _getWithFallback(
    () => _primary.addBranch,
    () => _fallback.addBranch,
    'addBranch',
  );

  @override
  String get branchAddedSuccessfully => _getWithFallback(
    () => _primary.branchAddedSuccessfully,
    () => _fallback.branchAddedSuccessfully,
    'branchAddedSuccessfully',
  );

  @override
  String get addNewUser => _getWithFallback(
    () => _primary.addNewUser,
    () => _fallback.addNewUser,
    'addNewUser',
  );

  @override
  String get noUsersFound => _getWithFallback(
    () => _primary.noUsersFound,
    () => _fallback.noUsersFound,
    'noUsersFound',
  );

  @override
  String get enterFullName => _getWithFallback(
    () => _primary.enterFullName,
    () => _fallback.enterFullName,
    'enterFullName',
  );

  @override
  String get fullNameRequired => _getWithFallback(
    () => _primary.fullNameRequired,
    () => _fallback.fullNameRequired,
    'fullNameRequired',
  );

  @override
  String get phoneNumber => _getWithFallback(
    () => _primary.phoneNumber,
    () => _fallback.phoneNumber,
    'phoneNumber',
  );

  @override
  String get enterPhoneNumber => _getWithFallback(
    () => _primary.enterPhoneNumber,
    () => _fallback.enterPhoneNumber,
    'enterPhoneNumber',
  );

  @override
  String get phoneNumberRequired => _getWithFallback(
    () => _primary.phoneNumberRequired,
    () => _fallback.phoneNumberRequired,
    'phoneNumberRequired',
  );

  @override
  String get role =>
      _getWithFallback(() => _primary.role, () => _fallback.role, 'role');

  @override
  String get addUser => _getWithFallback(
    () => _primary.addUser,
    () => _fallback.addUser,
    'addUser',
  );

  @override
  String get userAddedSuccessfully => _getWithFallback(
    () => _primary.userAddedSuccessfully,
    () => _fallback.userAddedSuccessfully,
    'userAddedSuccessfully',
  );

  @override
  String get lastOnline => _getWithFallback(
    () => _primary.lastOnline,
    () => _fallback.lastOnline,
    'lastOnline',
  );

  @override
  String get neverLoggedIn => _getWithFallback(
    () => _primary.neverLoggedIn,
    () => _fallback.neverLoggedIn,
    'neverLoggedIn',
  );

  @override
  String get justNow => _getWithFallback(
    () => _primary.justNow,
    () => _fallback.justNow,
    'justNow',
  );

  @override
  String get unknown => _getWithFallback(
    () => _primary.unknown,
    () => _fallback.unknown,
    'unknown',
  );

  @override
  String get pleaseEnterSecretKey => _getWithFallback(
    () => _primary.pleaseEnterSecretKey,
    () => _fallback.pleaseEnterSecretKey,
    'pleaseEnterSecretKey',
  );

  @override
  String get employeeProfile => _getWithFallback(
    () => _primary.employeeProfile,
    () => _fallback.employeeProfile,
    'employeeProfile',
  );

  @override
  String get behaviorScore => _getWithFallback(
    () => _primary.behaviorScore,
    () => _fallback.behaviorScore,
    'behaviorScore',
  );

  @override
  String get attendance => _getWithFallback(
    () => _primary.attendance,
    () => _fallback.attendance,
    'attendance',
  );

  @override
  String moreProductiveThanAverage(String name, String percentage) {
    try {
      return _primary.moreProductiveThanAverage(name, percentage);
    } catch (e) {
      debugPrint(
        'Error getting moreProductiveThanAverage for name "$name", percentage "$percentage" in locale "${_primary.localeName}": $e',
      );
      debugPrint('Using fallback translation');
      try {
        return _fallback.moreProductiveThanAverage(name, percentage);
      } catch (fallbackError) {
        debugPrint(
          'Error getting fallback moreProductiveThanAverage for name "$name", percentage "$percentage": $fallbackError',
        );
        return '$name is $percentage% more productive than average'; // Return a default message as last resort
      }
    }
  }

  @override
  String get performanceComparison => _getWithFallback(
    () => _primary.performanceComparison,
    () => _fallback.performanceComparison,
    'performanceComparison',
  );

  @override
  String get avgDailyScore => _getWithFallback(
    () => _primary.avgDailyScore,
    () => _fallback.avgDailyScore,
    'avgDailyScore',
  );

  @override
  String get workTime => _getWithFallback(
    () => _primary.workTime,
    () => _fallback.workTime,
    'workTime',
  );

  @override
  String get performance => _getWithFallback(
    () => _primary.performance,
    () => _fallback.performance,
    'performance',
  );

  @override
  String get compareStaff => _getWithFallback(
    () => _primary.compareStaff,
    () => _fallback.compareStaff,
    'compareStaff',
  );

  @override
  String awayFromZone(String name, String duration) {
    try {
      return _primary.awayFromZone(name, duration);
    } catch (e) {
      debugPrint(
        'Error getting awayFromZone for name "$name", duration "$duration" in locale "${_primary.localeName}": $e',
      );
      debugPrint('Using fallback translation');
      try {
        return _fallback.awayFromZone(name, duration);
      } catch (fallbackError) {
        debugPrint(
          'Error getting fallback awayFromZone for name "$name", duration "$duration": $fallbackError',
        );
        return '$name is away from assigned zone for $duration'; // Return a default message as last resort
      }
    }
  }

  @override
  String get viewCameraLive => _getWithFallback(
    () => _primary.viewCameraLive,
    () => _fallback.viewCameraLive,
    'viewCameraLive',
  );

  @override
  String get frameSnapshots => _getWithFallback(
    () => _primary.frameSnapshots,
    () => _fallback.frameSnapshots,
    'frameSnapshots',
  );

  @override
  String get capturedFromFootage => _getWithFallback(
    () => _primary.capturedFromFootage,
    () => _fallback.capturedFromFootage,
    'capturedFromFootage',
  );

  @override
  String get videoReview => _getWithFallback(
    () => _primary.videoReview,
    () => _fallback.videoReview,
    'videoReview',
  );

  @override
  String get downloadReport => _getWithFallback(
    () => _primary.downloadReport,
    () => _fallback.downloadReport,
    'downloadReport',
  );

  @override
  String get workHours => _getWithFallback(
    () => _primary.workHours,
    () => _fallback.workHours,
    'workHours',
  );

  @override
  String get breakTime => _getWithFallback(
    () => _primary.breakTime,
    () => _fallback.breakTime,
    'breakTime',
  );

  @override
  String get exportDetailedReportPdf => _getWithFallback(
    () => _primary.exportDetailedReportPdf,
    () => _fallback.exportDetailedReportPdf,
    'exportDetailedReportPdf',
  );

  @override
  String get includeAiInsights => _getWithFallback(
    () => _primary.includeAiInsights,
    () => _fallback.includeAiInsights,
    'includeAiInsights',
  );

  @override
  String get includeSnapshots => _getWithFallback(
    () => _primary.includeSnapshots,
    () => _fallback.includeSnapshots,
    'includeSnapshots',
  );

  @override
  String get downloadEmployeeSummary => _getWithFallback(
    () => _primary.downloadEmployeeSummary,
    () => _fallback.downloadEmployeeSummary,
    'downloadEmployeeSummary',
  );

  @override
  String get viewAll => _getWithFallback(
    () => _primary.viewAll,
    () => _fallback.viewAll,
    'viewAll',
  );

  @override
  String get exportReport => _getWithFallback(
    () => _primary.exportReport,
    () => _fallback.exportReport,
    'exportReport',
  );

  @override
  String get aiTag =>
      _getWithFallback(() => _primary.aiTag, () => _fallback.aiTag, 'aiTag');

  @override
  String get positive => _getWithFallback(
    () => _primary.positive,
    () => _fallback.positive,
    'positive',
  );

  @override
  String get negative => _getWithFallback(
    () => _primary.negative,
    () => _fallback.negative,
    'negative',
  );

  @override
  String get neutral => _getWithFallback(
    () => _primary.neutral,
    () => _fallback.neutral,
    'neutral',
  );

  @override
  String get topEmployeesThisWeek => _getWithFallback(
    () => _primary.topEmployeesThisWeek,
    () => _fallback.topEmployeesThisWeek,
    'topEmployeesThisWeek',
  );

  @override
  String get branchesPerformance => _getWithFallback(
    () => _primary.branchesPerformance,
    () => _fallback.branchesPerformance,
    'branchesPerformance',
  );

  @override
  String get yesterday => _getWithFallback(
    () => _primary.yesterday,
    () => _fallback.yesterday,
    'yesterday',
  );

  @override
  String get zoneAbsence => _getWithFallback(
    () => _primary.zoneAbsence,
    () => _fallback.zoneAbsence,
    'zoneAbsence',
  );

  @override
  String get zone =>
      _getWithFallback(() => _primary.zone, () => _fallback.zone, 'zone');

  @override
  String get minutes => _getWithFallback(
    () => _primary.minutes,
    () => _fallback.minutes,
    'minutes',
  );

  @override
  String get forDuration => _getWithFallback(
    () => _primary.forDuration,
    () => _fallback.forDuration,
    'forDuration',
  );

  @override
  String get exportAllReports => _getWithFallback(
    () => _primary.exportAllReports,
    () => _fallback.exportAllReports,
    'exportAllReports',
  );

  @override
  String get critical => _getWithFallback(
    () => _primary.critical,
    () => _fallback.critical,
    'critical',
  );

  @override
  String get warning => _getWithFallback(
    () => _primary.warning,
    () => _fallback.warning,
    'warning',
  );

  @override
  String get fightDetected => _getWithFallback(
    () => _primary.fightDetected,
    () => _fallback.fightDetected,
    'fightDetected',
  );

  @override
  String get harassmentAlert => _getWithFallback(
    () => _primary.harassmentAlert,
    () => _fallback.harassmentAlert,
    'harassmentAlert',
  );

  @override
  String get phoneUsage => _getWithFallback(
    () => _primary.phoneUsage,
    () => _fallback.phoneUsage,
    'phoneUsage',
  );

  @override
  String get longBreakAlert => _getWithFallback(
    () => _primary.longBreakAlert,
    () => _fallback.longBreakAlert,
    'longBreakAlert',
  );

  @override
  String get altercationAtCheckoutZone => _getWithFallback(
    () => _primary.altercationAtCheckoutZone,
    () => _fallback.altercationAtCheckoutZone,
    'altercationAtCheckoutZone',
  );

  @override
  String aiConfidenceKitchenZone(String percentage) {
    try {
      return _primary.aiConfidenceKitchenZone(percentage);
    } catch (e) {
      debugPrint(
        'Error getting aiConfidenceKitchenZone for percentage "$percentage" in locale "${_primary.localeName}": $e',
      );
      debugPrint('Using fallback translation');
      try {
        return _fallback.aiConfidenceKitchenZone(percentage);
      } catch (fallbackError) {
        debugPrint(
          'Error getting fallback aiConfidenceKitchenZone for percentage "$percentage": $fallbackError',
        );
        return 'AI confidence, Kitchen Zone $percentage%'; // Return a default message as last resort
      }
    }
  }

  @override
  String get detectedDuringWorkHours => _getWithFallback(
    () => _primary.detectedDuringWorkHours,
    () => _fallback.detectedDuringWorkHours,
    'detectedDuringWorkHours',
  );

  @override
  String checkoutCounterMinsAway(String minutes) {
    try {
      return _primary.checkoutCounterMinsAway(minutes);
    } catch (e) {
      debugPrint(
        'Error getting checkoutCounterMinsAway for minutes "$minutes" in locale "${_primary.localeName}": $e',
      );
      debugPrint('Using fallback translation');
      try {
        return _fallback.checkoutCounterMinsAway(minutes);
      } catch (fallbackError) {
        debugPrint(
          'Error getting fallback checkoutCounterMinsAway for minutes "$minutes": $fallbackError',
        );
        return 'Checkout Counter: $minutes mins away'; // Return a default message as last resort
      }
    }
  }

  @override
  String minsAgo(String minutes) {
    try {
      return _primary.minsAgo(minutes);
    } catch (e) {
      debugPrint(
        'Error getting minsAgo for minutes "$minutes" in locale "${_primary.localeName}": $e',
      );
      debugPrint('Using fallback translation');
      try {
        return _fallback.minsAgo(minutes);
      } catch (fallbackError) {
        debugPrint(
          'Error getting fallback minsAgo for minutes "$minutes": $fallbackError',
        );
        return 'mins ago $minutes'; // Return a default message as last resort
      }
    }
  }

  @override
  String get kitchenZone => _getWithFallback(
    () => _primary.kitchenZone,
    () => _fallback.kitchenZone,
    'kitchenZone',
  );

  @override
  String get checkoutZone => _getWithFallback(
    () => _primary.checkoutZone,
    () => _fallback.checkoutZone,
    'checkoutZone',
  );

  @override
  String get checkoutCounter => _getWithFallback(
    () => _primary.checkoutCounter,
    () => _fallback.checkoutCounter,
    'checkoutCounter',
  );

  @override
  String get customerAssisted90Satisfaction => _getWithFallback(
    () => _primary.customerAssisted90Satisfaction,
    () => _fallback.customerAssisted90Satisfaction,
    'customerAssisted90Satisfaction',
  );

  @override
  String get hourAgo => _getWithFallback(
    () => _primary.hourAgo,
    () => _fallback.hourAgo,
    'hourAgo',
  );

  @override
  String get filterEvents => _getWithFallback(
    () => _primary.filterEvents,
    () => _fallback.filterEvents,
    'filterEvents',
  );

  @override
  String get dateRange => _getWithFallback(
    () => _primary.dateRange,
    () => _fallback.dateRange,
    'dateRange',
  );

  @override
  String get today =>
      _getWithFallback(() => _primary.today, () => _fallback.today, 'today');

  @override
  String get last7Days => _getWithFallback(
    () => _primary.last7Days,
    () => _fallback.last7Days,
    'last7Days',
  );

  @override
  String get custom =>
      _getWithFallback(() => _primary.custom, () => _fallback.custom, 'custom');

  @override
  String get selectZones => _getWithFallback(
    () => _primary.selectZones,
    () => _fallback.selectZones,
    'selectZones',
  );

  @override
  String get severity => _getWithFallback(
    () => _primary.severity,
    () => _fallback.severity,
    'severity',
  );

  @override
  String get normal =>
      _getWithFallback(() => _primary.normal, () => _fallback.normal, 'normal');

  @override
  String get moderate => _getWithFallback(
    () => _primary.moderate,
    () => _fallback.moderate,
    'moderate',
  );

  @override
  String get suspicious => _getWithFallback(
    () => _primary.suspicious,
    () => _fallback.suspicious,
    'suspicious',
  );

  @override
  String get reset =>
      _getWithFallback(() => _primary.reset, () => _fallback.reset, 'reset');

  @override
  String get apply =>
      _getWithFallback(() => _primary.apply, () => _fallback.apply, 'apply');

  @override
  String get zoneA =>
      _getWithFallback(() => _primary.zoneA, () => _fallback.zoneA, 'zoneA');

  @override
  String get zoneB =>
      _getWithFallback(() => _primary.zoneB, () => _fallback.zoneB, 'zoneB');

  @override
  String get zoneC =>
      _getWithFallback(() => _primary.zoneC, () => _fallback.zoneC, 'zoneC');

  @override
  String get zoneD =>
      _getWithFallback(() => _primary.zoneD, () => _fallback.zoneD, 'zoneD');

  @override
  String get reportType => _getWithFallback(
    () => _primary.reportType,
    () => _fallback.reportType,
    'reportType',
  );

  @override
  String get selectReportType => _getWithFallback(
    () => _primary.selectReportType,
    () => _fallback.selectReportType,
    'selectReportType',
  );

  @override
  String get performanceReport => _getWithFallback(
    () => _primary.performanceReport,
    () => _fallback.performanceReport,
    'performanceReport',
  );

  @override
  String get attendanceReport => _getWithFallback(
    () => _primary.attendanceReport,
    () => _fallback.attendanceReport,
    'attendanceReport',
  );

  @override
  String get selectDateRange => _getWithFallback(
    () => _primary.selectDateRange,
    () => _fallback.selectDateRange,
    'selectDateRange',
  );

  @override
  String get last30Days => _getWithFallback(
    () => _primary.last30Days,
    () => _fallback.last30Days,
    'last30Days',
  );

  @override
  String get last3Months => _getWithFallback(
    () => _primary.last3Months,
    () => _fallback.last3Months,
    'last3Months',
  );

  @override
  String get last6Months => _getWithFallback(
    () => _primary.last6Months,
    () => _fallback.last6Months,
    'last6Months',
  );

  @override
  String get customRange => _getWithFallback(
    () => _primary.customRange,
    () => _fallback.customRange,
    'customRange',
  );

  @override
  String get employeeOptional => _getWithFallback(
    () => _primary.employeeOptional,
    () => _fallback.employeeOptional,
    'employeeOptional',
  );

  @override
  String get allEmployees => _getWithFallback(
    () => _primary.allEmployees,
    () => _fallback.allEmployees,
    'allEmployees',
  );

  @override
  String get exportFormat => _getWithFallback(
    () => _primary.exportFormat,
    () => _fallback.exportFormat,
    'exportFormat',
  );

  @override
  String get includeChartsGraphs => _getWithFallback(
    () => _primary.includeChartsGraphs,
    () => _fallback.includeChartsGraphs,
    'includeChartsGraphs',
  );

  @override
  String get pleaseSelectReportType => _getWithFallback(
    () => _primary.pleaseSelectReportType,
    () => _fallback.pleaseSelectReportType,
    'pleaseSelectReportType',
  );

  @override
  String get pleaseSelectDateRange => _getWithFallback(
    () => _primary.pleaseSelectDateRange,
    () => _fallback.pleaseSelectDateRange,
    'pleaseSelectDateRange',
  );

  @override
  String get zoneBreakdown => _getWithFallback(
    () => _primary.zoneBreakdown,
    () => _fallback.zoneBreakdown,
    'zoneBreakdown',
  );

  @override
  String get totalEvents => _getWithFallback(
    () => _primary.totalEvents,
    () => _fallback.totalEvents,
    'totalEvents',
  );

  @override
  String get behaviour => _getWithFallback(
    () => _primary.behaviour,
    () => _fallback.behaviour,
    'behaviour',
  );

  @override
  String get awaytime => _getWithFallback(
    () => _primary.awaytime,
    () => _fallback.awaytime,
    'awaytime',
  );

  @override
  String get customerArea => _getWithFallback(
    () => _primary.customerArea,
    () => _fallback.customerArea,
    'customerArea',
  );

  @override
  String get timeSpent => _getWithFallback(
    () => _primary.timeSpent,
    () => _fallback.timeSpent,
    'timeSpent',
  );

  @override
  String get incidents => _getWithFallback(
    () => _primary.incidents,
    () => _fallback.incidents,
    'incidents',
  );

  @override
  String get behavior => _getWithFallback(
    () => _primary.behavior,
    () => _fallback.behavior,
    'behavior',
  );

  @override
  String get oneTime => _getWithFallback(
    () => _primary.oneTime,
    () => _fallback.oneTime,
    'oneTime',
  );

  @override
  String get hrMin =>
      _getWithFallback(() => _primary.hrMin, () => _fallback.hrMin, 'hrMin');

  @override
  String get events =>
      _getWithFallback(() => _primary.events, () => _fallback.events, 'events');

  @override
  String get event =>
      _getWithFallback(() => _primary.event, () => _fallback.event, 'event');

  @override
  String get viewDetailedAnalysis => _getWithFallback(
    () => _primary.viewDetailedAnalysis,
    () => _fallback.viewDetailedAnalysis,
    'viewDetailedAnalysis',
  );

  @override
  String get last24HoursActivity => _getWithFallback(
    () => _primary.last24HoursActivity,
    () => _fallback.last24HoursActivity,
    'last24HoursActivity',
  );

  @override
  String get all =>
      _getWithFallback(() => _primary.all, () => _fallback.all, 'all');

  @override
  String get aggression => _getWithFallback(
    () => _primary.aggression,
    () => _fallback.aggression,
    'aggression',
  );

  @override
  String get absent =>
      _getWithFallback(() => _primary.absent, () => _fallback.absent, 'absent');

  @override
  String get idle =>
      _getWithFallback(() => _primary.idle, () => _fallback.idle, 'idle');

  @override
  String get last24HoursDetailedActivity => _getWithFallback(
    () => _primary.last24HoursDetailedActivity,
    () => _fallback.last24HoursDetailedActivity,
    'last24HoursDetailedActivity',
  );

  @override
  String get export =>
      _getWithFallback(() => _primary.export, () => _fallback.export, 'export');

  @override
  String get eventTimeSegments => _getWithFallback(
    () => _primary.eventTimeSegments,
    () => _fallback.eventTimeSegments,
    'eventTimeSegments',
  );

  @override
  String get timeRange => _getWithFallback(
    () => _primary.timeRange,
    () => _fallback.timeRange,
    'timeRange',
  );

  @override
  String get peak =>
      _getWithFallback(() => _primary.peak, () => _fallback.peak, 'peak');

  @override
  String get harassment => _getWithFallback(
    () => _primary.harassment,
    () => _fallback.harassment,
    'harassment',
  );

  @override
  String get noEvent => _getWithFallback(
    () => _primary.noEvent,
    () => _fallback.noEvent,
    'noEvent',
  );

  @override
  String get incidentAnalysis => _getWithFallback(
    () => _primary.incidentAnalysis,
    () => _fallback.incidentAnalysis,
    'incidentAnalysis',
  );

  @override
  String get incidentStartTime => _getWithFallback(
    () => _primary.incidentStartTime,
    () => _fallback.incidentStartTime,
    'incidentStartTime',
  );

  @override
  String get incidentEndTime => _getWithFallback(
    () => _primary.incidentEndTime,
    () => _fallback.incidentEndTime,
    'incidentEndTime',
  );

  @override
  String get staffInvolve => _getWithFallback(
    () => _primary.staffInvolve,
    () => _fallback.staffInvolve,
    'staffInvolve',
  );

  @override
  String get duration => _getWithFallback(
    () => _primary.duration,
    () => _fallback.duration,
    'duration',
  );

  @override
  String get incidentType => _getWithFallback(
    () => _primary.incidentType,
    () => _fallback.incidentType,
    'incidentType',
  );

  @override
  String get counter => _getWithFallback(
    () => _primary.counter,
    () => _fallback.counter,
    'counter',
  );

  @override
  String get downloadingFile => _getWithFallback(
    () => _primary.downloadingFile,
    () => _fallback.downloadingFile,
    'downloadingFile',
  );

  @override
  String percentComplete(int percent) => _getWithFallback(
    () => _primary.percentComplete(percent),
    () => _fallback.percentComplete(percent),
    'percentComplete',
  );

  @override
  String get cancelDownload => _getWithFallback(
    () => _primary.cancelDownload,
    () => _fallback.cancelDownload,
    'cancelDownload',
  );

  @override
  String get processingImage => _getWithFallback(
    () => _primary.processingImage,
    () => _fallback.processingImage,
    'processingImage',
  );

  @override
  String get imageTooLargeSelectSmaller => _getWithFallback(
    () => _primary.imageTooLargeSelectSmaller,
    () => _fallback.imageTooLargeSelectSmaller,
    'imageTooLargeSelectSmaller',
  );

  @override
  String get profileUpdatedSuccessfully => _getWithFallback(
    () => _primary.profileUpdatedSuccessfully,
    () => _fallback.profileUpdatedSuccessfully,
    'profileUpdatedSuccessfully',
  );

  @override
  String get failedToUpdateProfile => _getWithFallback(
    () => _primary.failedToUpdateProfile,
    () => _fallback.failedToUpdateProfile,
    'failedToUpdateProfile',
  );

  @override
  String get sessionExpiredPleaseLogin => _getWithFallback(
    () => _primary.sessionExpiredPleaseLogin,
    () => _fallback.sessionExpiredPleaseLogin,
    'sessionExpiredPleaseLogin',
  );

  @override
  String get emailAlreadyInUse => _getWithFallback(
    () => _primary.emailAlreadyInUse,
    () => _fallback.emailAlreadyInUse,
    'emailAlreadyInUse',
  );

  @override
  String get phoneNumberAlreadyInUse => _getWithFallback(
    () => _primary.phoneNumberAlreadyInUse,
    () => _fallback.phoneNumberAlreadyInUse,
    'phoneNumberAlreadyInUse',
  );

  @override
  String get failedToProcessImage => _getWithFallback(
    () => _primary.failedToProcessImage,
    () => _fallback.failedToProcessImage,
    'failedToProcessImage',
  );

  @override
  String get invalidSessionPleaseLogin => _getWithFallback(
    () => _primary.invalidSessionPleaseLogin,
    () => _fallback.invalidSessionPleaseLogin,
    'invalidSessionPleaseLogin',
  );

  @override
  String failedToUpdateProfileWithError(String error) => _getWithFallback(
    () => _primary.failedToUpdateProfileWithError(error),
    () => _fallback.failedToUpdateProfileWithError(error),
    'failedToUpdateProfileWithError',
  );

  @override
  String get changePhoto => _getWithFallback(
    () => _primary.changePhoto,
    () => _fallback.changePhoto,
    'changePhoto',
  );

  @override
  String get photoLibrary => _getWithFallback(
    () => _primary.photoLibrary,
    () => _fallback.photoLibrary,
    'photoLibrary',
  );

  @override
  String get camera =>
      _getWithFallback(() => _primary.camera, () => _fallback.camera, 'camera');

  @override
  String get noUserSessionFound => _getWithFallback(
    () => _primary.noUserSessionFound,
    () => _fallback.noUserSessionFound,
    'noUserSessionFound',
  );

  @override
  String failedToPickImage(String error) => _getWithFallback(
    () => _primary.failedToPickImage(error),
    () => _fallback.failedToPickImage(error),
    'failedToPickImage',
  );

  @override
  String failedToLoadProfile(String error) => _getWithFallback(
    () => _primary.failedToLoadProfile(error),
    () => _fallback.failedToLoadProfile(error),
    'failedToLoadProfile',
  );

  @override
  String get pleaseEnterValidEmail => _getWithFallback(
    () => _primary.pleaseEnterValidEmail,
    () => _fallback.pleaseEnterValidEmail,
    'pleaseEnterValidEmail',
  );

  @override
  String get pleaseEnterValidPhoneNumber => _getWithFallback(
    () => _primary.pleaseEnterValidPhoneNumber,
    () => _fallback.pleaseEnterValidPhoneNumber,
    'pleaseEnterValidPhoneNumber',
  );

  @override
  String get displayName => _getWithFallback(
    () => _primary.displayName,
    () => _fallback.displayName,
    'displayName',
  );

  @override
  String get enterDisplayName => _getWithFallback(
    () => _primary.enterDisplayName,
    () => _fallback.enterDisplayName,
    'enterDisplayName',
  );

  @override
  String get saveChanges => _getWithFallback(
    () => _primary.saveChanges,
    () => _fallback.saveChanges,
    'saveChanges',
  );

  @override
  String get bio =>
      _getWithFallback(() => _primary.bio, () => _fallback.bio, 'bio');

  @override
  String get tellUsAboutYourself => _getWithFallback(
    () => _primary.tellUsAboutYourself,
    () => _fallback.tellUsAboutYourself,
    'tellUsAboutYourself',
  );

  @override
  String get bioCannotExceed500Characters => _getWithFallback(
    () => _primary.bioCannotExceed500Characters,
    () => _fallback.bioCannotExceed500Characters,
    'bioCannotExceed500Characters',
  );
}
