// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get welcomeAdmin => 'مرحباً، المدير';

  @override
  String get welcomeSupervisor => 'مرحباً، المشرف';

  @override
  String get welcomeAuditor => 'مرحباً، المدقق';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get privacyAndSecurity => 'الخصوصية والأمان';

  @override
  String get privacySettings => 'إعدادات الخصوصية';

  @override
  String get securitySettings => 'إعدادات الأمان';

  @override
  String get twoFactorAuthentication => 'المصادقة الثنائية';

  @override
  String get language => 'اللغة';

  @override
  String get noEmailSet => 'لم يتم تعيين بريد إلكتروني';

  @override
  String get auditor => 'مدقق';

  @override
  String get supervisor => 'مشرف';

  @override
  String get admin => 'مدير';

  @override
  String get user => 'مستخدم';

  @override
  String get notificationPreferences => 'تفضيلات الإشعارات';

  @override
  String get harassmentAlerts => 'تنبيهات التحرش';

  @override
  String get harassmentAlertsSubtitle => 'تلقي تنبيهات لحوادث التحرش المحتملة';

  @override
  String get inactivityNotifications => 'إشعارات عدم النشاط';

  @override
  String get inactivityNotificationsSubtitle =>
      'تلقي إشعارات عند عدم اكتشاف أي نشاط';

  @override
  String get mobileUsageAlerts => 'تنبيهات استخدام الهاتف المحمول';

  @override
  String get mobileUsageAlertsSubtitle =>
      'تلقي تنبيهات عند اكتشاف استخدام غير عادي للهاتف المحمول';

  @override
  String get reportSettings => 'إعدادات التقارير';

  @override
  String get autoDownloadWeeklyReports => 'تنزيل التقارير الأسبوعية تلقائ';

  @override
  String get autoDownloadWeeklyReportsSubtitle =>
      'تنزيل التقارير الأسبوعية تلقائ';

  @override
  String get reportFormat => 'تنسيق التقرير';

  @override
  String get pdf => 'PDF';

  @override
  String get excel => 'Excel';

  @override
  String get manageBranches => 'إدارة الفروع';

  @override
  String get manageUsers => 'إدارة المستخدمين';

  @override
  String get aiAlertSensitivity => 'حساسية تنبيهات الذكاء الاصطناعي';

  @override
  String get low => 'منخفض';

  @override
  String get medium => 'متوسط';

  @override
  String get high => 'عالي';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get selectRole => 'اختر الدور';

  @override
  String get selectYourRole => 'اختر دورك';

  @override
  String get pleaseSelectRole => 'يرجى اختيار دور';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get enterYourEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get pleaseEnterEmail => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enterYourPassword => 'أدخل كلمة المرور';

  @override
  String get pleaseEnterPassword => 'يرجى إدخال كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get or => 'أو';

  @override
  String get continueWithGoogle => 'المتابعة مع جوجل';

  @override
  String get signingIn => 'جاري تسجيل الدخول...';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get enterYourFullName => 'أدخل اسمك الكامل';

  @override
  String get pleaseEnterName => 'يرجى إدخال اسمك';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmYourPassword => 'أكد كلمة المرور';

  @override
  String get pleaseConfirmPassword => 'يرجى تأكيد كلمة المرور';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get acceptTerms => 'أوافق على الشروط وسياسة الخصوصية';

  @override
  String get read => 'اقرأ';

  @override
  String get mustAcceptTerms => 'يجب عليك قبول الشروط وسياسة الخصوصية';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String welcomeMessage(String role) {
    return 'مرحباً، $role';
  }

  @override
  String get todaysActivity => 'نشاط اليوم';

  @override
  String get averageBehaviourScore => 'متوسط نقاط السلوك';

  @override
  String get topBranch => 'أفضل فرع';

  @override
  String get productivity => 'الإنتاجية';

  @override
  String get staffPerformance => 'أداء الموظفين';

  @override
  String get topEmployees => 'أفضل الموظفين';

  @override
  String get topEmployeesThisWeek => 'أفضل موظفين هذا الأسبوع';

  @override
  String get branchPerformance => 'أداء الفروع';

  @override
  String get branchesPerformance => 'أداء الفروع';

  @override
  String get recentBehaviours => 'السلوكيات الحديثة';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get exportReport => 'تصدير التقرير';

  @override
  String get aiTag => 'علامة الذكاء الاصطناعي';

  @override
  String get positive => 'إيجابي';

  @override
  String get negative => 'سلبي';

  @override
  String get neutral => 'محايد';

  @override
  String get allBranches => 'جميع الفروع';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get employee => 'الموظف';

  @override
  String get behaviorType => 'نوع السلوك';

  @override
  String get filterByBranch => 'تصفية حسب الفرع';

  @override
  String get showDataFromAllBranches => 'إظهار البيانات من جميع الفروع';

  @override
  String get noAddress => 'لا يوجد عنوان';

  @override
  String switchedToBranch(String branchName) {
    return 'تم التبديل إلى $branchName';
  }

  @override
  String filterApplied(String branchName) {
    return 'تم تطبيق التصفية: $branchName';
  }

  @override
  String get doYouHaveSecretKey => 'هل لديك مفتاح سري؟ إذا كان نعم';

  @override
  String get enterYourSecretKey => 'أدخل مفتاحك السري';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get reports => 'التقارير';

  @override
  String get staff => 'الموظفون';

  @override
  String get settings => 'الإعدادات';

  @override
  String get analytics => 'التحليلات';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجح';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get close => 'إغلاق';

  @override
  String get search => 'بحث';

  @override
  String get noDataAvailable => 'لا توجد بيانات متاحة';

  @override
  String get refresh => 'تحديث';

  @override
  String get networkError => 'خطأ في الشبكة. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get incorrectCredentials =>
      'بريد إلكتروني أو كلمة مرور غير صحيحة. يرجى المحاولة مرة أخرى.';

  @override
  String get googleSignInFailed =>
      'فشل تسجيل الدخول بجوجل. يرجى المحاولة مرة أخرى.';

  @override
  String get differentRoleError =>
      'يوجد حساب بهذا البريد الإلكتروني ولكن بدور مختلف. يرجى تسجيل الدخول بدورك الصحيح، أو إنشاء حساب ببريد إلكتروني مختلف.';

  @override
  String get noAccountFound =>
      'لم يتم العثور على حساب بهذا الحساب في جوجل والدور. يرجى إنشاء حساب أولاً.';

  @override
  String get accountAlreadyLinked =>
      'هذا الحساب في جوجل مرتبط بالفعل بمستخدم آخر. يرجى تسجيل الدخول بحسابك الحالي.';

  @override
  String get networkErrorGoogle =>
      'خطأ في الشبكة أثناء تسجيل الدخول بجوجل. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get googleSignInCancelled => 'تم إلغاء تسجيل الدخول بجوجل.';

  @override
  String get authenticationError =>
      'خطأ في المصادقة أثناء تسجيل الدخول بجوجل. يرجى المحاولة مرة أخرى.';

  @override
  String get verificationCodeFailed =>
      'فشل في إرسال رمز التحقق. يرجى المحاولة مرة أخرى.';

  @override
  String get emailAlreadyExists =>
      'هذا البريد الإلكتروني مسجل بالفعل. يرجى تسجيل الدخول بدلاً من ذلك.';

  @override
  String get googleSignUpFailed =>
      'فشل إنشاء الحساب بجوجل. يرجى المحاولة مرة أخرى.';

  @override
  String get accountAlreadyExists =>
      'يوجد حساب بهذا البريد الإلكتروني بالفعل. يرجى تسجيل الدخول، أو إنشاء حساب ببريد إلكتروني مختلف.';

  @override
  String get googleSignUpCancelled => 'تم إلغاء إنشاء الحساب بجوجل.';

  @override
  String get contactSupport => 'يرجى الاتصال بالدعم للحصول على تفاصيل الشركة';

  @override
  String get users => 'المستخدمون';

  @override
  String get stretchBreakSuggestion =>
      'خذ استراحة تمدد لمدة 10 دقائق كل ساعتين';

  @override
  String get underperformingZones => 'المناطق ضعيفة الأداء';

  @override
  String get aiInsights => 'رؤى الذكاء الاصطناعي';

  @override
  String get attendancePattern => 'نمط الحضور';

  @override
  String get highAbsenteeismDetected =>
      'تم اكتشاف غياب عالي يوم الاثنين. فكر في مراجعة جداول العمل.';

  @override
  String get performanceInsight => 'رؤية الأداء';

  @override
  String get teamEngagementPeaks =>
      'يصل تفاعل الفريق إلى ذروته خلال نوبات بعد الظهر. قم بتحسين توزيع المهام.';

  @override
  String get excellentCustomerService => 'تم تقديم خدمة عملاء ممتازة';

  @override
  String get harassmentBehaviorDetected => 'تم اكتشاف سلوك تحرش في المطبخ';

  @override
  String get extendedBreakTimeObserved => 'لوحظ وقت استراحة مطول';

  @override
  String get frontDesk => 'مكتب الاستقبال';

  @override
  String get serviceArea => 'منطقة الخدمة';

  @override
  String get restArea => 'منطقة الراحة';

  @override
  String get switchBranch => 'تبديل الفرع';

  @override
  String get searchBranch => 'البحث عن فرع';

  @override
  String get searchBranches => 'البحث في الفروع...';

  @override
  String get noBranchesFound => 'لم يتم العثور على فروع';

  @override
  String get noBranchesAvailable => 'لا توجد فروع متاحة';

  @override
  String get tryDifferentSearchTerm => 'جرب مصطلح بحث مختلف';

  @override
  String get unknownBranch => 'غير معروف';

  @override
  String get unknownAddress => 'عنوان غير معروف';

  @override
  String get report => 'التقرير';

  @override
  String get viewAnalytics => 'عرض التحليلات';

  @override
  String get daily => 'يومي';

  @override
  String get weekly => 'أسبوعي';

  @override
  String get monthly => 'شهري';

  @override
  String get incident => 'حادثة';

  @override
  String get behaviors => 'السلوكيات';

  @override
  String get awayTime => 'وقت الغياب';

  @override
  String get lastSevenDays => 'آخر 7 أيام';

  @override
  String get incidentReport => 'تقرير الحوادث';

  @override
  String get behaviorReport => 'تقرير السلوك';

  @override
  String get awayTimeReport => 'تقرير وقت الغياب';

  @override
  String get searchStaff => 'البحث عن موظف..';

  @override
  String get allDepartments => 'جميع الأقسام';

  @override
  String get scoreAll => 'النتيجة: الكل';

  @override
  String get serviceCounter => 'مكتب الخدمة';

  @override
  String get unknownUser => 'مستخدم غير معروف';

  @override
  String get unknownRole => 'دور غير معروف';

  @override
  String get manageBranch => 'إدارة الفروع';

  @override
  String get addNewBranch => 'إضافة فرع جديد';

  @override
  String get addFirstBranch => 'أضف فرعك الأول للبدء';

  @override
  String get branchName => 'اسم الفرع';

  @override
  String get branchAddress => 'عنوان الفرع';

  @override
  String get enterBranchName => 'أدخل اسم الفرع';

  @override
  String get enterBranchAddress => 'أدخل عنوان الفرع';

  @override
  String get branchNameRequired => 'اسم الفرع مطلوب';

  @override
  String get branchAddressRequired => 'عنوان الفرع مطلوب';

  @override
  String get addBranch => 'إضافة فرع';

  @override
  String get branchAddedSuccessfully => 'تم إضافة الفرع بنجاح!';

  @override
  String get addNewUser => 'إضافة مستخدم جديد';

  @override
  String get noUsersFound => 'لم يتم العثور على مستخدمين';

  @override
  String get enterFullName => 'أدخل الاسم الكامل';

  @override
  String get fullNameRequired => 'الاسم الكامل مطلوب';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get enterPhoneNumber => 'أدخل رقم الهاتف';

  @override
  String get phoneNumberRequired => 'رقم الهاتف مطلوب';

  @override
  String get role => 'الدور';

  @override
  String get addUser => 'إضافة مستخدم';

  @override
  String get userAddedSuccessfully => 'تم إضافة المستخدم بنجاح!';

  @override
  String get lastOnline => 'آخر ظهور';

  @override
  String get neverLoggedIn => 'لم يسجل دخول مطلق';

  @override
  String get justNow => 'الآن';

  @override
  String get unknown => 'غير معروف';

  @override
  String get pleaseEnterSecretKey => 'يرجى إدخال مفتاحك السري';

  @override
  String get employeeProfile => 'ملف الموظف';

  @override
  String get behaviorScore => 'نتيجة السلوك';

  @override
  String get attendance => 'الحضور';

  @override
  String moreProductiveThanAverage(String name, String percentage) {
    return '$name أكثر إنتاجية بنسبة $percentage% من المتوسط';
  }

  @override
  String get performanceComparison => 'مقارنة الأداء';

  @override
  String get avgDailyScore => 'متوسط النتيجة اليومية';

  @override
  String get workTime => 'وقت العمل';

  @override
  String get performance => 'الأداء';

  @override
  String get compareStaff => 'مقارنة الموظفين';

  @override
  String awayFromZone(String name, String duration) {
    return '$name غائب عن المنطقة المخصصة لمدة $duration';
  }

  @override
  String get viewCameraLive => 'عرض الكاميرا المباشر';

  @override
  String get frameSnapshots => 'لقطات الإطارات';

  @override
  String get capturedFromFootage => 'مأخوذة من لقطات الأمان';

  @override
  String get videoReview => 'مراجعة الفيديو';

  @override
  String get downloadReport => 'تحميل التقرير';

  @override
  String get workHours => 'ساعات العمل';

  @override
  String get breakTime => 'وقت الاستراحة';

  @override
  String get exportDetailedReportPdf => 'تصدير التقرير المفصل بصيغة PDF';

  @override
  String get includeAiInsights => 'تضمين رؤى الذكاء الاصطناعي';

  @override
  String get includeSnapshots => 'تضمين اللقطات';

  @override
  String get downloadEmployeeSummary => 'تحميل ملخص الموظف';

  @override
  String get yesterday => 'أمس';

  @override
  String get zoneAbsence => 'غياب المنطقة';

  @override
  String get zone => 'المنطقة';

  @override
  String get minutes => 'دقائق';

  @override
  String get forDuration => 'لمدة';

  @override
  String get exportAllReports => 'تصدير جميع التقارير';

  @override
  String get critical => 'حرج';

  @override
  String get warning => 'تحذير';

  @override
  String get fightDetected => 'تم اكتشاف شجار';

  @override
  String get harassmentAlert => 'تنبيه تحرش';

  @override
  String get phoneUsage => 'استخدام الهاتف';

  @override
  String get longBreakAlert => 'تنبيه استراحة طويلة';

  @override
  String get altercationAtCheckoutZone => 'مشاجرة في منطقة الدفع';

  @override
  String aiConfidenceKitchenZone(String percentage) {
    return 'ثقة الذكاء الاصطناعي، منطقة المطبخ $percentage%';
  }

  @override
  String get detectedDuringWorkHours => 'تم الاكتشاف خلال ساعات العمل';

  @override
  String checkoutCounterMinsAway(String minutes) {
    return 'مكتب الدفع: $minutes دقائق بعيداً';
  }

  @override
  String minsAgo(String minutes) {
    return 'منذ $minutes دقائق';
  }

  @override
  String get kitchenZone => 'منطقة المطبخ';

  @override
  String get checkoutZone => 'منطقة الدفع';

  @override
  String get checkoutCounter => 'مكتب الدفع';

  @override
  String get customerAssisted90Satisfaction => 'تم مساعدة العميل - رضا 90%';

  @override
  String get hourAgo => 'منذ ساعة واحدة';

  @override
  String get filterEvents => 'تصفية الأحداث';

  @override
  String get dateRange => 'نطاق التاريخ';

  @override
  String get today => 'اليوم';

  @override
  String get last7Days => 'آخر 7 أيام';

  @override
  String get custom => 'مخصص';

  @override
  String get selectZones => 'اختر المناطق';

  @override
  String get severity => 'الخطورة';

  @override
  String get normal => 'عادي';

  @override
  String get moderate => 'متوسط';

  @override
  String get suspicious => 'مشبوه';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String get zoneA => 'المنطقة أ';

  @override
  String get zoneB => 'المنطقة ب';

  @override
  String get zoneC => 'المنطقة ج';

  @override
  String get zoneD => 'المنطقة د';

  @override
  String get reportType => 'نوع التقرير';

  @override
  String get selectReportType => 'اختر نوع التقرير';

  @override
  String get performanceReport => 'تقرير الأداء';

  @override
  String get attendanceReport => 'تقرير الحضور';

  @override
  String get selectDateRange => 'اختر نطاق التاريخ';

  @override
  String get last30Days => 'آخر 30 يوماً';

  @override
  String get last3Months => 'آخر 3 أشهر';

  @override
  String get last6Months => 'آخر 6 أشهر';

  @override
  String get customRange => 'نطاق مخصص';

  @override
  String get employeeOptional => 'الموظف (اختياري)';

  @override
  String get allEmployees => 'جميع الموظفين';

  @override
  String get exportFormat => 'تنسيق التصدير';

  @override
  String get includeChartsGraphs => 'تضمين الرسوم البيانية/الجداول';

  @override
  String get pleaseSelectReportType => 'يرجى اختيار نوع التقرير';

  @override
  String get pleaseSelectDateRange => 'يرجى اختيار نطاق التاريخ';

  @override
  String get zoneBreakdown => 'تفصيل المناطق';

  @override
  String get totalEvents => 'إجمالي الأحداث';

  @override
  String get behaviour => 'السلوك';

  @override
  String get awaytime => 'وقت الغياب';

  @override
  String get customerArea => 'منطقة العملاء';

  @override
  String get timeSpent => 'الوقت المستغرق';

  @override
  String get incidents => 'الحوادث';

  @override
  String get behavior => 'السلوك';

  @override
  String get oneTime => 'مرة واحدة';

  @override
  String get hrMin => '1 ساعة 21 دقيقة';

  @override
  String get events => 'الأحداث';

  @override
  String get event => 'حدث';

  @override
  String get viewDetailedAnalysis => 'عرض التحليل المفصل';

  @override
  String get last24HoursActivity => 'تفصيل نشاط آخر 24 ساعة';

  @override
  String get all => 'الكل';

  @override
  String get aggression => 'العدوان';

  @override
  String get absent => 'غائب';

  @override
  String get idle => 'خامل';

  @override
  String get last24HoursDetailedActivity => 'تحليل النشاط المفصل لآخر 24 ساعة';

  @override
  String get export => 'تصدير';

  @override
  String get eventTimeSegments => 'شرائح وقت الأحداث';

  @override
  String get timeRange => 'نطاق الوقت';

  @override
  String get peak => 'الذروة';

  @override
  String get harassment => 'تحرش';

  @override
  String get noEvent => 'لا يوجد حدث';

  @override
  String get incidentAnalysis => 'تحليل الحادث';

  @override
  String get incidentStartTime => 'وقت بدء الحادث';

  @override
  String get incidentEndTime => 'وقت انتهاء الحادث';

  @override
  String get staffInvolve => 'الموظفين المعنيين';

  @override
  String get duration => 'المدة';

  @override
  String get incidentType => 'نوع الحادث';

  @override
  String get counter => 'الكاونتر';

  @override
  String get downloadingFile => 'جاري تحميل الملف...';

  @override
  String percentComplete(int percent) {
    return '$percent% مكتمل';
  }

  @override
  String get cancelDownload => 'إلغاء التحميل';

  @override
  String get processingImage => 'جاري معالجة الصورة...';

  @override
  String get imageTooLargeSelectSmaller =>
      'الصورة كبيرة جداً. يرجى اختيار صورة أصغر.';

  @override
  String get profileUpdatedSuccessfully => 'تم تحديث الملف الشخصي بنجاح!';

  @override
  String get failedToUpdateProfile => 'فشل في تحديث الملف الشخصي';

  @override
  String get sessionExpiredPleaseLogin =>
      'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get emailAlreadyInUse =>
      'هذا البريد الإلكتروني مستخدم بالفعل من قبل حساب آخر.';

  @override
  String get phoneNumberAlreadyInUse =>
      'رقم الهاتف هذا مستخدم بالفعل من قبل حساب آخر.';

  @override
  String get failedToProcessImage =>
      'فشل في معالجة الصورة المحددة. يرجى تجربة صورة أخرى.';

  @override
  String get invalidSessionPleaseLogin =>
      'جلسة غير صالحة. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String failedToUpdateProfileWithError(String error) {
    return 'فشل في تحديث الملف الشخصي: $error';
  }

  @override
  String get changePhoto => 'تغيير الصورة';

  @override
  String get photoLibrary => 'مكتبة الصور';

  @override
  String get camera => 'الكاميرا';

  @override
  String get noUserSessionFound =>
      'لم يتم العثور على جلسة مستخدم. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String failedToPickImage(String error) {
    return 'فشل في اختيار الصورة: $error';
  }

  @override
  String failedToLoadProfile(String error) {
    return 'فشل في تحميل الملف الشخصي: $error';
  }

  @override
  String get pleaseEnterValidEmail => 'يرجى إدخال عنوان بريد إلكتروني صالح';

  @override
  String get pleaseEnterValidPhoneNumber => 'يرجى إدخال رقم هاتف صالح';

  @override
  String get displayName => 'الاسم المعروض';

  @override
  String get enterDisplayName => 'أدخل اسمك المعروض';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get bio => 'النبذة الشخصية';

  @override
  String get tellUsAboutYourself => 'أخبرنا عن نفسك';

  @override
  String get bioCannotExceed500Characters =>
      'لا يمكن أن تتجاوز النبذة الشخصية 500 حرف';
}
