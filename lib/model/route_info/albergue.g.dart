// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'albergue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Albergue _$AlbergueFromJson(Map<String, dynamic> json) => Albergue(
      id: json['id'] as int,
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      status: $enumDecodeNullable(_$AlbergueStatusEnumMap, json['status']) ??
          AlbergueStatus.unknown,
      checkInTime: json['checkInTime'] as String? ?? '',
      checkOutTime: json['checkOutTime'] as String? ?? '',
      closeTime: json['closeTime'] as String? ?? '',
      address: json['address'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      bookingUrl: json['bookingUrl'] as String? ?? '',
      bookingComScore: (json['bookingComScore'] as num?)?.toDouble() ?? 0.0,
      website: json['website'] as String? ?? '',
      facebook: json['facebook'] as String? ?? '',
      prices: (json['prices'] as List<dynamic>?)
              ?.map((e) => AlberguePrice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      albergueFacilities: (json['albergueFacilities'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$AlbergueFacilitiesEnumMap, e))
              .toList() ??
          const [],
      phones: (json['phones'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      emails: (json['emails'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AlbergueToJson(Albergue instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lat': instance.lat,
      'lon': instance.lon,
      'status': _$AlbergueStatusEnumMap[instance.status]!,
      'checkInTime': instance.checkInTime,
      'checkOutTime': instance.checkOutTime,
      'closeTime': instance.closeTime,
      'address': instance.address,
      'postalCode': instance.postalCode,
      'bookingUrl': instance.bookingUrl,
      'bookingComScore': instance.bookingComScore,
      'website': instance.website,
      'facebook': instance.facebook,
      'prices': instance.prices,
      'albergueFacilities': instance.albergueFacilities
          .map((e) => _$AlbergueFacilitiesEnumMap[e]!)
          .toList(),
      'phones': instance.phones,
      'emails': instance.emails,
    };

const _$AlbergueStatusEnumMap = {
  AlbergueStatus.open: 'open',
  AlbergueStatus.temporarilyClosed: 'temporarilyClosed',
  AlbergueStatus.closed: 'closed',
  AlbergueStatus.unknown: 'unknown',
};

const _$AlbergueFacilitiesEnumMap = {
  AlbergueFacilities.wifi: 'wifi',
  AlbergueFacilities.dinner: 'dinner',
  AlbergueFacilities.breakfast: 'breakfast',
  AlbergueFacilities.breakfastIncluded: 'breakfastIncluded',
  AlbergueFacilities.kitchen: 'kitchen',
  AlbergueFacilities.microwave: 'microwave',
  AlbergueFacilities.waterBoiler: 'waterBoiler',
  AlbergueFacilities.cooktops: 'cooktops',
  AlbergueFacilities.cookingPots: 'cookingPots',
  AlbergueFacilities.platesUtensils: 'platesUtensils',
  AlbergueFacilities.clothesLine: 'clothesLine',
};
