import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/core_providers.dart';
import '../settings/settings_providers.dart';
import 'coingecko_price_notifier.dart';
import 'coingecko_repository.dart';
import 'coingecko_types.dart';

final _karlsenPriceCacheProvider =
    StateNotifierProvider<CoinGeckoPriceNotifier, CoinGeckoPrice>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return CoinGeckoPriceNotifier(repository);
});

final _karlsenPriceRemoteProvider =
    FutureProvider.autoDispose<CoinGeckoPrice>((ref) async {
  ref.watch(remoteRefreshProvider);
  ref.watch(timeProvider);

  final currency = ref.watch(currencyProvider);
  final fiat = currency.name.toLowerCase();

  final log = ref.read(loggerProvider);
  final cached = ref.read(_karlsenPriceCacheProvider);

  // 60 seconds
  final maxCacheAge = 60 * 1000;
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  if (cached.currency == currency.currency &&
      timestamp - cached.timestamp < maxCacheAge) {
    log.d('Using cached CoinGecko exchange rates');
    return cached;
  }

  try {
    final price = await getCoinGeckoApiPrice(fiat);
    if (price == null) {
      throw Exception('Failed to fetch remote exchange rate');
    }

    return CoinGeckoPrice(
      currency: currency.currency,
      price: Decimal.parse(price.toString()),
      timestamp: timestamp,
    );
  } catch (e, st) {
    log.e('Failed to fetch KLS exchange rate', error: e, stackTrace: st);
    if (cached.currency == currency.currency) {
      return cached;
    }
    return CoinGeckoPrice(
      currency: currency.currency,
      price: Decimal.zero,
      timestamp: timestamp,
    );
  }
});

final coingeckoKarlsenPriceProvider = Provider.autoDispose((ref) {
  final cache = ref.watch(_karlsenPriceCacheProvider.notifier);
  final remote = ref.watch(_karlsenPriceRemoteProvider);

  remote.whenOrNull(data: (data) {
    Future.microtask(() => cache.updatePrice(data));
  });

  return remote.asData?.value ?? cache.price;
});
