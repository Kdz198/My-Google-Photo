import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized backend configuration.
///
/// The backend base URL is read from the `.env` file at the project root
/// (frontend/.env). Edit the `BASE_URL` value there to switch between your
/// local backend and the hosted one — no code changes needed.
class AppConfig {
  AppConfig._();

  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://api-photo.kdz.asia';
}
