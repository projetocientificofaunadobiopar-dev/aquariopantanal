class SupabaseConfig {
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://SEU-PROJETO.supabase.co',
  );
  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'SUA-ANON-KEY-AQUI',
  );
  static const String bucket = 'especies-img';
}
