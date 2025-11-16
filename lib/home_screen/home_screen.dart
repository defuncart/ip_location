import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.power),
                onPressed: () => exit(0),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
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
        mainAxisSize: MainAxisSize.min,
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(ip),
            const Gap(4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  countryFlag,
                  height: 16,
                  fit: BoxFit.fitHeight,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
                const Gap(8),
                Text(countryCode),
              ],
            ),
            const Gap(4),
            Text(city),
          ],
        ),
    };
  }
}
