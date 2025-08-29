import 'package:flutter_test/flutter_test.dart';
import '../lib/l10n/app_localizations_fallback.dart';
import '../lib/l10n/app_localizations_en.dart';
import '../lib/l10n/app_localizations_ar.dart';

/// Mock Arabic localizations that simulate missing translations
class MockAppLocalizationsArWithMissing extends AppLocalizationsAr {
  MockAppLocalizationsArWithMissing() : super();

  @override
  String get welcomeAdmin => ''; // Simulate missing translation

  @override
  String get editProfile => throw Exception('Translation error'); // Simulate error
}

/// Mock English localizations that simulate errors
class MockAppLocalizationsEnWithErrors extends AppLocalizationsEn {
  MockAppLocalizationsEnWithErrors() : super();

  @override
  String get welcomeAdmin => throw Exception('Fallback error'); // Simulate fallback error
}

void main() {
  group('Fallback Mechanism Tests', () {
    test('should fallback to English when Arabic translation is empty', () {
      final mockArabic = MockAppLocalizationsArWithMissing();
      final english = AppLocalizationsEn();
      final fallback = AppLocalizationsFallback(mockArabic, english);

      // Should use English fallback when Arabic is empty
      expect(fallback.welcomeAdmin, equals('Welcome, Admin'));
      
      // Should use Arabic when available
      expect(fallback.logOut, equals('تسجيل الخروج'));
    });

    test('should fallback to English when Arabic translation throws error', () {
      final mockArabic = MockAppLocalizationsArWithMissing();
      final english = AppLocalizationsEn();
      final fallback = AppLocalizationsFallback(mockArabic, english);

      // Should use English fallback when Arabic throws error
      expect(fallback.editProfile, equals('Edit Profile'));
    });

    test('should return key when both primary and fallback fail', () {
      final mockArabic = MockAppLocalizationsArWithMissing();
      final mockEnglish = MockAppLocalizationsEnWithErrors();
      final fallback = AppLocalizationsFallback(mockArabic, mockEnglish);

      // Should return the key itself when both fail
      expect(fallback.welcomeAdmin, equals('welcomeAdmin'));
    });

    test('should handle all translation methods with fallback', () {
      final mockArabic = MockAppLocalizationsArWithMissing();
      final english = AppLocalizationsEn();
      final fallback = AppLocalizationsFallback(mockArabic, english);

      // Test all translation methods to ensure they don't throw
      expect(() => fallback.welcomeAdmin, returnsNormally);
      expect(() => fallback.welcomeSupervisor, returnsNormally);
      expect(() => fallback.welcomeAuditor, returnsNormally);
      expect(() => fallback.editProfile, returnsNormally);
      expect(() => fallback.logOut, returnsNormally);
      expect(() => fallback.privacyAndSecurity, returnsNormally);
      expect(() => fallback.privacySettings, returnsNormally);
      expect(() => fallback.securitySettings, returnsNormally);
      expect(() => fallback.twoFactorAuthentication, returnsNormally);
      expect(() => fallback.language, returnsNormally);
      expect(() => fallback.noEmailSet, returnsNormally);
      expect(() => fallback.auditor, returnsNormally);
      expect(() => fallback.supervisor, returnsNormally);
      expect(() => fallback.admin, returnsNormally);
      expect(() => fallback.user, returnsNormally);
      expect(() => fallback.notificationPreferences, returnsNormally);
      expect(() => fallback.harassmentAlerts, returnsNormally);
      expect(() => fallback.harassmentAlertsSubtitle, returnsNormally);
      expect(() => fallback.inactivityNotifications, returnsNormally);
      expect(() => fallback.inactivityNotificationsSubtitle, returnsNormally);
      expect(() => fallback.mobileUsageAlerts, returnsNormally);
      expect(() => fallback.mobileUsageAlertsSubtitle, returnsNormally);
      expect(() => fallback.reportSettings, returnsNormally);
      expect(() => fallback.autoDownloadWeeklyReports, returnsNormally);
      expect(() => fallback.autoDownloadWeeklyReportsSubtitle, returnsNormally);
      expect(() => fallback.reportFormat, returnsNormally);
      expect(() => fallback.pdf, returnsNormally);
      expect(() => fallback.excel, returnsNormally);
      expect(() => fallback.manageBranches, returnsNormally);
      expect(() => fallback.manageUsers, returnsNormally);
      expect(() => fallback.aiAlertSensitivity, returnsNormally);
      expect(() => fallback.low, returnsNormally);
      expect(() => fallback.medium, returnsNormally);
      expect(() => fallback.high, returnsNormally);

      // Verify that all methods return non-empty strings
      expect(fallback.welcomeAdmin.isNotEmpty, isTrue);
      expect(fallback.editProfile.isNotEmpty, isTrue);
      expect(fallback.logOut.isNotEmpty, isTrue);
      expect(fallback.privacyAndSecurity.isNotEmpty, isTrue);
      expect(fallback.language.isNotEmpty, isTrue);
    });

    test('should preserve Arabic translations when they are valid', () {
      final arabic = AppLocalizationsAr();
      final english = AppLocalizationsEn();
      final fallback = AppLocalizationsFallback(arabic, english);

      // Should use Arabic translations when they are available and valid
      expect(fallback.logOut, equals('تسجيل الخروج'));
      expect(fallback.privacyAndSecurity, equals('الخصوصية والأمان'));
      expect(fallback.language, equals('اللغة'));
      expect(fallback.admin, equals('مدير'));
      expect(fallback.supervisor, equals('مشرف'));
      expect(fallback.auditor, equals('مدقق'));
    });
  });
}