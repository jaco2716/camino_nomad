import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../model/route_info/hotel.dart';
import '../model/route_info/hotel_price.dart';
import '../model/route_info/route_city.dart';
import '../model/route_info/route_data.dart';
import '../model/route_info/route_point.dart';

class DataGeneration {
  createAllCities(RouteData data) async {
    List<dynamic> cities = await loadCitiesFromFile();

    List<RouteCity> newCities = [];
    for (var i = 0; i < cities.length; i++) {
      // for (var i = 0; i < 2; i++) {
      List<double> routeDistances = [];
      for (var j = 0; j < data.routePoints.length; j++) {
        var latdistance = double.parse(cities[i]['lat']) - data.routePoints[j].lat;
        if (latdistance < 0) latdistance = latdistance * -1;
        var londistance = double.parse(cities[i]['lon']) - data.routePoints[j].lon;
        if (londistance < 0) londistance = londistance * -1;
        routeDistances.add(latdistance + londistance);
      }
      int lowestIndex = -1;
      double minValue = 9999;
      // print('lenth: ${routeDistances.length}');

      for (var ik = 0; ik < routeDistances.length; ik++) {
        if (routeDistances[ik] < minValue) {
          minValue = routeDistances[ik];
          lowestIndex = ik;
          // print('minValue: $lowestIndex:  ${minValue} ');
        }
      }
      var city = RouteCity(
        id: i,
        facilities: [],
        name: cities[i]['name'],
        lat: double.parse(cities[i]['lat']),
        lon: double.parse(cities[i]['lon']),
        routePointId: lowestIndex,
      );

      if ((cities[i]['albergues'] as List<dynamic>?)?.isNotEmpty ?? false) city.facilities.add(Facility.hotel);
      if (cities[i]['has_atm'] == '1') city.facilities.add(Facility.atm);
      if (cities[i]['has_bar_cafe'] == '1') city.facilities.add(Facility.barCafe);
      if (cities[i]['has_restaurant'] == '1') city.facilities.add(Facility.restaurant);
      if (cities[i]['has_shop'] == '1') city.facilities.add(Facility.shop);
      if (cities[i]['has_med_clinic'] == '1') city.facilities.add(Facility.medClinic);
      if (cities[i]['has_pharmacy'] == '1') city.facilities.add(Facility.pharmacy);
      if (cities[i]['has_fountain'] == '1') city.facilities.add(Facility.fountain);
      if (cities[i]['has_post_office'] == '1') city.facilities.add(Facility.postOffice);
      if (cities[i]['has_busstation'] == '1') city.facilities.add(Facility.busStation);
      if (cities[i]['has_trainstation'] == '1') city.facilities.add(Facility.trainStation);
      if (cities[i]['has_airport'] == '1') city.facilities.add(Facility.airport);
      if (cities[i]['has_tobaccostore'] == '1') city.facilities.add(Facility.tobaccoStore);
      // print(cityDistances);
      newCities.add(city);
    }

    printMore(jsonEncode(newCities));
  }

  addIdtoRoutePoints(RouteData data) {
    List<RoutePoint> points = [];
    for (var i = 0; i < data.routePoints.length; i++) {
      points.add(RoutePoint(
        i,
        data.routePoints[i].lat,
        data.routePoints[i].lon,
        data.routePoints[i].ele,
      ));
    }
    printMore(jsonEncode(points));
  }

  generateHotels(int startID) async {
    List<Hotel> newHotels = [];
    List<dynamic> citiesFile = await loadCitiesFromFile();
    List<dynamic> hotelsF = [];
    for (var city in citiesFile) {
      hotelsF.addAll(city['albergues']);
    }

    for (var i = startID; i < hotelsF.length; i++) {
      var newItem = Hotel(
        id: i + startID,
        name: hotelsF[i]['name'] ?? 'NULL',
        lat: double.parse(hotelsF[i]['latitude'] ?? '0.0'),
        lon: double.parse(hotelsF[i]['longitude'] ?? '0.0'),
        address: '${hotelsF[i]['address'] ?? 'NULL'}',
        cityName: '${hotelsF[i]['city_name'] ?? 'NULL'}',
        country: '${hotelsF[i]['country'] ?? 'NULL'}',
        postalCode: '${hotelsF[i]['postal_code'] ?? 'NULL'}',
        // hotelFacilities: hotelsF[i]['longitude'],
        bookingComScore: double.parse(hotelsF[i]['g_rating'] ?? '0.0'),
        bookingComUrl: hotelsF[i]['Booking_com_url'] ?? '',
        website: hotelsF[i]['web'] ?? '',
        facebook: hotelsF[i]['facebook_url'] ?? '',
        dormatoryAmount: int.parse(hotelsF[i]['number_of_dormitories'] ?? '0'),
        dormatoryBedAmount: int.parse(hotelsF[i]['places_in_dormitory'] ?? '0'),
        checkInTime: hotelsF[i]['checkin_time'] ?? '',
        checkOutTime: hotelsF[i]['checkout_time'] ?? '',
        closeTime: hotelsF[i]['close_time'] ?? '',
        status: convertStatus(int.parse(hotelsF[i]['status'] ?? '0')),
        hotelFacilities: [],
        emails: [],
        imageUrls: [],
        phones: [],
        prices: [],
      );

      if (hotelsF[i]['price_from_dormitory'] != null || hotelsF[i]['price_to_dormitory'] != null) {
        var price = HotelPrice(HotelType.dormitory, double.tryParse(hotelsF[i]['price_from_dormitory'] ?? 'NULL'),
            double.tryParse(hotelsF[i]['price_to_dormitory'] ?? 'NULL'));
        newItem.prices.add(price);
      }
      if (hotelsF[i]['price_from_singleroom'] != null || hotelsF[i]['price_to_singleroom'] != null) {
        var price = HotelPrice(HotelType.singleRoom, double.tryParse(hotelsF[i]['price_from_singleroom'] ?? 'NULL'),
            double.tryParse(hotelsF[i]['price_to_singleroom'] ?? 'NULL'));
        newItem.prices.add(price);
      }
      if (hotelsF[i]['price_from_doubleroom'] != null || hotelsF[i]['price_to_doubleroom'] != null) {
        var price = HotelPrice(HotelType.doubleRoom, double.tryParse(hotelsF[i]['price_from_doubleroom'] ?? 'NULL'),
            double.tryParse(hotelsF[i]['price_to_doubleroom'] ?? 'NULL'));
        newItem.prices.add(price);
      }
      if (hotelsF[i]['price_from_tripleroom'] != null || hotelsF[i]['price_to_tripleroom'] != null) {
        var price = HotelPrice(HotelType.tripleRoom, double.tryParse(hotelsF[i]['price_from_tripleroom'] ?? 'NULL'),
            double.tryParse(hotelsF[i]['price_to_tripleroom'] ?? 'NULL'));
        newItem.prices.add(price);
      }
      if (hotelsF[i]['price_from_quatroroom'] != null || hotelsF[i]['price_to_quatroroom'] != null) {
        var price = HotelPrice(HotelType.quadRoom, double.tryParse(hotelsF[i]['price_from_quatroroom'] ?? 'NULL'),
            double.tryParse(hotelsF[i]['price_to_quatroroom'] ?? 'NULL'));
        newItem.prices.add(price);
      }
      if (hotelsF[i]['price_from_apartment'] != null || hotelsF[i]['price_to_apartment'] != null) {
        var price = HotelPrice(HotelType.apartment, double.tryParse(hotelsF[i]['price_from_apartment'] ?? 'NULL'),
            double.tryParse(hotelsF[i]['price_to_apartment'] ?? 'NULL'));
        newItem.prices.add(price);
      }
      if (hotelsF[i]['price_from_bed_shared_room'] != null || hotelsF[i]['price_to_bed_shared_room'] != null) {
        var price = HotelPrice(HotelType.bedSharedRoom, double.tryParse(hotelsF[i]['price_from_bed_shared_room'] ?? 'NULL'),
            double.tryParse(hotelsF[i]['price_to_bed_shared_room'] ?? 'NULL'));
        newItem.prices.add(price);
      }
      if (hotelsF[i]['emails'] != null) {
        for (var j = 0; j < hotelsF[i]['emails'].length; j++) {
          newItem.emails.add(hotelsF[i]['emails'][j]['email']);
        }
      }
      if (hotelsF[i]['phones'] != null) {
        for (var j = 0; j < hotelsF[i]['phones'].length; j++) {
          String number = hotelsF[i]['phones'][j]['number'];
          String haswhatsapp = hotelsF[i]['phones'][j]['whatsapp'] ?? '0';
          if (haswhatsapp == '1') number += 'whatsapp';
          newItem.phones.add(number);
        }
      }

      if (hotelsF[i]['has_wifi'] == '1') newItem.hotelFacilities.add(HotelFacility.wifi);
      if (hotelsF[i]['has_tv'] == '1') newItem.hotelFacilities.add(HotelFacility.tv);
      if (hotelsF[i]['has_breakfast'] == '1') newItem.hotelFacilities.add(HotelFacility.breakfast);
      if (hotelsF[i]['is_breakfast_included'] == '1') newItem.hotelFacilities.add(HotelFacility.breakfastIncluded);
      if (hotelsF[i]['has_donativo_breakfast'] == '1') newItem.hotelFacilities.add(HotelFacility.donativoBreakfast);
      if (hotelsF[i]['has_lunch'] == '1') newItem.hotelFacilities.add(HotelFacility.lunch);
      if (hotelsF[i]['has_dinner'] == '1') newItem.hotelFacilities.add(HotelFacility.dinner);
      if (hotelsF[i]['has_community_dinner'] == '1') newItem.hotelFacilities.add(HotelFacility.communityDinner);
      if (hotelsF[i]['has_kitchen'] == '1') newItem.hotelFacilities.add(HotelFacility.kitchen);
      if (hotelsF[i]['has_microwave'] == '1') newItem.hotelFacilities.add(HotelFacility.microwave);
      if (hotelsF[i]['has_fridge'] == '1') newItem.hotelFacilities.add(HotelFacility.fridge);
      if (hotelsF[i]['has_water_boiler'] == '1') newItem.hotelFacilities.add(HotelFacility.waterBoiler);
      if (hotelsF[i]['has_cooktops'] == '1') newItem.hotelFacilities.add(HotelFacility.cooktops);
      if (hotelsF[i]['has_cooking_pots'] == '1') newItem.hotelFacilities.add(HotelFacility.cookingPots);
      if (hotelsF[i]['has_oven'] == '1') newItem.hotelFacilities.add(HotelFacility.oven);
      if (hotelsF[i]['has_plates_utensils'] == '1') newItem.hotelFacilities.add(HotelFacility.platesUtensils);
      if (hotelsF[i]['has_clothes_line'] == '1') newItem.hotelFacilities.add(HotelFacility.clothesLine);
      if (hotelsF[i]['is_vegetarian'] == '1') newItem.hotelFacilities.add(HotelFacility.vegetarian);
      if (hotelsF[i]['has_vegan_option'] == '1') newItem.hotelFacilities.add(HotelFacility.vegan);
      if (hotelsF[i]['has_hand_washing_sink'] == '1') newItem.hotelFacilities.add(HotelFacility.handWashingSink);
      if (hotelsF[i]['has_washing_machine'] == '1') newItem.hotelFacilities.add(HotelFacility.washingMachine);
      if (hotelsF[i]['has_tumble_dryer'] == '1') newItem.hotelFacilities.add(HotelFacility.tumbleDryer);
      if (hotelsF[i]['has_vending_machine'] == '1') newItem.hotelFacilities.add(HotelFacility.vendingMachine);
      if (hotelsF[i]['has_swimingpool'] == '1') newItem.hotelFacilities.add(HotelFacility.swimingPool);
      if (hotelsF[i]['has_cube_beds'] == '1') newItem.hotelFacilities.add(HotelFacility.cubeBeds);
      if (hotelsF[i]['has_curtains'] == '1') newItem.hotelFacilities.add(HotelFacility.privacyCurtains);
      if (hotelsF[i]['has_private_lockers'] == '1') newItem.hotelFacilities.add(HotelFacility.privateLockers);
      if (hotelsF[i]['has_individual_powerplug'] == '1') newItem.hotelFacilities.add(HotelFacility.individualPowerplug);
      if (hotelsF[i]['has_cotton_sheets'] == '1') newItem.hotelFacilities.add(HotelFacility.cottonSheets);
      if (hotelsF[i]['has_full_laundry_service'] == '1') newItem.hotelFacilities.add(HotelFacility.fullLaundryService);
      if (hotelsF[i]['pets_allowed'] == '1') newItem.hotelFacilities.add(HotelFacility.petsAllowed);

      newHotels.add(newItem);
    }
    printMore(jsonEncode(newHotels));
  }

  Future<List<dynamic>> loadCitiesFromFile() async {
    final String response = await rootBundle.loadString('assets/route_database/test.json');
    final Map<String, dynamic> routeData = await json.decode(response);
    return routeData['cities'] as List<dynamic>;
  }

  HotelStatus convertStatus(int status) {
    switch (status) {
      case 0:
        return HotelStatus.unknown;
      case 1:
        return HotelStatus.open;
      case 3:
        return HotelStatus.temporarilyClosed;
      case 5:
        return HotelStatus.open;
      case 6:
        return HotelStatus.closed;
      default:
        return HotelStatus.unknown;
    }
  }

  printMore(String text) {
    final pattern = RegExp('.{1,5000}'); // 5000 is the size of each chunk
    pattern.allMatches(text).forEach((match) {
      if (kDebugMode) {
        print(match.group(0));
      }
    });
  }
}



  // addFacitiliesToCities(RouteData data, List<dynamic> cities) {
  //   for (var i = 0; i < data.cities.length; i++) {
  //     if (cities[i]['has_atm'] == '1') data.cities[i].facilities.add(Facility.atm);
  //     if (cities[i]['has_bar_cafe'] == '1') data.cities[i].facilities.add(Facility.barCafe);
  //     if (cities[i]['has_restaurant'] == '1') data.cities[i].facilities.add(Facility.restaurant);
  //     if (cities[i]['has_shop'] == '1') data.cities[i].facilities.add(Facility.shop);
  //     if (cities[i]['has_med_clinic'] == '1') data.cities[i].facilities.add(Facility.medClinic);
  //     if (cities[i]['has_pharmacy'] == '1') data.cities[i].facilities.add(Facility.pharmacy);
  //     if (cities[i]['has_fountain'] == '1') data.cities[i].facilities.add(Facility.fountain);
  //     if (cities[i]['has_post_office'] == '1') data.cities[i].facilities.add(Facility.postOffice);
  //     if (cities[i]['has_busstation'] == '1') data.cities[i].facilities.add(Facility.busStation);
  //     if (cities[i]['has_trainstation'] == '1') data.cities[i].facilities.add(Facility.trainStation);
  //     if (cities[i]['has_airport'] == '1') data.cities[i].facilities.add(Facility.airport);
  //     if (cities[i]['has_tobaccostore'] == '1') data.cities[i].facilities.add(Facility.tobaccoStore);
  //   }

  //   // print(data.cities.length);
  //   printMore(jsonEncode(data.cities));
  // }