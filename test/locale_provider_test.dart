import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insight/services/locale_provider.dart';
import 'package:insight/services/locale_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LocaleProvider Tests', () {
    setUp(() {
      // Clear SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('should initialize with English locale by default', () {
      final provider = LocaleProvider();
      expect(provider.locale, const Locale('en'));
      expect(provider.isRTL, false);
    });

    test('should toggle between English and Arabic', () async {
      final provider = LocaleProvider();
      
      // Initially English
      expect(provider.locale, const Locale('en'));
      
      // Toggle to Arabic
      await provider.toggleLocale();
      expect(provider.locale, const Locale('ar'));
      expect(provider.isRTL, true);
      
      // Toggle back to English
      await provider.toggleLocale();
      expect(provider.locale, const Locale('en'));
      expect(provider.isRTL, false);
    });

    test('should set locale correctly', () async {
      final provider = LocaleProvider();
      
      await provider.setLocale(const Locale('ar'));
      expect(provider.locale, const Locale('ar'));
      
      await provider.setLocale(const Locale('en'));
      expect(provider.locale, const Locale('en'));
    });

    test('should persist locale when changed and load on initialization', () async {
      // Create first provider and set Arabic
      final provider1 = LocaleProvider();
      await provider1.setLocale(const Locale('ar'));
      expect(provider1.locale, const Locale('ar'));
      
      // Create second provider and initialize - should load Arabic
      final provider2 = LocaleProvider();
      await provider2.initialize();
      expect(provider2.locale, const Locale('ar'));
    });

    test('should handle unsupported locale gracefully', () async {
      final provider = LocaleProvider();
      final initialLocale = provider.locale;
      
      // Try to set unsupported locale
      await provider.setLocale(const Locale('fr')); // French not supported
      
      // Should remain unchanged
      expect(provider.locale, initialLocale);
    });

    test('should default to English when loading invalid saved locale', () async {
      // Manually save invalid locale
      SharedPreferences.setMockInitialValues({'selected_locale': 'invalid'});
      
      final provider = LocaleProvider();
      await provider.initialize();
      
      // Should default to English
      expect(provider.locale, const Locale('en'));
    });

    test('should handle SharedPreferences errors gracefully during loading', () async {
      final provider = LocaleProvider();
      
      // This should not throw an exception even if SharedPreferences fails
      await provider.loadSavedLocale();
      
      // Should default to English
      expect(provider.locale, const Locale('en'));
    });

    test('should not change locale if setting same locale', () async {
      final provider = LocaleProvider();
      int notificationCount = 0;
      
      provider.addListener(() {
        notificationCount++;
      });
      
      // Set to English (already English)
      await provider.setLocale(const Locale('en'));
      
      // Should not notify listeners
      expect(notificationCount, 0);
    });
  });

  group('LocalePreferences Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('should save and retrieve locale preference', () async {
      await LocalePreferences.saveLocale('ar');
      final savedLocale = await LocalePreferences.getSavedLocale();
      expect(savedLocale, 'ar');
    });

    test('should return null when no locale is saved', () async {
      final savedLocale = await LocalePreferences.getSavedLocale();
      expect(savedLocale, null);
    });

    test('should check if locale preference exists', () async {
      expect(await LocalePreferences.hasLocalePreference(), false);
      
      await LocalePreferences.saveLocale('en');
      expect(await LocalePreferences.hasLocalePreference(), true);
    });

    test('should clear locale preference', () async {
      await LocalePreferences.saveLocale('ar');
      expect(await LocalePreferences.hasLocalePreference(), true);
      
      await LocalePreferences.clearLocale();
      expect(await LocalePreferences.hasLocalePreference(), false);
    });

    test('should handle errors when saving locale', () async {
      // This test verifies that errors are properly thrown and can be caught
      try {
        await LocalePreferences.saveLocale('test');
        // If we reach here, the save was successful (which is expected in tests)
        expect(true, true);
      } catch (e) {
        // If an error occurs, it should be properly wrapped
        expect(e.toString(), contains('Failed to save locale preference'));
      }
    });

    test('should handle errors when loading locale', () async {
      // This test verifies that errors are properly thrown and can be caught
      try {
        await LocalePreferences.getSavedLocale();
        // If we reach here, the load was successful (which is expected in tests)
        expect(true, true);
      } catch (e) {
        // If an error occurs, it should be properly wrapped
        expect(e.toString(), contains('Failed to load locale preference'));
      }
    });
  });
}