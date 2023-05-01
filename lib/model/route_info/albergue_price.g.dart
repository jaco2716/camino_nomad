// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'albergue_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlberguePrice _$AlberguePriceFromJson(Map<String, dynamic> json) =>
    AlberguePrice(
      $enumDecode(_$AlbergueTypeEnumMap, json['type']),
      (json['toPrice'] as num).toDouble(),
      (json['fromPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$AlberguePriceToJson(AlberguePrice instance) =>
    <String, dynamic>{
      'type': _$AlbergueTypeEnumMap[instance.type]!,
      'fromPrice': instance.fromPrice,
      'toPrice': instance.toPrice,
    };

const _$AlbergueTypeEnumMap = {
  AlbergueType.dormitory: 'dormitory',
  AlbergueType.single: 'single',
  AlbergueType.double: 'double',
};
