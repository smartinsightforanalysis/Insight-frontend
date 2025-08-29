import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalePreferences {
  static const String _localeKey = 'selected_locale';
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(milliseconds: 100);

  /// Save locale preference to SharedPreferences with retry mechanism
  static Future<void> saveLocale(String languageCode) async {
    if (languageCode.isEmpty) {
      throw ArgumentError('Language code cannot be empty');
    }

    // Validate language code format
    if (languageCode.length < 2 || languageCode.length > 5) {
      throw ArgumentError('Invalid language code format: $languageCode');
    }

    Exception? lastException;
    
    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final success = await prefs.setString(_localeKey, languageCode);
        
        if (!success) {
          throw Exception('SharedPreferences.setString returned false');
        }
        
        // Verify the save was successful
        final savedValue = prefs.getString(_localeKey);
        if (savedValue != languageCode) {
          throw Exception('Verification failed: saved value "$savedValue" does not match expected "$languageCode"');
        }
        
        debugPrint('Successfully saved locale preference: $languageCode (attempt $attempt)');
        return;
      } catch (e) {
        lastException = Exception('Failed to save locale preference (attempt $attempt): $e');
        debugPrint('Error saving locale preference (attempt $attempt): $e');
        
        if (attempt < _maxRetries) {
          debugPrint('Retrying in ${_retryDelay.inMilliseconds}ms...');
          await Future.delayed(_retryDelay);
        }
      }
    }
    
    throw lastException ?? Exception('Failed to save locale preference after $_maxRetries attempts');
  }

  /// Get saved locale from SharedPreferences with retry mechanism
  static Future<String?> getSavedLocale() async {
    Exception? lastException;
    
    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final savedLocale = prefs.getString(_localeKey);
        
        // Validate the retrieved value
        if (savedLocale != null && savedLocale.isNotEmpty) {
          if (savedLocale.length < 2 || savedLocale.length > 5) {
            debugPrint('Invalid saved locale format: $savedLocale, clearing preference');
            await _clearLocaleInternal(prefs);
            return null;
          }
        }
        
        debugPrint('Successfully loaded locale preference: $savedLocale (attempt $attempt)');
        return savedLocale;
      } catch (e) {
        lastException = Exception('Failed to load locale preference (attempt $attempt): $e');
        debugPrint('Error loading locale preference (attempt $attempt): $e');
        
        if (attempt < _maxRetries) {
          debugPrint('Retrying in ${_retryDelay.inMilliseconds}ms...');
          await Future.delayed(_retryDelay);
        }
      }
    }
    
    debugPrint('Failed to load locale preference after $_maxRetries attempts: $lastException');
    return null; // Return null instead of throwing to allow graceful fallback
  }

  /// Clear saved locale preference with retry mechanism
  static Future<void> clearLocale() async {
    Exception? lastException;
    
    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await _clearLocaleInternal(prefs);
        debugPrint('Successfully cleared locale preference (attempt $attempt)');
        return;
      } catch (e) {
        lastException = Exception('Failed to clear locale preference (attempt $attempt): $e');
        debugPrint('Error clearing locale preference (attempt $attempt): $e');
        
        if (attempt < _maxRetries) {
          debugPrint('Retrying in ${_retryDelay.inMilliseconds}ms...');
          await Future.delayed(_retryDelay);
        }
      }
    }
    
    throw lastException ?? Exception('Failed to clear locale preference after $_maxRetries attempts');
  }

  /// Internal method to clear locale preference
  static Future<void> _clearLocaleInternal(SharedPreferences prefs) async {
    final success = await prefs.remove(_localeKey);
    if (!success) {
      throw Exception('SharedPreferences.remove returned false');
    }
    
    // Verify the removal was successful
    if (prefs.containsKey(_localeKey)) {
      throw Exception('Verification failed: key still exists after removal');
    }
  }

  /// Check if locale preference exists with error handling
  static Future<bool> hasLocalePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasKey = prefs.containsKey(_localeKey);
      
      // If key exists, validate the value
      if (hasKey) {
        final value = prefs.getString(_localeKey);
        if (value == null || value.isEmpty || value.length < 2 || value.length > 5) {
          debugPrint('Invalid locale preference found, clearing it');
          await _clearLocaleInternal(prefs);
          return false;
        }
      }
      
      return hasKey;
    } catch (e) {
      debugPrint('Error checking locale preference existence: $e');
      return false;
    }
  }

  /// Get locale preference with validation
  static Future<String?> getValidatedLocale() async {
    try {
      final locale = await getSavedLocale();
      if (locale == null) return null;
      
      // Additional validation
      final supportedLocales = ['en', 'ar'];
      if (!supportedLocales.contains(locale)) {
        debugPrint('Unsupported locale found in preferences: $locale, clearing it');
        await clearLocale();
        return null;
      }
      
      return locale;
    } catch (e) {
      debugPrint('Error getting validated locale: $e');
      return null;
    }
  }
}