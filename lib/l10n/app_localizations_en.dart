// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeAdmin => 'Welcome, Admin';

  @override
  String get welcomeSupervisor => 'Welcome, Supervisor';

  @override
  String get welcomeAuditor => 'Welcome, Auditor';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get logOut => 'Log Out';

  @override
  String get privacyAndSecurity => 'Privacy and Security';

  @override
  String get privacySettings => 'Privacy Settings';

  @override
  String get securitySettings => 'Security Settings';

  @override
  String get twoFactorAuthentication => 'Two-Factor Authentication';

  @override
  String get language => 'Language';

  @override
  String get noEmailSet => 'No email set';

  @override
  String get auditor => 'Auditor';

  @override
  String get supervisor => 'Supervisor';

  @override
  String get admin => 'Admin';

  @override
  String get user => 'User';

  @override
  String get notificationPreferences => 'Notification Preferences';

  @override
  String get harassmentAlerts => 'Harassment Alerts';

  @override
  String get harassmentAlertsSubtitle =>
      'Receive alerts for potential harassment incidents';

  @override
  String get inactivityNotifications => 'Inactivity Notifications';

  @override
  String get inactivityNotificationsSubtitle =>
      'Receive notifications when no activity is detected';

  @override
  String get mobileUsageAlerts => 'Mobile Usage Alerts';

  @override
  String get mobileUsageAlertsSubtitle =>
      'Receive alerts when unusual mobile usage is detected';

  @override
  String get reportSettings => 'Report Settings';

  @override
  String get autoDownloadWeeklyReports => 'Auto-download weekly reports';

  @override
  String get autoDownloadWeeklyReportsSubtitle =>
      'Automatically download weekly reports in your preferred format.';

  @override
  String get reportFormat => 'Report Format';

  @override
  String get pdf => 'PDF';

  @override
  String get excel => 'Excel';

  @override
  String get manageBranches => 'Manage Branches';

  @override
  String get manageUsers => 'Manage Users';

  @override
  String get aiAlertSensitivity => 'AI Alert Sensitivity';

  @override
  String get low => 'Low';

  @override
  String get medium => 'Medium';

  @override
  String get high => 'High';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Signup';

  @override
  String get selectRole => 'Select Role';

  @override
  String get selectYourRole => 'Select your role';

  @override
  String get pleaseSelectRole => 'Please select a role';

  @override
  String get email => 'Email';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get password => 'Password';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get or => 'or';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get signingIn => 'Signing in...';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterYourFullName => 'Enter your full name';

  @override
  String get pleaseEnterName => 'Please enter your name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmYourPassword => 'Confirm your password';

  @override
  String get pleaseConfirmPassword => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get acceptTerms => 'I accept the terms and Privacy policy';

  @override
  String get read => 'Read';

  @override
  String get mustAcceptTerms => 'You must accept the terms and privacy policy';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String welcomeMessage(String role) {
    return 'Welcome, $role';
  }

  @override
  String get todaysActivity => 'Today\'s Activity';

  @override
  String get averageBehaviourScore => 'Average Behaviour score';

  @override
  String get topBranch => 'Top Branch';

  @override
  String get productivity => 'Productivity';

  @override
  String get staffPerformance => 'Staff Performance';

  @override
  String get topEmployees => 'Top Employees';

  @override
  String get topEmployeesThisWeek => 'Top Employees This Week';

  @override
  String get branchPerformance => 'Branch Performance';

  @override
  String get branchesPerformance => 'Branches Performance';

  @override
  String get recentBehaviours => 'Recent Behaviours';

  @override
  String get viewAll => 'View All';

  @override
  String get exportReport => 'Export Report';

  @override
  String get aiTag => 'AI Tag';

  @override
  String get positive => 'Positive';

  @override
  String get negative => 'Negative';

  @override
  String get neutral => 'Neutral';

  @override
  String get allBranches => 'All Branches';

  @override
  String get thisWeek => 'This Week';

  @override
  String get employee => 'Employee';

  @override
  String get behaviorType => 'Behavior Type';

  @override
  String get filterByBranch => 'Filter by Branch';

  @override
  String get showDataFromAllBranches => 'Show data from all branches';

  @override
  String get noAddress => 'No address';

  @override
  String switchedToBranch(String branchName) {
    return 'Switched to $branchName';
  }

  @override
  String filterApplied(String branchName) {
    return 'Filter applied: $branchName';
  }

  @override
  String get doYouHaveSecretKey => 'Do you have a secret key? If Yes';

  @override
  String get enterYourSecretKey => 'Enter your secret key';

  @override
  String get yes => 'YES';

  @override
  String get no => 'NO';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get reports => 'Reports';

  @override
  String get staff => 'Staff';

  @override
  String get settings => 'Settings';

  @override
  String get analytics => 'Analytics';

  @override
  String get notifications => 'Notifications';

  @override
  String get profile => 'Profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get search => 'Search';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get refresh => 'Refresh';

  @override
  String get networkError =>
      'Network error. Please check your internet connection.';

  @override
  String get incorrectCredentials =>
      'Incorrect email or password. Please try again.';

  @override
  String get googleSignInFailed => 'Google sign-in failed. Please try again.';

  @override
  String get differentRoleError =>
      'An account with this email exists but with a different role. Please try logging in with your correct role, or sign up with a different email.';

  @override
  String get noAccountFound =>
      'No account found with this Google account and role. Please sign up first.';

  @override
  String get accountAlreadyLinked =>
      'This Google account is already linked to another user. Please try logging in with your existing account.';

  @override
  String get networkErrorGoogle =>
      'Network error during Google sign-in. Please check your internet connection.';

  @override
  String get googleSignInCancelled => 'Google sign-in was cancelled.';

  @override
  String get authenticationError =>
      'Authentication error during Google sign-in. Please try again.';

  @override
  String get verificationCodeFailed =>
      'Failed to send verification code. Please try again.';

  @override
  String get emailAlreadyExists =>
      'This email is already registered. Please try logging in instead.';

  @override
  String get googleSignUpFailed => 'Google sign-up failed. Please try again.';

  @override
  String get accountAlreadyExists =>
      'An account with this email already exists. Please try logging in, or sign up with a different email.';

  @override
  String get googleSignUpCancelled => 'Google sign-up was cancelled.';

  @override
  String get contactSupport => 'Please contact Support for Company Details';

  @override
  String get users => 'Users';

  @override
  String get stretchBreakSuggestion =>
      'Take a 10-min stretch break every 2 hours';

  @override
  String get underperformingZones => 'Underperforming zones';

  @override
  String get aiInsights => 'AI Insights';

  @override
  String get attendancePattern => 'Attendance Pattern';

  @override
  String get highAbsenteeismDetected =>
      'High absenteeism detected on Mondays. Consider reviewing work schedules.';

  @override
  String get performanceInsight => 'Performance Insight';

  @override
  String get teamEngagementPeaks =>
      'Team engagement peaks during afternoon shifts. Optimize task allocation.';

  @override
  String get excellentCustomerService => 'Excellent customer service provided';

  @override
  String get harassmentBehaviorDetected =>
      'Harassment behavior detected at Kitchen';

  @override
  String get extendedBreakTimeObserved => 'Extended break time observed';

  @override
  String get frontDesk => 'Front Desk';

  @override
  String get serviceArea => 'Service area';

  @override
  String get restArea => 'Rest area';

  @override
  String get switchBranch => 'Switch Branch';

  @override
  String get searchBranch => 'Search Branch';

  @override
  String get searchBranches => 'Search branches...';

  @override
  String get noBranchesFound => 'No branches found';

  @override
  String get noBranchesAvailable => 'No branches available';

  @override
  String get tryDifferentSearchTerm => 'Try a different search term';

  @override
  String get unknownBranch => 'Unknown';

  @override
  String get unknownAddress => 'Unknown Address';

  @override
  String get report => 'Report';

  @override
  String get viewAnalytics => 'View Analytics';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get incident => 'Incident';

  @override
  String get behaviors => 'Behaviors';

  @override
  String get awayTime => 'Away time';

  @override
  String get lastSevenDays => 'Last 7 days';

  @override
  String get incidentReport => 'Incident Report';

  @override
  String get behaviorReport => 'Behavior Report';

  @override
  String get awayTimeReport => 'Away Time Report';

  @override
  String get searchStaff => 'Search Staff..';

  @override
  String get allDepartments => 'All Departments';

  @override
  String get scoreAll => 'Score: All';

  @override
  String get serviceCounter => 'Service Counter';

  @override
  String get unknownUser => 'Unknown User';

  @override
  String get unknownRole => 'Unknown Role';

  @override
  String get manageBranch => 'Manage Branch';

  @override
  String get addNewBranch => 'Add New Branch';

  @override
  String get addFirstBranch => 'Add your first branch to get started';

  @override
  String get branchName => 'Branch Name';

  @override
  String get branchAddress => 'Branch Address';

  @override
  String get enterBranchName => 'Enter branch name';

  @override
  String get enterBranchAddress => 'Enter branch address';

  @override
  String get branchNameRequired => 'Branch name is required';

  @override
  String get branchAddressRequired => 'Branch address is required';

  @override
  String get addBranch => 'Add Branch';

  @override
  String get branchAddedSuccessfully => 'Branch added successfully!';

  @override
  String get addNewUser => 'Add New User';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get enterFullName => 'Enter full name';

  @override
  String get fullNameRequired => 'Full name is required';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get enterPhoneNumber => 'Enter phone number';

  @override
  String get phoneNumberRequired => 'Phone number is required';

  @override
  String get role => 'Role';

  @override
  String get addUser => 'Add User';

  @override
  String get userAddedSuccessfully => 'User added successfully!';

  @override
  String get lastOnline => 'Last online';

  @override
  String get neverLoggedIn => 'Never logged in';

  @override
  String get justNow => 'Just now';

  @override
  String get unknown => 'Unknown';

  @override
  String get pleaseEnterSecretKey => 'Please enter your secret key';

  @override
  String get employeeProfile => 'Employee Profile';

  @override
  String get behaviorScore => 'Behavior Score';

  @override
  String get attendance => 'Attendance';

  @override
  String moreProductiveThanAverage(String name, String percentage) {
    return '$name is $percentage% more productive than average';
  }

  @override
  String get performanceComparison => 'Performance Comparison';

  @override
  String get avgDailyScore => 'Avg Daily Score';

  @override
  String get workTime => 'Work Time';

  @override
  String get performance => 'Performance';

  @override
  String get compareStaff => 'Compare Staff';

  @override
  String awayFromZone(String name, String duration) {
    return '$name is away from assigned zone for $duration';
  }

  @override
  String get viewCameraLive => 'View camera live';

  @override
  String get frameSnapshots => 'Frame Snapshots';

  @override
  String get capturedFromFootage => 'Captured from security footage';

  @override
  String get videoReview => 'Video Review';

  @override
  String get downloadReport => 'Download Report';

  @override
  String get workHours => 'Work Hours';

  @override
  String get breakTime => 'Break Time';

  @override
  String get exportDetailedReportPdf =>
      'Export the detailed report in PDF format';

  @override
  String get includeAiInsights => 'Include AI Insights';

  @override
  String get includeSnapshots => 'Include Snapshots';

  @override
  String get downloadEmployeeSummary => 'Download Employee Summary';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get zoneAbsence => 'Zone Absence';

  @override
  String get zone => 'Zone';

  @override
  String get minutes => 'minutes';

  @override
  String get forDuration => 'for';

  @override
  String get exportAllReports => 'Export All Reports';

  @override
  String get critical => 'Critical';

  @override
  String get warning => 'Warning';

  @override
  String get fightDetected => 'Fight Detected';

  @override
  String get harassmentAlert => 'Harassment Alert';

  @override
  String get phoneUsage => 'Phone Usage';

  @override
  String get longBreakAlert => 'Long Break Alert';

  @override
  String get altercationAtCheckoutZone => 'Altercation at Checkout Zone';

  @override
  String aiConfidenceKitchenZone(String percentage) {
    return 'AI confidence, Kitchen Zone $percentage%';
  }

  @override
  String get detectedDuringWorkHours => 'Detected during work hours';

  @override
  String checkoutCounterMinsAway(String minutes) {
    return 'Checkout Counter: $minutes mins away';
  }

  @override
  String minsAgo(String minutes) {
    return 'mins ago $minutes';
  }

  @override
  String get kitchenZone => 'Kitchen Zone';

  @override
  String get checkoutZone => 'Checkout Zone';

  @override
  String get checkoutCounter => 'Checkout Counter';

  @override
  String get customerAssisted90Satisfaction =>
      'Customer assisted - 90% satisfaction';

  @override
  String get hourAgo => '1 hour ago';

  @override
  String get filterEvents => 'Filter Events';

  @override
  String get dateRange => 'Date Range';

  @override
  String get today => 'Today';

  @override
  String get last7Days => 'Last 7 days';

  @override
  String get custom => 'Custom';

  @override
  String get selectZones => 'Select zones';

  @override
  String get severity => 'Severity';

  @override
  String get normal => 'Normal';

  @override
  String get moderate => 'Moderate';

  @override
  String get suspicious => 'Suspicious';

  @override
  String get reset => 'Reset';

  @override
  String get apply => 'Apply';

  @override
  String get zoneA => 'Zone A';

  @override
  String get zoneB => 'Zone B';

  @override
  String get zoneC => 'Zone C';

  @override
  String get zoneD => 'Zone D';

  @override
  String get reportType => 'Report Type';

  @override
  String get selectReportType => 'Select report type';

  @override
  String get performanceReport => 'Performance Report';

  @override
  String get attendanceReport => 'Attendance Report';

  @override
  String get selectDateRange => 'Select date range';

  @override
  String get last30Days => 'Last 30 days';

  @override
  String get last3Months => 'Last 3 months';

  @override
  String get last6Months => 'Last 6 months';

  @override
  String get customRange => 'Custom range';

  @override
  String get employeeOptional => 'Employee (optional)';

  @override
  String get allEmployees => 'All employees';

  @override
  String get exportFormat => 'Export Format';

  @override
  String get includeChartsGraphs => 'Include Charts/Graphs';

  @override
  String get pleaseSelectReportType => 'Please select a report type';

  @override
  String get pleaseSelectDateRange => 'Please select a date range';

  @override
  String get zoneBreakdown => 'Zone Breakdown';

  @override
  String get totalEvents => 'Total Events';

  @override
  String get behaviour => 'Behaviour';

  @override
  String get awaytime => 'Awaytime';

  @override
  String get customerArea => 'Customer Area';

  @override
  String get timeSpent => 'Time Spent';

  @override
  String get incidents => 'Incidents';

  @override
  String get behavior => 'Behaviour';

  @override
  String get oneTime => '1 time';

  @override
  String get hrMin => '1 hr 21 min';

  @override
  String get events => 'Events';

  @override
  String get event => 'event';

  @override
  String get viewDetailedAnalysis => 'View Detailed Analysis';

  @override
  String get last24HoursActivity => 'Last 24 hours activity breakdown';

  @override
  String get all => 'All';

  @override
  String get aggression => 'Aggression';

  @override
  String get absent => 'Absent';

  @override
  String get idle => 'Idle';

  @override
  String get last24HoursDetailedActivity =>
      'Last 24 hours Detailed Activity Analysis';

  @override
  String get export => 'Export';

  @override
  String get eventTimeSegments => 'Event Time Segments';

  @override
  String get timeRange => 'Time Range';

  @override
  String get peak => 'Peak';

  @override
  String get harassment => 'Harassment';

  @override
  String get noEvent => 'No event';

  @override
  String get incidentAnalysis => 'Incident Analysis';

  @override
  String get incidentStartTime => 'Incident Start Time';

  @override
  String get incidentEndTime => 'Incident End Time';

  @override
  String get staffInvolve => 'Staff involve';

  @override
  String get duration => 'Duration';

  @override
  String get incidentType => 'Incident Type';

  @override
  String get counter => 'Counter';

  @override
  String get downloadingFile => 'Downloading File...';

  @override
  String percentComplete(int percent) {
    return '$percent% Complete';
  }

  @override
  String get cancelDownload => 'Cancel Download';

  @override
  String get processingImage => 'Processing image...';

  @override
  String get imageTooLargeSelectSmaller =>
      'Image is too large. Please select a smaller image.';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully!';

  @override
  String get failedToUpdateProfile => 'Failed to update profile';

  @override
  String get sessionExpiredPleaseLogin =>
      'Session expired. Please log in again.';

  @override
  String get emailAlreadyInUse =>
      'This email is already in use by another account.';

  @override
  String get phoneNumberAlreadyInUse =>
      'This phone number is already in use by another account.';

  @override
  String get failedToProcessImage =>
      'Failed to process the selected image. Please try another image.';

  @override
  String get invalidSessionPleaseLogin =>
      'Invalid session. Please log in again.';

  @override
  String failedToUpdateProfileWithError(String error) {
    return 'Failed to update profile: $error';
  }

  @override
  String get changePhoto => 'Change Photo';

  @override
  String get photoLibrary => 'Photo Library';

  @override
  String get camera => 'Camera';

  @override
  String get noUserSessionFound =>
      'No user session found. Please log in again.';

  @override
  String failedToPickImage(String error) {
    return 'Failed to pick image: $error';
  }

  @override
  String failedToLoadProfile(String error) {
    return 'Failed to load profile: $error';
  }

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email address';

  @override
  String get pleaseEnterValidPhoneNumber => 'Please enter a valid phone number';

  @override
  String get displayName => 'Display Name';

  @override
  String get enterDisplayName => 'Enter your display name';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get bio => 'Bio';

  @override
  String get tellUsAboutYourself => 'Tell us about yourself';

  @override
  String get bioCannotExceed500Characters => 'Bio cannot exceed 500 characters';
}
