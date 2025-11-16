import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_location/home_screen/home_state.dart';
import 'package:ip_location/l10n/l10n_extension.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeStateProvider);

    return CupertinoPageScaffold(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: switch (state) {
                AsyncLoading() => const CupertinoActivityIndicator(),
                AsyncError(:final error) => Text(error.toString()),
                AsyncData() => DataView(
                  state: state.value,
                ),
              },
            ),
          ),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              CupertinoButton(
                padding: .zero,
                onPressed: () => exit(0),
                child: const Icon(CupertinoIcons.power),
              ),
              CupertinoButton(
                padding: .zero,
                onPressed: ref.read(homeStateProvider.notifier).updateLocation,
                child: const Icon(CupertinoIcons.refresh),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

@visibleForTesting
class DataView extends StatelessWidget {
  const DataView({
    required this.state,
    super.key,
  });

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      HomeStateNoConnection() => Column(
        mainAxisSize: .min,
        children: [
          const Icon(
            CupertinoIcons.exclamationmark_circle_fill,
          ),
          Text(context.l10n.noConnection),
        ],
      ),
      HomeStateSuccess(
        :final ip,
        :final countryCode,
        :final countryFlag,
        :final city,
      ) =>
        Column(
          mainAxisSize: .min,
          crossAxisAlignment: .center,
          spacing: 4,
          children: [
            Text(ip),
            Row(
              mainAxisSize: .min,
              spacing: 8,
              children: [
                Image.network(
                  countryFlag,
                  height: 16,
                  fit: .fitHeight,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
                Text(countryCode),
              ],
            ),
            Text(city),
          ],
        ),
    };
  }
}
