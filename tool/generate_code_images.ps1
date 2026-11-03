Add-Type -AssemblyName System.Drawing

function Create-CodeImage {
    param (
        [string]$Title,
        [string[]]$CodeLines,
        [string]$OutputPath
    )

    $width = 920
    $lineHeight = 24
    $headerHeight = 44
    $padding = 24
    $height = $headerHeight + ($CodeLines.Length * $lineHeight) + ($padding * 2)

    $bmp = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    # Outer background
    $outerBrush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#0D1117"))
    $g.FillRectangle($outerBrush, 0, 0, $width, $height)

    # Card background
    $cardBrush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#161B22"))
    $cardPen = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml("#30363D"), 1)
    $cardW = [int]($width - 24)
    $cardH = [int]($height - 24)
    $g.FillRectangle($cardBrush, 12, 12, $cardW, $cardH)
    $g.DrawRectangle($cardPen, 12, 12, $cardW, $cardH)

    # Window title bar
    $headerBrush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#21262D"))
    $g.FillRectangle($headerBrush, 12, 12, $width - 24, $headerHeight)
    $g.DrawLine($cardPen, 12, 12 + $headerHeight, $width - 12, 12 + $headerHeight)

    # Window dots
    $dotRed = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#FF5F56"))
    $dotYellow = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#FFBD2E"))
    $dotGreen = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#27C93F"))
    $g.FillEllipse($dotRed, 26, 26, 12, 12)
    $g.FillEllipse($dotYellow, 46, 26, 12, 12)
    $g.FillEllipse($dotGreen, 66, 26, 12, 12)

    # Title text
    $titleFont = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $titleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#8B949E"))
    $g.DrawString($Title, $titleFont, $titleBrush, 96, 23)

    # Code text
    $font = New-Object System.Drawing.Font("Consolas", 11, [System.Drawing.FontStyle]::Regular)
    $commentBrush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#8B949E"))
    $keywordBrush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#FF7B72"))
    $stringBrush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#A5D6FF"))
    $typeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#79C0FF"))
    $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#E6EDF3"))

    $y = 12 + $headerHeight + $padding - 6

    foreach ($line in $CodeLines) {
        $brush = $textBrush
        if ($line.Trim().StartsWith("//") -or $line.Trim().StartsWith("///")) {
            $brush = $commentBrush
        } elseif ($line.Contains("class ") -or $line.Contains("final ") -or $line.Contains("const ")) {
            $brush = $keywordBrush
        } elseif ($line.Contains("GoRoute(") -or $line.Contains("ShellRoute(")) {
            $brush = $typeBrush
        }
        $g.DrawString($line, $font, $brush, 32, $y)
        $y += $lineHeight
    }

    # Clean up and save
    $g.Dispose()
    $bmp.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

$themeLines = @(
    "/// 1. Material Design 3 Custom ColorSchemes",
    "const ColorScheme customLightColorScheme = ColorScheme(",
    "  brightness: Brightness.light,",
    "  primary: Color(0xFF1E88E5),        // Indigo Blue Accent",
    "  onPrimary: Colors.white,",
    "  primaryContainer: Color(0xFFBBDEFB),",
    "  secondary: Color(0xFF00897B),      // Teal Supporting Accent",
    "  surface: Color(0xFFF8FAFD),        // M3 Elevated Neutral Surface",
    "  onSurface: Color(0xFF191C1E),",
    ");",
    "",
    "/// 2. Custom M3 TextTheme Specification",
    "const TextTheme customTextTheme = TextTheme(",
    "  displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),",
    "  titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),",
    "  bodyLarge: TextStyle(fontSize: 16, letterSpacing: 0.5),",
    "  bodyMedium: TextStyle(fontSize: 14, letterSpacing: 0.25),",
    ");"
)

$routerLines = @(
    "/// GoRouter Definition: 5 Named Routes, Nested Shell, & Deep Link",
    "final GoRouter appRouter = GoRouter(",
    "  initialLocation: '/home',",
    "  routes: [",
    "    // Nested Navigation Flow via ShellRoute",
    "    ShellRoute(",
    "      builder: (context, state, child) => ScaffoldWithNavBar(child: child),",
    "      routes: [",
    "        GoRoute(path: '/home', name: 'home', builder: (_, __) => const HomeScreen()),",
    "        GoRoute(path: '/explore', name: 'explore', builder: (_, __) => const ExploreScreen()),",
    "        GoRoute(path: '/settings', name: 'settings', builder: (_, __) => const SettingsScreen()),",
    "      ],",
    "    ),",
    "    // Deep Link Route with Path & Query Parameter parsing",
    "    GoRoute(",
    "      path: '/item/:id',",
    "      name: 'item-details',",
    "      builder: (context, state) {",
    "        final id = state.pathParameters['id'] ?? 'unknown';",
    "        final name = state.uri.queryParameters['name'] ?? 'Product';",
    "        return ItemDetailScreen(itemId: id, itemName: name);",
    "      },",
    "    ),",
    "    // Route 5: About Specifications",
    "    GoRoute(path: '/about', name: 'about', builder: (_, __) => const AboutScreen()),",
    "  ],",
    ");"
)

Create-CodeImage -Title 'lib/main.dart - Material 3 Custom Theme and Typography' -CodeLines $themeLines -OutputPath 'D:\Work\android_projects\gorouter\doc_images\code_snapshot_theme.png'
Create-CodeImage -Title 'lib/main.dart - GoRouter Routes and Nested ShellRoute' -CodeLines $routerLines -OutputPath 'D:\Work\android_projects\gorouter\doc_images\code_snapshot_router.png'

# Also copy to artifact directory
$artifactDir = "C:\Users\Umais\.gemini\antigravity\brain\4d21189b-211f-4ae5-af9d-cfbaa7f3edda\doc_images"
if (!(Test-Path $artifactDir)) { New-Item -ItemType Directory -Path $artifactDir -Force }
Copy-Item "D:\Work\android_projects\gorouter\doc_images\code_snapshot_theme.png" -Destination "$artifactDir\code_snapshot_theme.png" -Force
Copy-Item "D:\Work\android_projects\gorouter\doc_images\code_snapshot_router.png" -Destination "$artifactDir\code_snapshot_router.png" -Force
