import 'package:flutter/material.dart';
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
  String cityName;
  String country;
  String postalCode;
  String bookingComUrl;
  double bookingComScore;
  String website;
  String facebook;
  int dormatoryAmount;
  int dormatoryBedAmount;
  List<String> imageUrls;
  List<AlberguePrice> prices;
  List<AlbergueFacility> albergueFacilities;
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
    this.cityName = '',
    this.country = '',
    this.postalCode = '',
    this.bookingComUrl = '',
    this.bookingComScore = 0.0,
    this.website = '',
    this.facebook = '',
    this.dormatoryAmount = 0,
    this.dormatoryBedAmount = 0,
    this.imageUrls = const [],
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
  //share_url

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
  singleRoom,
  doubleRoom,
  tripleRoom,
  quadRoom,
  apartment,
  bedSharedRoom,
}

enum AlbergueFacility {
  wifi,
  tv,
  breakfast,
  breakfastIncluded,
  lunch,
  dinner,
  kitchen,
  microwave,
  fridge,
  waterBoiler,
  cooktops,
  cookingPots,
  oven,
  platesUtensils,
  clothesLine,
  vegetarian,
  vegan,
  handWashingSink,
  washingMachine,
  tumbleDryer,
  communityDinner,
  vendingMachine,
  swimingPool,
  cubeBeds,
  privacyCurtains,
  privateLockers,
  individualPowerplug,
  cottonSheets,
  donativoBreakfast,
  fullLaundryService,
  petsAllowed,
}

Map<AlbergueFacility, IconData> albergueFacilityIconMap = {
  AlbergueFacility.wifi: Icons.wifi,
  AlbergueFacility.dinner: Icons.dining,
  AlbergueFacility.breakfast: Icons.breakfast_dining,
  AlbergueFacility.breakfastIncluded: Icons.breakfast_dining_outlined,
  AlbergueFacility.kitchen: Icons.kitchen,
  AlbergueFacility.microwave: Icons.microwave,
  AlbergueFacility.waterBoiler: Icons.local_fire_department,
  AlbergueFacility.cooktops: Icons.fireplace,
  AlbergueFacility.cookingPots: Icons.soup_kitchen,
  AlbergueFacility.platesUtensils: Icons.dining_outlined,
  AlbergueFacility.clothesLine: Icons.dry_cleaning,
};
Map<AlbergueType, String> albergueTypeIconMap = {
  AlbergueType.dormitory: 'assets/images/custom_icons/bunkbed.png',
  AlbergueType.singleRoom: 'assets/images/custom_icons/people1.png',
  AlbergueType.doubleRoom: 'assets/images/custom_icons/people2.png',
  AlbergueType.tripleRoom: 'assets/images/custom_icons/people3.png',
  AlbergueType.quadRoom: 'assets/images/custom_icons/people4.png',
  AlbergueType.apartment: 'assets/images/custom_icons/apartment.png',
  AlbergueType.bedSharedRoom: 'assets/images/custom_icons/sharedBed.png',
};
// Map<AlbergueType, IconData> albergueTypeIconMap = {
//   AlbergueType.dormitory: Icons.bedroom_child_outlined,
//   AlbergueType.singleRoom: Icons.single_bed,
//   AlbergueType.doubleRoom: Icons.king_bed,
//   AlbergueType.tripleRoom: Icons.timer_3_select_sharp,
//   AlbergueType.quadRoom: Icons.four_g_mobiledata,
//   AlbergueType.apartment: Icons.apartment,
//   AlbergueType.bedSharedRoom: Icons.share,
// };
