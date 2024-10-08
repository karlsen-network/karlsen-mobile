// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_explorer_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BlockExplorerSettingsImpl _$$BlockExplorerSettingsImplFromJson(Map json) =>
    _$BlockExplorerSettingsImpl(
      selection: (json['selection'] as Map?)?.map(
            (k, e) => MapEntry($enumDecode(_$KarlsenNetworkEnumMap, k),
                BlockExplorer.fromJson(Map<String, dynamic>.from(e as Map))),
          ) ??
          const {
            KarlsenNetwork.mainnet: kKarlsenExplorerMainnet,
            KarlsenNetwork.testnet: kKarlsenExplorerMainnet,
            KarlsenNetwork.devnet: kKarlsenExplorerMainnet,
            KarlsenNetwork.simnet: kKarlsenExplorerMainnet
          },
    );

Map<String, dynamic> _$$BlockExplorerSettingsImplToJson(
        _$BlockExplorerSettingsImpl instance) =>
    <String, dynamic>{
      'selection': instance.selection
          .map((k, e) => MapEntry(_$KarlsenNetworkEnumMap[k]!, e.toJson())),
    };

const _$KarlsenNetworkEnumMap = {
  KarlsenNetwork.mainnet: 'mainnet',
  KarlsenNetwork.testnet: 'testnet',
  KarlsenNetwork.devnet: 'devnet',
  KarlsenNetwork.simnet: 'simnet',
};
