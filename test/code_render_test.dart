import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Widget buildCodeSnippetCard({
  required String title,
  required List<Widget> lines,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            width: 780,
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF30363D)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 20,
                  offset: Offset(0, 8),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Window Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF21262D),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    border: Border(bottom: BorderSide(color: Color(0xFF30363D))),
                  ),
                  child: Row(
                    children: [
                      Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFFFF5F56), shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFFFFBD2E), shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFF27C93F), shape: BoxShape.circle)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF8B949E),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Code Body
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: lines,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget codeLine(List<TextSpan> spans) {
  return RichText(
    text: TextSpan(
      style: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 13.5,
        height: 1.45,
        color: Color(0xFFE6EDF3),
      ),
      children: spans,
    ),
  );
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('Render code snippet snapshots', (WidgetTester tester) async {
    // Snippet 1: Theme & Typography
    final themeSnippet = buildCodeSnippetCard(
      title: 'lib/main.dart — Material 3 Custom Theme & TextTheme',
      lines: [
        codeLine([
          const TextSpan(text: '// 1. Custom Material 3 ColorScheme\n', style: TextStyle(color: Color(0xFF8B949E))),
          const TextSpan(text: 'const ColorScheme ', style: TextStyle(color: Color(0xFFFF7B72))),
          const TextSpan(text: 'customLightColorScheme', style: TextStyle(color: Color(0xFFFFA657))),
          const TextSpan(text: ' = ColorScheme(\n'),
          const TextSpan(text: '  brightness: Brightness.light,\n'),
          const TextSpan(text: '  primary: Color(0xFF1E88E5), ', style: TextStyle(color: Color(0xFF79C0FF))),
          const TextSpan(text: '// Indigo Blue\n', style: TextStyle(color: Color(0xFF8B949E))),
          const TextSpan(text: '  secondary: Color(0xFF00897B), ', style: TextStyle(color: Color(0xFF79C0FF))),
          const TextSpan(text: '// Teal Accent\n', style: TextStyle(color: Color(0xFF8B949E))),
          const TextSpan(text: '  surface: Color(0xFFF8FAFD),\n'),
          const TextSpan(text: ');\n\n'),
          const TextSpan(text: '// 2. Custom M3 TextTheme\n', style: TextStyle(color: Color(0xFF8B949E))),
          const TextSpan(text: 'const TextTheme ', style: TextStyle(color: Color(0xFFFF7B72))),
          const TextSpan(text: 'customTextTheme', style: TextStyle(color: Color(0xFFFFA657))),
          const TextSpan(text: ' = TextTheme(\n'),
          const TextSpan(text: '  displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),\n'),
          const TextSpan(text: '  titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),\n'),
          const TextSpan(text: '  bodyLarge: TextStyle(fontSize: 16, letterSpacing: 0.5),\n'),
          const TextSpan(text: ');'),
        ]),
      ],
    );

    await tester.pumpWidgetBuilder(themeSnippet, surfaceSize: const Size(860, 520));
    await screenMatchesGolden(tester, 'goldens/code_theme_snapshot');

    // Snippet 2: GoRouter ShellRoute & Deep Link
    final routerSnippet = buildCodeSnippetCard(
      title: 'lib/main.dart — GoRouter Routes & Nested ShellRoute',
      lines: [
        codeLine([
          const TextSpan(text: 'final GoRouter ', style: TextStyle(color: Color(0xFFFF7B72))),
          const TextSpan(text: 'appRouter', style: TextStyle(color: Color(0xFFFFA657))),
          const TextSpan(text: ' = GoRouter(\n'),
          const TextSpan(text: '  initialLocation: \'/home\',\n'),
          const TextSpan(text: '  routes: [\n'),
          const TextSpan(text: '    // Nested Navigation Flow (ShellRoute)\n', style: TextStyle(color: Color(0xFF8B949E))),
          const TextSpan(text: '    ShellRoute(\n', style: TextStyle(color: Color(0xFF79C0FF))),
          const TextSpan(text: '      builder: (context, state, child) => ScaffoldWithNavBar(child: child),\n'),
          const TextSpan(text: '      routes: [\n'),
          const TextSpan(text: '        GoRoute(path: \'/home\', name: \'home\', builder: (_, __) => HomeScreen()),\n'),
          const TextSpan(text: '        GoRoute(path: \'/explore\', name: \'explore\', builder: (_, __) => ExploreScreen()),\n'),
          const TextSpan(text: '        GoRoute(path: \'/settings\', name: \'settings\', builder: (_, __) => SettingsScreen()),\n'),
          const TextSpan(text: '      ],\n'),
          const TextSpan(text: '    ),\n'),
          const TextSpan(text: '    // Deep Link Route with Path & Query Parameters\n', style: TextStyle(color: Color(0xFF8B949E))),
          const TextSpan(text: '    GoRoute(\n', style: TextStyle(color: Color(0xFF79C0FF))),
          const TextSpan(text: '      path: \'/item/:id\',\n'),
          const TextSpan(text: '      name: \'item-details\',\n'),
          const TextSpan(text: '      builder: (context, state) => ItemDetailScreen(\n'),
          const TextSpan(text: '        itemId: state.pathParameters[\'id\']!,\n'),
          const TextSpan(text: '        itemName: state.uri.queryParameters[\'name\'] ?? \'Item\',\n'),
          const TextSpan(text: '      ),\n'),
          const TextSpan(text: '    ),\n'),
          const TextSpan(text: '  ],\n);'),
        ]),
      ],
    );

    await tester.pumpWidgetBuilder(routerSnippet, surfaceSize: const Size(860, 640));
    await screenMatchesGolden(tester, 'goldens/code_router_snapshot');
  });
}
