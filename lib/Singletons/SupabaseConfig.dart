import 'package:supabase_flutter/supabase_flutter.dart';

/// Project URL and anon (publishable) key for the password-manager Supabase
/// project. The anon key is safe to ship in client code — every table it can
/// touch is protected by Row Level Security, so it can only ever read or
/// write data belonging to the currently authenticated user.
class SupabaseConfig {
  static const String url = 'https://zpijutmvfazrsgocmvtx.supabase.co';
  static const String publishableKey =
      'sb_publishable__jG8aBAP22rqV-nszRNixQ_inNv6MC8';
}

SupabaseClient get supabase => Supabase.instance.client;
