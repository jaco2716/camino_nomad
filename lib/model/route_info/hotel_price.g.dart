// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotel_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HotelPrice _$HotelPriceFromJson(Map<String, dynamic> json) => HotelPrice(
      $enumDecode(_$HotelTypeEnumMap, json['type']),
      (json['fromPrice'] as num?)?.toDouble(),
      (json['toPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$HotelPriceToJson(HotelPrice instance) =>
    <String, dynamic>{
      'type': _$HotelTypeEnumMap[instance.type]!,
      'fromPrice': instance.fromPrice,
      'toPrice': instance.toPrice,
    };

const _$HotelTypeEnumMap = {
  HotelType.dormitory: 'dormitory',
  HotelType.singleRoom: 'singleRoom',
  HotelType.doubleRoom: 'doubleRoom',
  HotelType.tripleRoom: 'tripleRoom',
  HotelType.quadRoom: 'quadRoom',
  HotelType.apartment: 'apartment',
  HotelType.bedSharedRoom: 'bedSharedRoom',
};
