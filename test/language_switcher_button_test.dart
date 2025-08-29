import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:insight/widgets/language_switcher_button.dart';
import 'package:insight/services/locale_provider.dart';

void main() {
  group('LanguageSwitcherButton', () {
    testWidgets('displays Arabic when current locale is English', (WidgetTester tester) async {
      final localeProvider = LocaleProvider();
      
      await tester.pumpWidget(
        ChangeNotifierProvider<LocaleProvider>.value(
          value: localeProvider,
          child: const MaterialApp(
            home: Scaffold(
              body: LanguageSwitcherButton(),
            ),
          ),
        ),
      );

      // Should display Arabic text when current locale is English (default)
      expect(find.text('العربية'), findsOneWidget);
      expect(find.text('English'), findsNothing);
    });

    testWidgets('displays English when current locale is Arabic', (WidgetTester tester) async {
      final localeProvider = LocaleProvider();
      // Set locale to Arabic first
      await localeProvider.setLocale(const Locale('ar'));
      
      await tester.pumpWidget(
        ChangeNotifierProvider<LocaleProvider>.value(
          value: localeProvider,
          child: const MaterialApp(
            home: Scaffold(
              body: LanguageSwitcherButton(),
            ),
          ),
        ),
      );

      // Should display English text when current locale is Arabic
      expect(find.text('English'), findsOneWidget);
      expect(find.text('العربية'), findsNothing);
    });

    testWidgets('toggles locale when tapped', (WidgetTester tester) async {
      final localeProvider = LocaleProvider();
      
      await tester.pumpWidget(
        ChangeNotifierProvider<LocaleProvider>.value(
          value: localeProvider,
          child: const MaterialApp(
            home: Scaffold(
              body: LanguageSwitcherButton(),
            ),
          ),
        ),
      );

      // Initially should be English locale
      expect(localeProvider.locale.languageCode, 'en');
      expect(find.text('العربية'), findsOneWidget);

      // Tap the button
      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();

      // Should now be Arabic locale
      expect(localeProvider.locale.languageCode, 'ar');
      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('has language icon', (WidgetTester tester) async {
      final localeProvider = LocaleProvider();
      
      await tester.pumpWidget(
        ChangeNotifierProvider<LocaleProvider>.value(
          value: localeProvider,
          child: const MaterialApp(
            home: Scaffold(
              body: LanguageSwitcherButton(),
            ),
          ),
        ),
      );

      // Should have language icon
      expect(find.byIcon(Icons.language), findsOneWidget);
    });

    testWidgets('has proper styling', (WidgetTester tester) async {
      final localeProvider = LocaleProvider();
      
      await tester.pumpWidget(
        ChangeNotifierProvider<LocaleProvider>.value(
          value: localeProvider,
          child: const MaterialApp(
            home: Scaffold(
              body: LanguageSwitcherButton(),
            ),
          ),
        ),
      );

      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      final buttonStyle = button.style!;
      
      // Check button styling
      expect(buttonStyle.shape?.resolve({}), isA<RoundedRectangleBorder>());
      expect(buttonStyle.side?.resolve({})?.color, const Color(0xFF209A9F));
      expect(buttonStyle.foregroundColor?.resolve({}), const Color(0xFF209A9F));
    });
  });
}