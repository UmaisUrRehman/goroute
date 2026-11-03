import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

/// Global ThemeMode notifier to switch dynamically between light and dark
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.light);

/// Custom ColorScheme (Light)
const ColorScheme customLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF1E88E5), // Indigo Blue
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFBBDEFB),
  onPrimaryContainer: Color(0xFF0D47A1),
  secondary: Color(0xFF00897B), // Teal Accent
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFB2DFDB),
  onSecondaryContainer: Color(0xFF004D40),
  tertiary: Color(0xFFF57C00), // Amber Accent
  onTertiary: Colors.white,
  surface: Color(0xFFF8FAFD),
  onSurface: Color(0xFF191C1E),
  error: Color(0xFFBA1A1A),
  onError: Colors.white,
);

/// Custom ColorScheme (Dark)
const ColorScheme customDarkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF90CAF9),
  onPrimary: Color(0xFF003258),
  primaryContainer: Color(0xFF00497D),
  onPrimaryContainer: Color(0xFFD1E4FF),
  secondary: Color(0xFF80CBC4),
  onSecondary: Color(0xFF003731),
  secondaryContainer: Color(0xFF004F46),
  onSecondaryContainer: Color(0xFFA7F0E6),
  tertiary: Color(0xFFFFB74D),
  onTertiary: Color(0xFF4A2800),
  surface: Color(0xFF121417),
  onSurface: Color(0xFFE2E2E6),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
);

/// Custom TextTheme with Material Design 3 scale
const TextTheme customTextTheme = TextTheme(
  displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5),
  titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 0),
  titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: 0.5),
  bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, letterSpacing: 0.25),
  labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.25),
);

/// Router Configuration with 4+ named routes, nested ShellRoute, and deep link route
final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    // ShellRoute for nested navigation flow (Bottom Navigation Bar)
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/explore',
          name: 'explore',
          builder: (context, state) => const ExploreScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    // Route 4: Item Details (Supports deep links like /item/42)
    GoRoute(
      path: '/item/:id',
      name: 'item-details',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'unknown';
        final extraQuery = state.uri.queryParameters['name'] ?? 'Custom Item $id';
        return ItemDetailScreen(itemId: id, itemName: extraQuery);
      },
    ),
    // Extra Route 5: Nested Detail inside Settings / About
    GoRoute(
      path: '/about',
      name: 'about',
      builder: (context, state) => const AboutScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentThemeMode, _) {
        return MaterialApp.router(
          title: 'GoRouter M3 Demo',
          debugShowCheckedModeBanner: false,
          themeMode: currentThemeMode,
          // Material 3 Light Theme with Custom ColorScheme & TextTheme
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: customLightColorScheme,
            textTheme: customTextTheme,
            appBarTheme: AppBarTheme(
              backgroundColor: customLightColorScheme.surface,
              foregroundColor: customLightColorScheme.onSurface,
              elevation: 0,
              centerTitle: true,
            ),
            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          // Material 3 Dark Theme with Custom ColorScheme & TextTheme
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: customDarkColorScheme,
            textTheme: customTextTheme,
            appBarTheme: AppBarTheme(
              backgroundColor: customDarkColorScheme.surface,
              foregroundColor: customDarkColorScheme.onSurface,
              elevation: 0,
              centerTitle: true,
            ),
            cardTheme: CardThemeData(
              color: const Color(0xFF1E2228),
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          routerConfig: appRouter,
        );
      },
    );
  }
}

/// Nested Navigation Shell with NavigationBar
class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/explore')) return 1;
    if (location.startsWith('/settings')) return 2;
    return 0; // '/home'
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed('home');
        break;
      case 1:
        context.goNamed('explore');
        break;
      case 2:
        context.goNamed('settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (idx) => _onItemTapped(idx, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

/// Screen 1: Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('GoRouter Hub'),
        actions: [
          IconButton(
            icon: Icon(
              themeModeNotifier.value == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeModeNotifier.value = themeModeNotifier.value == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;
            },
            tooltip: 'Toggle Theme',
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(Icons.rocket_launch, size: 48, color: theme.colorScheme.onPrimaryContainer),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Material 3 & GoRouter',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Custom color scheme, typography & nested shell routing.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Featured Items (Deep Link Demos)', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final id = (index + 101).toString();
                final title = 'Product Package #$id';
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.secondaryContainer,
                      foregroundColor: theme.colorScheme.onSecondaryContainer,
                      child: Text('${index + 1}'),
                    ),
                    title: Text(title, style: theme.textTheme.titleMedium),
                    subtitle: Text('Deep link target: /item/$id'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      context.pushNamed(
                        'item-details',
                        pathParameters: {'id': id},
                        queryParameters: {'name': title},
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Screen 2: Explore Screen
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Topics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Nested Flow Demonstration', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'This tab is managed smoothly by ShellRoute while preserving the bottom navigation bar.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Icon(Icons.link, color: theme.colorScheme.primary),
              title: const Text('Open Direct Deep Link (/item/999)'),
              subtitle: const Text('Simulates opening external deep link URL'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push('/item/999?name=Special+DeepLink+Offer');
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.palette_outlined, color: theme.colorScheme.secondary),
              title: const Text('Design Palette Showcase'),
              subtitle: const Text('Primary, Secondary & Tertiary accents'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Color Scheme and Text Theme are active!'),
                    backgroundColor: theme.colorScheme.secondary,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Screen 3: Settings Screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = themeModeNotifier.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              secondary: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Dark Mode'),
              subtitle: Text(isDark ? 'Dark theme enabled' : 'Light theme enabled'),
              value: isDark,
              onChanged: (val) {
                themeModeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.info_outline, color: theme.colorScheme.primary),
              title: const Text('About Application'),
              subtitle: const Text('View architecture and route specifications'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed('about'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Screen 4: Deep Link / Item Details Screen
class ItemDetailScreen extends StatelessWidget {
  final String itemId;
  final String itemName;

  const ItemDetailScreen({
    super.key,
    required this.itemId,
    required this.itemName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Item $itemId'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.qr_code_2,
                      size: 64,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    itemName,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 24,
                      color: theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Deep Link URI: /item/$itemId',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'This screen was resolved by GoRouter with path parameters (:id = $itemId) and handles direct external URIs.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Screen 5: About App Screen
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('About & Specs')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Project Specifications', style: theme.textTheme.titleLarge),
                  const Divider(height: 24),
                  const Text('• 5 Named Routes: home, explore, settings, item-details, about'),
                  const SizedBox(height: 6),
                  const Text('• Nested ShellRoute with persistent bottom NavigationBar'),
                  const SizedBox(height: 6),
                  const Text('• Custom Light & Dark ColorScheme + Custom TextTheme'),
                  const SizedBox(height: 6),
                  const Text('• Deep link route: /item/:id (?name=...)'),
                  const SizedBox(height: 6),
                  const Text('• Material Design 3 enabled across the app'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
