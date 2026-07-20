import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/photo_gallery_screen.dart';

void main() {
  runApp(const MyGooglePhotoApp());
}

class MyGooglePhotoApp extends StatelessWidget {
  const MyGooglePhotoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Google Photo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF18181B), // Zinc 900
        scaffoldBackgroundColor: const Color(0xFFFAFAFA), // Zinc 50
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF18181B),
          primary: const Color(0xFF18181B),
          secondary: const Color(0xFF27272A), // Zinc 800
          background: const Color(0xFFFAFAFA),
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: const Color(0xFF09090B),
          displayColor: const Color(0xFF09090B),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAFAFA),
          foregroundColor: Color(0xFF18181B),
          elevation: 0,
        ),
      ),
      home: const PhotoGalleryScreen(),
    );
  }
}
