import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// checks if the device is online
abstract class NetworkInfo {
  // true = connected
  Future<bool> get isConnected;
}

// actual implementation using connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty &&
        !results.contains(ConnectivityResult.none);
  }
}

// provider for network info
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(Connectivity());
});
