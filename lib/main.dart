import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'view/splash_screen.dart';
import 'services/locale_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = LocaleProvider();
        // Initialize locale provider with error handling
        provider.initialize().catchError((error) {
          debugPrint('Error initializing locale provider: $error');
          // Provider will default to English if initialization fails
        });
        return provider;
      },
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'Smart Insight',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF4A90A4),
              ),
              useMaterial3: true,
              fontFamily: 'Inter',
            ),
            // Internationalization configuration with error handling
            locale: localeProvider.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            // Fallback locale in case of errors
            localeResolutionCallback: (locale, supportedLocales) {
              try {
                // Check if the requested locale is supported
                if (locale != null) {
                  for (final supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale.languageCode) {
                      return supportedLocale;
                    }
                  }
                }
                // Fallback to English if no match found
                debugPrint(
                  'Locale resolution fallback: using English for locale $locale',
                );
                return const Locale('en');
              } catch (e) {
                debugPrint('Error in locale resolution: $e');
                return const Locale('en');
              }
            },
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
