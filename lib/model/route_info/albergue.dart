import 'package:json_annotation/json_annotation.dart';

import 'albergue_price.dart';

part 'albergue.g.dart';

@JsonSerializable()
class Albergue {
  int id;
  String name;
  double lat;
  double lon;
  AlbergueStatus status;
  String checkInTime;
  String checkOutTime;
  String closeTime;
  String address;
  String postalCode;
  String bookingUrl;
  double bookingComScore;
  String website;
  String facebook;
  List<AlberguePrice> prices;
  List<AlbergueFacilities> albergueFacilities;
  List<String> phones;
  List<String> emails;

  Albergue({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    this.status = AlbergueStatus.unknown,
    this.checkInTime = '',
    this.checkOutTime = '',
    this.closeTime = '',
    this.address = '',
    this.postalCode = '',
    this.bookingUrl = '',
    this.bookingComScore = 0.0,
    this.website = '',
    this.facebook = '',
    this.prices = const [],
    this.albergueFacilities = const [],
    this.phones = const [],
    this.emails = const [],
  });

  //open from
  //open to
  //city id
  //city slug
  //country
  //region
  //province
  //postal Code
  //web

  factory Albergue.fromJson(Map<String, dynamic> json) => _$AlbergueFromJson(json);
  Map<String, dynamic> toJson() => _$AlbergueToJson(this);
}

enum AlbergueStatus {
  open,
  temporarilyClosed,
  closed,
  unknown,
}

enum AlbergueType {
  dormitory,
  single,
  double,
}

enum AlbergueFacilities {
  wifi,
  dinner,
  breakfast,
  breakfastIncluded,
  kitchen,
  microwave,
  waterBoiler,
  cooktops,
  cookingPots,
  platesUtensils,
  clothesLine,
}
