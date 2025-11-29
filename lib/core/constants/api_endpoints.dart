class ApiEndpoints {
  // Supabase Tables (RLS will handle authorization)
  static const String users = 'users';
  static const String trajets = 'trajets';
  static const String passagers = 'passagers';
  static const String sms_messages = 'sms_messages';
  static const String covoiturages = 'covoiturages';
  static const String matching_results = 'matching_results';
  static const String paiements = 'paiements';
  static const String alertes = 'alertes';

  // Realtime channels
  static const String realtimeSMS = 'sms_realtime';
  static const String realtimeTrajets = 'trajets_realtime';
  static const String realtimeAlertes = 'alertes_realtime';

  // Functions (Supabase Edge Functions)
  static const String parseWithLLM = 'parse_sms_with_llm';
  static const String sendSMS = 'send_sms_message';
  static const String createMatchingSuggestions = 'create_matching_suggestions';
  static const String generateReport = 'generate_report';
  static const String calculateCommissions = 'calculate_commissions';
}
