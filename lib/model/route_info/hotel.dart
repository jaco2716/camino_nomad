import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'hotel_price.dart';

part 'hotel.g.dart';

@JsonSerializable()
class Hotel {
  int id;
  String name;
  double lat;
  double lon;
  HotelStatus status;
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
  List<HotelPrice> prices;
  List<HotelFacility> hotelFacilities;
  List<String> phones;
  List<String> emails;
  double? cityDistance;

  Hotel({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    this.status = HotelStatus.unknown,
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
    this.hotelFacilities = const [],
    this.phones = const [],
    this.emails = const [],
  });

  @override
  String toString() => 'id: $id, name: $name';

  factory Hotel.fromJson(Map<String, dynamic> json) => _$HotelFromJson(json);
  Map<String, dynamic> toJson() => _$HotelToJson(this);
}

enum HotelStatus {
  open,
  temporarilyClosed,
  closed,
  unknown,
}

enum HotelType {
  dormitory,
  singleRoom,
  doubleRoom,
  tripleRoom,
  quadRoom,
  apartment,
  bedSharedRoom,
}

enum HotelFacility {
  wifi,
  tv,
  breakfast,
  breakfastIncluded,
  donativoBreakfast,
  lunch,
  dinner,
  communityDinner,
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
  vendingMachine,
  swimingPool,
  cubeBeds,
  privacyCurtains,
  privateLockers,
  individualPowerplug,
  cottonSheets,
  fullLaundryService,
  petsAllowed,
}

Map<HotelFacility, IconData> hotelFacilityIconMap = {
  HotelFacility.wifi: Icons.wifi,
  HotelFacility.dinner: Icons.dining,
  HotelFacility.breakfast: Icons.breakfast_dining,
  HotelFacility.breakfastIncluded: Icons.breakfast_dining_outlined,
  HotelFacility.kitchen: Icons.kitchen,
  HotelFacility.microwave: Icons.microwave,
  HotelFacility.waterBoiler: Icons.local_fire_department,
  HotelFacility.cooktops: Icons.fireplace,
  HotelFacility.cookingPots: Icons.soup_kitchen,
  HotelFacility.platesUtensils: Icons.dining_outlined,
  HotelFacility.clothesLine: Icons.dry_cleaning,
};
Map<HotelType, String> hotelTypeIconMap = {
  HotelType.dormitory: 'assets/images/custom_icons/hotel_type/bunkbed.png',
  HotelType.singleRoom: 'assets/images/custom_icons/hotel_type/people1.png',
  HotelType.doubleRoom: 'assets/images/custom_icons/hotel_type/people2.png',
  HotelType.tripleRoom: 'assets/images/custom_icons/hotel_type/people3.png',
  HotelType.quadRoom: 'assets/images/custom_icons/hotel_type/people4.png',
  HotelType.apartment: 'assets/images/custom_icons/hotel_type/apartment.png',
  HotelType.bedSharedRoom: 'assets/images/custom_icons/hotel_type/sharedBed.png',
};
// Map<HotelType, IconData> hotelTypeIconMap = {
//   HotelType.dormitory: Icons.bedroom_child_outlined,
//   HotelType.singleRoom: Icons.single_bed,
//   HotelType.doubleRoom: Icons.king_bed,
//   HotelType.tripleRoom: Icons.timer_3_select_sharp,
//   HotelType.quadRoom: Icons.four_g_mobiledata,
//   HotelType.apartment: Icons.apartment,
//   HotelType.bedSharedRoom: Icons.share,
// };
