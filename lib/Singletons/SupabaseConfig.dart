import 'package:supabase_flutter/supabase_flutter.dart';

/// Project URL and anon (publishable) key for the password-manager Supabase
/// project. The anon key is safe to ship in client code — every table it can
/// touch is protected by Row Level Security, so it can only ever read or
/// write data belonging to the currently authenticated user.
class SupabaseConfig {
  static const String url = 'https://zpijutmvfazrsgocmvtx.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpwaWp1dG12ZmF6cnNnb2NtdnR4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODc5MTQwMjUsImV4cCI6MjEwMzQ5MDAyNX0.701r8iYms1pbmy5ZxliQ41U_Wpn06O_u_hfdWn_XFn0';
}

SupabaseClient get supabase => Supabase.instance.client;
