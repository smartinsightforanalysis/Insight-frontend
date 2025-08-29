import 'package:flutter/material.dart';
import 'locale_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  Locale get locale => _locale;

  /// Initialize the provider and load saved locale
  Future<void> initialize() async {
    await loadSavedLocale();
  }

  /// Set the locale and save it to preferences
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    // Validate that the locale is supported
    if (!supportedLocales.contains(locale)) {
      debugPrint('Unsupported locale: ${locale.languageCode}');
      throw ArgumentError('Unsupported locale: ${locale.languageCode}. Supported locales: ${supportedLocales.map((l) => l.languageCode).join(', ')}');
    }
    
    // Store the previous locale in case we need to rollback
    final previousLocale = _locale;
    
    try {
      _locale = locale;
      notifyListeners();
      
      await LocalePreferences.saveLocale(locale.languageCode);
      debugPrint('Successfully set locale to: ${locale.languageCode}');
    } catch (e) {
      // Rollback to previous locale if saving fails
      debugPrint('Error saving locale preference: $e');
      debugPrint('Rolling back to previous locale: ${previousLocale.languageCode}');
      _locale = previousLocale;
      notifyListeners();
      
      // Re-throw the error so callers can handle it
      throw Exception('Failed to set locale to ${locale.languageCode}: $e');
    }
  }

  /// Load saved locale from preferences
  Future<void> loadSavedLocale() async {
    try {
      final savedLocaleCode = await LocalePreferences.getValidatedLocale();
      
      if (savedLocaleCode != null && savedLocaleCode.isNotEmpty) {
        final savedLocale = Locale(savedLocaleCode);
        // Double-check that the saved locale is supported (should be validated already)
        if (supportedLocales.contains(savedLocale)) {
          _locale = savedLocale;
          notifyListeners();
          debugPrint('Successfully loaded saved locale: $savedLocaleCode');
        } else {
          debugPrint('Validated locale $savedLocaleCode is somehow not supported, defaulting to English');
          await _setDefaultLocaleAndClearPreference();
        }
      } else {
        debugPrint('No valid saved locale found, using default English');
        _locale = const Locale('en');
      }
    } catch (e) {
      debugPrint('Error loading locale preference: $e');
      await _setDefaultLocaleAndClearPreference();
    }
  }

  /// Helper method to set default locale and clear invalid preference
  Future<void> _setDefaultLocaleAndClearPreference() async {
    _locale = const Locale('en');
    try {
      await LocalePreferences.clearLocale();
      debugPrint('Cleared invalid locale preference');
    } catch (clearError) {
      debugPrint('Error clearing invalid locale preference: $clearError');
    }
  }

  /// Toggle between English and Arabic
  Future<void> toggleLocale() async {
    final newLocale = _locale.languageCode == 'en' 
        ? const Locale('ar') 
        : const Locale('en');
    
    try {
      await setLocale(newLocale);
    } catch (e) {
      debugPrint('Error toggling locale: $e');
      // Don't re-throw here as this is a user-facing action
      // The UI should handle the error gracefully
      rethrow;
    }
  }

  /// Check if current locale is RTL
  bool get isRTL => _locale.languageCode == 'ar';
}