class AppConstants {
  // App Info
  static const String appName = 'MonTrajet Dashboard';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.tokpa.montrajet_dashboard';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 10);

  // Pagination
  static const int pageSize = 10;
  static const int initialPageSize = 20;

  // Date/Time
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm:ss';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm:ss';

  // Trajets
  static const int minPassengersRequired = 10;
  static const int maxCapacity = 30;
  static const int minimumMinutesBeforeDeparture = 10;

  // SMS
  static const int maxSmsLength = 160;
  static const String smsPrefix = 'TOKPA';

  // Currency
  static const String currencyCode = 'XOF';
  static const String currencySymbol = 'F';

  // Commission
  static const double commissionPercentage = 0.25; // 25%
  static const double commissionPerPassenger = 50.0; // 50 XOF

  // Features
  static const bool enableLLMParsing = true;
  static const bool enableRealtime = true;
  static const bool enableSMSGateway = true;
  static const bool enableExport = true;
}
