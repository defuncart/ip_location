import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ip_geolocation_io/ip_geolocation_io.dart';
import 'package:ip_location/home_screen/ip_locator_key.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_state.g.dart';

sealed class HomeState {
  const HomeState();
}

class HomeStateNoConnection extends HomeState {
  const HomeStateNoConnection();
}

class HomeStateSuccess extends HomeState {
  final String ip;
  final String countryCode;
  final String countryFlag;
  final String city;

  const HomeStateSuccess({
    required this.ip,
    required this.countryCode,
    required this.countryFlag,
    required this.city,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeStateSuccess &&
        other.ip == ip &&
        other.countryCode == countryCode &&
        other.countryFlag == countryFlag &&
        other.city == city;
  }

  @override
  int get hashCode {
    return ip.hashCode ^ countryCode.hashCode ^ countryFlag.hashCode ^ city.hashCode;
  }

  @override
  String toString() {
    return 'HomeStateSuccess(ip: $ip, countryCode: $countryCode, countryFlag: $countryFlag, city: $city)';
  }
}

@riverpod
class HomeStateNotifier extends _$HomeStateNotifier {
  @override
  FutureOr<HomeState> build() => _getLocation();

  void updateLocation() async {
    final newState = await _getLocation();
    state = AsyncValue.data(newState);
  }

  FutureOr<HomeState> _getLocation() async {
    state = const AsyncValue.loading();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.vpn)) {
      const geolocation = IpGeoLocationIO(ipgeolocationKey);
      final response = await geolocation.getUserLocation();

      return HomeStateSuccess(
        ip: response.ip,
        countryCode: response.countryCode2,
        countryFlag: response.countryFlag,
        city: response.city,
      );
    } else {
      return const HomeStateNoConnection();
    }
  }
}
