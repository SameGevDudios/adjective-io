class ApiConstants {
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static const String register = '/api/v1/register';
  static const String login = '/api/v1/login';
  static const String refresh = '/api/v1/refresh';
  static const String forgotPassword = '/api/v1/forgotPassword';
  static const String resetPassword = '/api/v1/resetPassword';

  static const String manage2fa = '/api/v1/manage/2fa';
  static const String manageInfo = '/api/v1/manage/info';

  static const String preferences = '/api/v1/preferences';
  static String incrementPreference(String id) => '/api/v1/preferences/$id/increment';
  static String decrementPreference(String id) => '/api/v1/preferences/$id/decrement';

  static const String prefix = '/api/v1/prefixes';
  static const String profileSync = '/api/v1/profile/update';
}
