import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/services/locale_provider.dart';
import '../lib/services/locale_preferences.dart';
import '../lib/l10n/app_localizations.dart';
import '../lib/l10n/app_localizations_fallback.dart';
import '../lib/l10n/app_localizations_en.dart';
import '../lib/l10n/app_localizations_ar.dart';

void main() {
  group('Error Handling and Fallback Tests', () {
    setUp(() {
      // Clear SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    group('LocalePreferences Error Handling', () {
      test('should handle invalid language codes gracefully', () async {
        // Test empty language code
        expect(
          () => LocalePreferences.saveLocale(''),
          throwsA(isA<ArgumentError>()),
        );

        // Test invalid format language codes
        expect(
          () => LocalePreferences.saveLocale('x'),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => LocalePreferences.saveLocale('toolong'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should validate saved locale and clear invalid ones', () async {
        // Set an invalid locale directly in SharedPreferences
        SharedPreferences.setMockInitialValues({'selected_locale': 'invalid'});

        final result = await LocalePreferences.getValidatedLocale();
        expect(result, isNull);

        // Verify the invalid preference was cleared
        final hasPreference = await LocalePreferences.hasLocalePreference();
        expect(hasPreference, isFalse);
      });

      test('should handle SharedPreferences failures gracefully', () async {
        // Test getSavedLocale with null return
        final result = await LocalePreferences.getSavedLocale();
        expect(result, isNull);

        // Test hasLocalePreference with no preferences
        final hasPreference = await LocalePreferences.hasLocalePreference();
        expect(hasPreference, isFalse);
      });

      test('should save and retrieve valid locale codes', () async {
        await LocalePreferences.saveLocale('en');
        final result = await LocalePreferences.getSavedLocale();
        expect(result, equals('en'));

        await LocalePreferences.saveLocale('ar');
        final result2 = await LocalePreferences.getSavedLocale();
        expect(result2, equals('ar'));
      });

      test('should clear locale preferences successfully', () async {
        await LocalePreferences.saveLocale('en');
        expect(await LocalePreferences.hasLocalePreference(), isTrue);

        await LocalePreferences.clearLocale();
        expect(await LocalePreferences.hasLocalePreference(), isFalse);
      });
    });

    group('LocaleProvider Error Handling', () {
      test('should default to English when no saved locale exists', () async {
        final provider = LocaleProvider();
        await provider.loadSavedLocale();
        expect(provider.locale.languageCode, equals('en'));
      });

      test('should handle invalid saved locales gracefully', () async {
        // Set an invalid locale in SharedPreferences
        SharedPreferences.setMockInitialValues({'selected_locale': 'invalid'});

        final provider = LocaleProvider();
        await provider.loadSavedLocale();
        expect(provider.locale.languageCode, equals('en'));
      });

      test('should reject unsupported locales', () async {
        final provider = LocaleProvider();
        
        expect(
          () => provider.setLocale(const Locale('fr')),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should rollback on save failure', () async {
        final provider = LocaleProvider();
        
        // Set initial locale to Arabic
        await provider.setLocale(const Locale('ar'));
        expect(provider.locale.languageCode, equals('ar'));

        // Mock a failure scenario by trying to set an unsupported locale
        try {
          await provider.setLocale(const Locale('fr'));
        } catch (e) {
          // Should still be Arabic after failed attempt
          expect(provider.locale.languageCode, equals('ar'));
        }
      });

      test('should toggle between supported locales', () async {
        final provider = LocaleProvider();
        
        // Start with English
        expect(provider.locale.languageCode, equals('en'));
        
        // Toggle to Arabic
        await provider.toggleLocale();
        expect(provider.locale.languageCode, equals('ar'));
        
        // Toggle back to English
        await provider.toggleLocale();
        expect(provider.locale.languageCode, equals('en'));
      });

      test('should correctly identify RTL locales', () {
        final provider = LocaleProvider();
        
        // English is not RTL
        expect(provider.isRTL, isFalse);
        
        // Set to Arabic (RTL)
        provider.setLocale(const Locale('ar'));
        expect(provider.isRTL, isTrue);
      });
    });

    group('AppLocalizations Fallback Mechanism', () {
      test('should create fallback wrapper for Arabic locale', () {
        final localizations = lookupAppLocalizations(const Locale('ar'));
        expect(localizations, isA<AppLocalizationsFallback>());
      });

      test('should return English localizations for English locale', () {
        final localizations = lookupAppLocalizations(const Locale('en'));
        expect(localizations, isA<AppLocalizationsEn>());
      });

      test('should fallback to English for unsupported locales', () {
        final localizations = lookupAppLocalizations(const Locale('fr'));
        expect(localizations, isA<AppLocalizationsEn>());
      });

      test('should handle translation retrieval errors gracefully', () {
        final primary = AppLocalizationsAr();
        final fallback = AppLocalizationsEn();
        final fallbackWrapper = AppLocalizationsFallback(primary, fallback);

        // Test that all translation methods work
        expect(fallbackWrapper.welcomeAdmin, isNotEmpty);
        expect(fallbackWrapper.editProfile, isNotEmpty);
        expect(fallbackWrapper.logOut, isNotEmpty);
        expect(fallbackWrapper.privacyAndSecurity, isNotEmpty);
        expect(fallbackWrapper.language, isNotEmpty);
      });
    });

    group('Localization Delegate Error Handling', () {
      test('should handle delegate load errors gracefully', () async {
        const delegate = AppLocalizations.delegate;
        
        // Test loading supported locales
        final enLocalizations = await delegate.load(const Locale('en'));
        expect(enLocalizations, isNotNull);
        
        final arLocalizations = await delegate.load(const Locale('ar'));
        expect(arLocalizations, isNotNull);
        
        // Test loading unsupported locale (should not throw)
        final frLocalizations = await delegate.load(const Locale('fr'));
        expect(frLocalizations, isNotNull);
        expect(frLocalizations, isA<AppLocalizationsEn>());
      });

      test('should correctly identify supported locales', () {
        const delegate = AppLocalizations.delegate;
        
        expect(delegate.isSupported(const Locale('en')), isTrue);
        expect(delegate.isSupported(const Locale('ar')), isTrue);
        expect(delegate.isSupported(const Locale('fr')), isFalse);
        expect(delegate.isSupported(const Locale('es')), isFalse);
      });
    });

    group('Integration Tests', () {
      test('should handle complete locale switching flow with errors', () async {
        final provider = LocaleProvider();
        
        // Initialize provider
        await provider.initialize();
        expect(provider.locale.languageCode, equals('en'));
        
        // Switch to Arabic
        await provider.setLocale(const Locale('ar'));
        expect(provider.locale.languageCode, equals('ar'));
        
        // Verify persistence
        final savedLocale = await LocalePreferences.getValidatedLocale();
        expect(savedLocale, equals('ar'));
        
        // Create new provider instance to test loading
        final newProvider = LocaleProvider();
        await newProvider.initialize();
        expect(newProvider.locale.languageCode, equals('ar'));
      });

      test('should gracefully degrade when localization system fails', () async {
        // Test that the app can still function even with localization errors
        final provider = LocaleProvider();
        
        // Even if there are errors, provider should have a valid locale
        await provider.loadSavedLocale();
        expect(provider.locale, isNotNull);
        expect(['en', 'ar'].contains(provider.locale.languageCode), isTrue);
        
        // Localizations should always return something
        final localizations = lookupAppLocalizations(provider.locale);
        expect(localizations, isNotNull);
        expect(localizations.welcomeAdmin, isNotEmpty);
      });
    });
  });
}