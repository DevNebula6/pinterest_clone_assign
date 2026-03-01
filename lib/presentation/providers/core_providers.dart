import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

export '../../core/network/dio_client.dart' show dioClientProvider;
export '../../core/network/network_info.dart' show networkInfoProvider;

// SharedPreferences provider — must be overridden in ProviderScope before use.
// Override it in main.dart after calling SharedPreferences.getInstance().
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in ProviderScope. '
    'Call SharedPreferences.getInstance() in main() and pass it via overrides.',
  );
});
