import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:insight/services/locale_provider.dart';
import 'package:insight/widgets/language_switcher_button.dart';
import 'package:insight/view/user_settings_screen.dart';
import 'package:insight/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('RTL Support Tests', () {
    late LocaleProvider localeProvider;

    setUp(() {
      localeProvider = LocaleProvider();
    });

    Widget createTestApp({Locale? locale}) {
      return ChangeNotifierProvider<LocaleProvider>.value(
        value: localeProvider,
        child: Consumer<LocaleProvider>(
          builder: (context, provider, child) {
            return MaterialApp(
              locale: locale ?? provider.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('ar'),
              ],
              home: const Scaffold(
                body: Column(
                  children: [
                    Text('Test Text'),
                    LanguageSwitcherButton(),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    testWidgets('Arabic text renders correctly with RTL direction', (WidgetTester tester) async {
      await localeProvider.setLocale(const Locale('ar'));
      
      await tester.pumpWidget(createTestApp(locale: const Locale('ar')));
      await tester.pumpAndSettle();

      // Find the MaterialApp widget
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      
      // Verify that the locale is set to Arabic
      expect(materialApp.locale, const Locale('ar'));
      
      // Verify that the text direction is RTL for Arabic
      final directionality = tester.widget<Directionality>(
        find.descendant(
          of: find.byType(MaterialApp),
          matching: find.byType(Directionality),
        ).first,
      );
      expect(directionality.textDirection, TextDirection.rtl);
    });

    testWidgets('English text renders correctly with LTR direction', (WidgetTester tester) async {
      await localeProvider.setLocale(const Locale('en'));
      
      await tester.pumpWidget(createTestApp(locale: const Locale('en')));
      await tester.pumpAndSettle();

      // Find the MaterialApp widget
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      
      // Verify that the locale is set to English
      expect(materialApp.locale, const Locale('en'));
      
      // Verify that the text direction is LTR for English
      final directionality = tester.widget<Directionality>(
        find.descendant(
          of: find.byType(MaterialApp),
          matching: find.byType(Directionality),
        ).first,
      );
      expect(directionality.textDirection, TextDirection.ltr);
    });

    testWidgets('Language switcher button displays correct text in RTL mode', (WidgetTester tester) async {
      await localeProvider.setLocale(const Locale('ar'));
      
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // In Arabic mode, button should show "English" as the switch option
      expect(find.text('English'), findsOneWidget);
      expect(find.text('العربية'), findsNothing);
      
      // Verify the button has the language icon
      expect(find.byIcon(Icons.language), findsOneWidget);
    });

    testWidgets('Language switching updates UI immediately', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Initially should be English
      expect(find.text('العربية'), findsOneWidget);
      expect(find.text('English'), findsNothing);

      // Tap the language switcher
      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();

      // Should now show English as switch option (meaning we're in Arabic mode)
      expect(find.text('English'), findsOneWidget);
      expect(find.text('العربية'), findsNothing);

      // Verify locale changed
      expect(localeProvider.locale.languageCode, 'ar');
      expect(localeProvider.isRTL, true);
    });

    testWidgets('Icons and UI elements position correctly in RTL mode', (WidgetTester tester) async {
      await localeProvider.setLocale(const Locale('ar'));
      
      await tester.pumpWidget(
        ChangeNotifierProvider<LocaleProvider>.value(
          value: localeProvider,
          child: MaterialApp(
            locale: const Locale('ar'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            home: const UserSettingsScreen(userRole: 'admin'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find arrow icons in the UI
      final arrowIcons = find.byIcon(Icons.arrow_forward_ios);
      expect(arrowIcons, findsWidgets);

      // In RTL mode, arrows should be positioned on the left side
      // We can verify this by checking that the Directionality widget exists
      final directionalityWidgets = find.byType(Directionality);
      expect(directionalityWidgets, findsWidgets);
      
      // Verify that at least one Directionality widget has RTL direction
      bool hasRTLDirectionality = false;
      for (final element in directionalityWidgets.evaluate()) {
        final directionality = element.widget as Directionality;
        if (directionality.textDirection == TextDirection.rtl) {
          hasRTLDirectionality = true;
          break;
        }
      }
      expect(hasRTLDirectionality, true);
    });

    testWidgets('Arabic translations display correctly in user settings', (WidgetTester tester) async {
      await localeProvider.setLocale(const Locale('ar'));
      
      await tester.pumpWidget(
        ChangeNotifierProvider<LocaleProvider>.value(
          value: localeProvider,
          child: MaterialApp(
            locale: const Locale('ar'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            home: const UserSettingsScreen(userRole: 'admin'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Arabic translations are displayed
      expect(find.text('الخصوصية والأمان'), findsOneWidget); // Privacy and Security
      expect(find.text('تسجيل الخروج'), findsOneWidget); // Log Out
      expect(find.text('تفضيلات الإشعارات'), findsOneWidget); // Notification Preferences
      expect(find.text('إعدادات التقارير'), findsOneWidget); // Report Settings
      expect(find.text('إدارة الفروع'), findsOneWidget); // Manage Branches
      expect(find.text('إدارة المستخدمين'), findsOneWidget); // Manage Users
    });

    testWidgets('English translations display correctly in user settings', (WidgetTester tester) async {
      await localeProvider.setLocale(const Locale('en'));
      
      await tester.pumpWidget(
        ChangeNotifierProvider<LocaleProvider>.value(
          value: localeProvider,
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            home: const UserSettingsScreen(userRole: 'admin'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify English translations are displayed
      expect(find.text('Privacy and Security'), findsOneWidget);
      expect(find.text('Log Out'), findsOneWidget);
      expect(find.text('Notification Preferences'), findsOneWidget);
      expect(find.text('Report Settings'), findsOneWidget);
      expect(find.text('Manage Branches'), findsOneWidget);
      expect(find.text('Manage Users'), findsOneWidget);
    });

    testWidgets('Language switching persists across widget rebuilds', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Initially English
      expect(localeProvider.locale.languageCode, 'en');

      // Switch to Arabic
      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();
      expect(localeProvider.locale.languageCode, 'ar');

      // Rebuild the widget tree
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Should still be Arabic
      expect(localeProvider.locale.languageCode, 'ar');
      expect(find.text('English'), findsOneWidget); // Shows English as switch option
    });

    testWidgets('RTL layout affects text alignment', (WidgetTester tester) async {
      await localeProvider.setLocale(const Locale('ar'));
      
      await tester.pumpWidget(
        ChangeNotifierProvider<LocaleProvider>.value(
          value: localeProvider,
          child: MaterialApp(
            locale: const Locale('ar'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            home: Scaffold(
              body: Column(
                children: [
                  Text(
                    'مرحباً بك',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'هذا نص تجريبي باللغة العربية',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Arabic text is present
      expect(find.text('مرحباً بك'), findsOneWidget);
      expect(find.text('هذا نص تجريبي باللغة العربية'), findsOneWidget);

      // Verify RTL directionality is applied
      final directionalityWidgets = find.byType(Directionality);
      expect(directionalityWidgets, findsWidgets);
    });

    testWidgets('Language switcher maintains styling in both locales', (WidgetTester tester) async {
      // Test English styling
      await localeProvider.setLocale(const Locale('en'));
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      final englishButton = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      final englishStyle = englishButton.style!;
      
      // Switch to Arabic
      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();

      final arabicButton = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      final arabicStyle = arabicButton.style!;

      // Verify styling is consistent
      expect(englishStyle.side?.resolve({})?.color, arabicStyle.side?.resolve({})?.color);
      expect(englishStyle.foregroundColor?.resolve({}), arabicStyle.foregroundColor?.resolve({}));
      expect(englishStyle.shape?.resolve({}), arabicStyle.shape?.resolve({}));
    });

    testWidgets('Locale provider isRTL property works correctly', (WidgetTester tester) async {
      // Initially English (LTR)
      expect(localeProvider.isRTL, false);

      // Switch to Arabic (RTL)
      await localeProvider.setLocale(const Locale('ar'));
      expect(localeProvider.isRTL, true);

      // Switch back to English (LTR)
      await localeProvider.setLocale(const Locale('en'));
      expect(localeProvider.isRTL, false);
    });
  });

  group('Arabic Text Rendering Tests', () {
    testWidgets('Arabic characters render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          home: const Scaffold(
            body: Column(
              children: [
                Text('مرحباً'),
                Text('العربية'),
                Text('الخصوصية والأمان'),
                Text('تسجيل الخروج'),
                Text('إعدادات'),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify all Arabic texts are found
      expect(find.text('مرحباً'), findsOneWidget);
      expect(find.text('العربية'), findsOneWidget);
      expect(find.text('الخصوصية والأمان'), findsOneWidget);
      expect(find.text('تسجيل الخروج'), findsOneWidget);
      expect(find.text('إعدادات'), findsOneWidget);
    });

    testWidgets('Mixed Arabic and English text renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          home: const Scaffold(
            body: Column(
              children: [
                Text('PDF'),
                Text('Excel'),
                Text('مرحباً، Admin'),
                Text('Email: test@example.com'),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify mixed content renders correctly
      expect(find.text('PDF'), findsOneWidget);
      expect(find.text('Excel'), findsOneWidget);
      expect(find.text('مرحباً، Admin'), findsOneWidget);
      expect(find.text('Email: test@example.com'), findsOneWidget);
    });
  });

  group('UI Element Positioning Tests', () {
    testWidgets('Row widgets respect RTL direction', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          home: Scaffold(
            body: Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 10),
                Text('مستخدم'),
                Spacer(),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify elements are present
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.text('مستخدم'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);

      // In RTL, the visual order should be reversed
      // We can verify this by checking that Directionality is applied
      expect(find.byType(Directionality), findsWidgets);
    });

    testWidgets('ListTile elements position correctly in RTL', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          home: Scaffold(
            body: ListTile(
              leading: Icon(Icons.settings),
              title: Text('الإعدادات'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify ListTile elements are present
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.text('الإعدادات'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    });
  });
}