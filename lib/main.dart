import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_location/home_screen/home_screen.dart';
import 'package:ip_location/l10n/generated/app_localizations.dart';

void main() {
  HttpOverrides.global = _UserAgentHttpOverrides();

  return runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// It seems a User-Agent is required by ipgeolocation to access static flags from their server
// Although Image.network(headers: …) should suffice, it does not actually apply the User-Agent header on the request that the Flutter engine makes.
// Thus overriding User-Agent for all requests
class _UserAgentHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..userAgent =
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36';
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
