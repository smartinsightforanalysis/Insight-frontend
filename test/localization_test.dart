import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insight/l10n/app_localizations.dart';

void main() {
  group('Localization Infrastructure Tests', () {
    test('AppLocalizations should support English and Arabic', () {
      expect(AppLocalizations.supportedLocales.length, 2);
      expect(AppLocalizations.supportedLocales, contains(const Locale('en')));
      expect(AppLocalizations.supportedLocales, contains(const Locale('ar')));
    });

    test('AppLocalizations delegate should support English and Arabic', () {
      const delegate = AppLocalizations.delegate;
      
      expect(delegate.isSupported(const Locale('en')), true);
      expect(delegate.isSupported(const Locale('ar')), true);
      expect(delegate.isSupported(const Locale('fr')), false);
    });

    test('English localizations should load correctly', () async {
      const delegate = AppLocalizations.delegate;
      final localizations = await delegate.load(const Locale('en'));
      
      expect(localizations.welcomeAdmin, 'Welcome, Admin');
      expect(localizations.logOut, 'Log Out');
      expect(localizations.privacyAndSecurity, 'Privacy and Security');
    });

    test('Arabic localizations should load correctly', () async {
      const delegate = AppLocalizations.delegate;
      final localizations = await delegate.load(const Locale('ar'));
      
      expect(localizations.welcomeAdmin, 'مرحباً، المدير');
      expect(localizations.logOut, 'تسجيل الخروج');
      expect(localizations.privacyAndSecurity, 'الخصوصية والأمان');
    });
  });
}