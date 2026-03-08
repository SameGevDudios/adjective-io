class EnvConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://localhost:7028',
  );

  static const bool isDebug = bool.fromEnvironment('DEBUG', defaultValue: true);

  static void validate() {
    if (baseUrl.isEmpty) {
      throw Exception(
        'BASE_URL is not defined. '
        'Make sure you run the app with a flag --dart-define-from-file=env/development.json',
      );
    }
  }
}
