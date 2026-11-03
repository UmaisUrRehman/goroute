import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:android_projects/main.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('Capture real text screenshots with golden_toolkit', (WidgetTester tester) async {
    // Step 1: Light Theme Home Screen
    themeModeNotifier.value = ThemeMode.light;
    await tester.pumpWidgetBuilder(const MyApp(), surfaceSize: const Size(400, 800));
    await screenMatchesGolden(tester, 'goldens/01_home_screen_light');

    // Step 2: Dark Theme Home Screen
    themeModeNotifier.value = ThemeMode.dark;
    await tester.pumpAndSettle();
    await screenMatchesGolden(tester, 'goldens/02_home_screen_dark');

    // Step 3: Switch back to light theme and Navigate to Explore Screen
    themeModeNotifier.value = ThemeMode.light;
    await tester.tap(find.byIcon(Icons.explore_outlined));
    await tester.pumpAndSettle();
    await screenMatchesGolden(tester, 'goldens/03_explore_nested_shell');

    // Step 4: Settings Screen
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await screenMatchesGolden(tester, 'goldens/04_settings_screen');

    // Step 5: About Screen
    await tester.tap(find.text('About Application'));
    await tester.pumpAndSettle();
    await screenMatchesGolden(tester, 'goldens/05_about_screen');

    // Step 6: Go back
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Step 7: Deep Link Route /item/999
    appRouter.go('/item/999?name=Special+DeepLink+Offer');
    await tester.pumpAndSettle();
    await screenMatchesGolden(tester, 'goldens/06_deep_link_screen');

    // Step 8: Deep Link in Dark Mode
    themeModeNotifier.value = ThemeMode.dark;
    await tester.pumpAndSettle();
    await screenMatchesGolden(tester, 'goldens/07_deep_link_dark');
  });
}
