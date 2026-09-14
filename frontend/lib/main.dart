import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/photo_gallery_screen.dart';

/// App-wide theme mode, toggled from the gallery screen's app bar.
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyGooglePhotoApp());
}

class MyGooglePhotoApp extends StatelessWidget {
  const MyGooglePhotoApp({Key? key}) : super(key: key);

  // Zinc scale, shared between light/dark — dark mode reuses the same tokens
  // inverted, so both themes stay visually consistent with the design system.
  static const _zinc50 = Color(0xFFFAFAFA);
  static const _zinc100 = Color(0xFFF4F4F5);
  static const _zinc800 = Color(0xFF27272A);
  static const _zinc900 = Color(0xFF18181B);
  static const _zinc950 = Color(0xFF09090B);

  static ThemeData _lightTheme(BuildContext context) => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: _zinc900,
        scaffoldBackgroundColor: _zinc50,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _zinc900,
          brightness: Brightness.light,
          primary: _zinc900,
          secondary: _zinc800,
          background: _zinc50,
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: _zinc950,
          displayColor: _zinc950,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: _zinc50,
          foregroundColor: _zinc900,
          elevation: 0,
        ),
      );

  static ThemeData _darkTheme(BuildContext context) => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: _zinc100,
        scaffoldBackgroundColor: _zinc950,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _zinc100,
          brightness: Brightness.dark,
          primary: _zinc100,
          secondary: _zinc800,
          background: _zinc950,
          surface: _zinc900,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: _zinc50,
          displayColor: _zinc50,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: _zinc950,
          foregroundColor: _zinc50,
          elevation: 0,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'My Google Photo',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: _lightTheme(context),
          darkTheme: _darkTheme(context),
          home: const PhotoGalleryScreen(),
        );
      },
    );
  }
}
