import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/locale_provider.dart';

class LanguageSwitcherButton extends StatelessWidget {
  const LanguageSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        // Show the non-selected language as the switch option
        final isCurrentlyEnglish = localeProvider.locale.languageCode == 'en';
        final switchToLanguage = isCurrentlyEnglish ? 'العربية' : 'English';
        
        return OutlinedButton.icon(
          onPressed: () async {
            try {
              await localeProvider.toggleLocale();
            } catch (e) {
              // Handle locale switching errors gracefully
              debugPrint('Error switching language: $e');
              
              // Show a user-friendly error message
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isCurrentlyEnglish 
                        ? 'Failed to switch to Arabic. Please try again.'
                        : 'فشل في التبديل إلى الإنجليزية. يرجى المحاولة مرة أخرى.',
                    ),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            }
          },
          icon: const Icon(
            Icons.language,
            size: 18,
          ),
          label: Text(
            switchToLanguage,
            style: const TextStyle(
              color: Color(0xFF209A9F),
              fontWeight: FontWeight.bold,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            minimumSize: const Size(0, 40), // allow button to shrink
            side: const BorderSide(color: Color(0xFF209A9F), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            foregroundColor: const Color(0xFF209A9F),
          ),
        );
      },
    );
  }
}