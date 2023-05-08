import 'dart:convert';
import 'dart:math';
import 'package:camino_nomad/model/route_info/albergue_price.dart';

import '../model/route_info/albergue.dart';
import '../model/route_info/route_city.dart';
import '../model/route_info/route_data.dart';

class RouteLogic {
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double calculateEleGain(RouteData data) {
    var rp = data.routePoints;

    for (var i = 0; i < rp.length; i++) {}

    return 0;
  }

  // createAllCities(RouteData data, List<dynamic> cities) {
  //   List<RouteCity> newCities = [];
  //   for (var i = 0; i < cities.length; i++) {
  //     // for (var i = 0; i < 2; i++) {
  //     List<double> routeDistances = [];
  //     for (var j = 0; j < data.routePoints.length; j++) {
  //       var latdistance = double.parse(cities[i]['lat']) - data.routePoints[j].lat;
  //       if (latdistance < 0) latdistance = latdistance * -1;
  //       var londistance = double.parse(cities[i]['lon']) - data.routePoints[j].lon;
  //       if (londistance < 0) londistance = londistance * -1;
  //       routeDistances.add(latdistance + londistance);
  //     }
  //     int lowestIndex = -1;
  //     double minValue = 9999;
  //     // print('lenth: ${routeDistances.length}');

  //     for (var ik = 0; ik < routeDistances.length; ik++) {
  //       if (routeDistances[ik] < minValue) {
  //         minValue = routeDistances[ik];
  //         lowestIndex = ik;
  //         // print('minValue: $lowestIndex:  ${minValue} ');
  //       }
  //     }
  //     var city = RouteCity(
  //       id: i,
  //       albergues: [],
  //       facilities: [],
  //       name: cities[i]['name'],
  //       lat: double.parse(cities[i]['lat']),
  //       lon: double.parse(cities[i]['lon']),
  //       routePointId: lowestIndex,
  //     );
  //     // print(cityDistances);
  //     newCities.add(city);
  //   }

  //   printMore(jsonEncode(newCities));
  // }

  // addIdtoRoutePoints(RouteData data) {
  //   print(data.routePoints.length);
  // List<RoutePoint> points = [];
  // for (var i = 0; i < data.routePoints.length; i++) {
  //   points.add(RoutePoint(data.routePoints[i].lat, data.routePoints[i].lon, data.routePoints[i].ele, id: i));
  // }
  // printMore(jsonEncode(points));
  // }

  addFacitiliesToCities(RouteData data, List<dynamic> cities) {
    for (var i = 0; i < data.cities.length; i++) {
      if (cities[i]['has_atm'] == '1') data.cities[i].facilities.add(Facility.atm);
      if (cities[i]['has_bar_cafe'] == '1') data.cities[i].facilities.add(Facility.barCafe);
      if (cities[i]['has_restaurant'] == '1') data.cities[i].facilities.add(Facility.restaurant);
      if (cities[i]['has_shop'] == '1') data.cities[i].facilities.add(Facility.shop);
      if (cities[i]['has_med_clinic'] == '1') data.cities[i].facilities.add(Facility.medClinic);
      if (cities[i]['has_pharmacy'] == '1') data.cities[i].facilities.add(Facility.pharmacy);
      if (cities[i]['has_fountain'] == '1') data.cities[i].facilities.add(Facility.fountain);
      if (cities[i]['has_post_office'] == '1') data.cities[i].facilities.add(Facility.postOffice);
      if (cities[i]['has_busstation'] == '1') data.cities[i].facilities.add(Facility.busStation);
      if (cities[i]['has_trainstation'] == '1') data.cities[i].facilities.add(Facility.trainStation);
      if (cities[i]['has_airport'] == '1') data.cities[i].facilities.add(Facility.airport);
      if (cities[i]['has_tobaccostore'] == '1') data.cities[i].facilities.add(Facility.tobaccoStore);
    }

    // print(data.cities.length);
    printMore(jsonEncode(data.cities));
  }

  generateAlbergues(int startID, List<dynamic> alberguesF) {
    List<Albergue> newAlbergues = [];

    // for (var i = startID; i < alberguesF.length; i++) {
    for (var i = 0; i < alberguesF.length; i++) {
      var newItem = Albergue(
        id: i + startID,
        name: alberguesF[i]['name'] ?? 'NULL',
        lat: double.parse(alberguesF[i]['latitude'] ?? '0.0'),
        lon: double.parse(alberguesF[i]['longitude'] ?? '0.0'),
        address: '${alberguesF[i]['address'] ?? 'NULL'}',
        cityName: '${alberguesF[i]['city_name'] ?? 'NULL'}',
        country: '${alberguesF[i]['country'] ?? 'NULL'}',
        postalCode: '${alberguesF[i]['postal_code'] ?? 'NULL'}',
        // albergueFacilities: alberguesF[i]['longitude'],
        bookingComScore: double.parse(alberguesF[i]['g_rating'] ?? '0.0'),
        bookingComUrl: alberguesF[i]['Booking_com_url'] ?? '',
        website: alberguesF[i]['web'] ?? '',
        facebook: alberguesF[i]['facebook_url'] ?? '',
        dormatoryAmount: int.parse(alberguesF[i]['number_of_dormitories'] ?? '0'),
        dormatoryBedAmount: int.parse(alberguesF[i]['places_in_dormitory'] ?? '0'),
        checkInTime: alberguesF[i]['checkin_time'] ?? '',
        checkOutTime: alberguesF[i]['checkout_time'] ?? '',
        closeTime: alberguesF[i]['close_time'] ?? '',
        status: convertStatus(int.parse(alberguesF[i]['status'] ?? '0')),
        albergueFacilities: [],
        emails: [],
        imageUrls: [],
        phones: [],
        prices: [],
      );

      if (alberguesF[i]['price_from_dormitory'] != null || alberguesF[i]['price_to_dormitory'] != null) {
        var price = AlberguePrice(AlbergueType.dormitory, double.tryParse(alberguesF[i]['price_from_dormitory'] ?? 'NULL'),
            double.tryParse(alberguesF[i]['price_to_dormitory'] ?? 'NULL'));
        newItem.prices.add(price);
      }
      if (alberguesF[i]['price_from_singleroom'] != null || alberguesF[i]['price_to_singleroom'] != null) {
        var price = AlberguePrice(AlbergueType.singleRoom, double.tryParse(alberguesF[i]['price_from_singleroom'] ?? 'NULL'),
            double.tryParse(alberguesF[i]['price_to_singleroom'] ?? 'NULL'));
        newItem.prices.add(price);
      }
      if (alberguesF[i]['price_from_doubleroom'] != null || alberguesF[i]['price_to_doubleroom'] != null) {
        var price = AlberguePrice(AlbergueType.doubleRoom, double.tryParse(alberguesF[i]['price_from_doubleroom'] ?? 'NULL'),
            double.tryParse(alberguesF[i]['price_to_doubleroom'] ?? 'NULL'));
        newItem.prices.add(price);
      }
      if (alberguesF[i]['price_from_tripleroom'] != null || alberguesF[i]['price_to_tripleroom'] != null) {
        var price = AlberguePrice(AlbergueType.tripleRoom, double.tryParse(alberguesF[i]['price_from_tripleroom'] ?? 'NULL'),
            double.tryParse(alberguesF[i]['price_to_tripleroom'] ?? 'NULL'));
        newItem.prices.add(price);
      }
      if (alberguesF[i]['price_from_quatroroom'] != null || alberguesF[i]['price_to_quatroroom'] != null) {
        var price = AlberguePrice(AlbergueType.quadRoom, double.tryParse(alberguesF[i]['price_from_quatroroom'] ?? 'NULL'),
            double.tryParse(alberguesF[i]['price_to_quatroroom'] ?? 'NULL'));
        newItem.prices.add(price);
      }
      if (alberguesF[i]['price_from_apartment'] != null || alberguesF[i]['price_to_apartment'] != null) {
        var price = AlberguePrice(AlbergueType.apartment, double.tryParse(alberguesF[i]['price_from_apartment'] ?? 'NULL'),
            double.tryParse(alberguesF[i]['price_to_apartment'] ?? 'NULL'));
        newItem.prices.add(price);
      }
      if (alberguesF[i]['price_from_bed_shared_room'] != null || alberguesF[i]['price_to_bed_shared_room'] != null) {
        var price = AlberguePrice(AlbergueType.bedSharedRoom, double.tryParse(alberguesF[i]['price_from_bed_shared_room'] ?? 'NULL'),
            double.tryParse(alberguesF[i]['price_to_bed_shared_room'] ?? 'NULL'));
        newItem.prices.add(price);
      }

      if (alberguesF[i]['emails'] != null) {
        for (var j = 0; j < alberguesF[i]['emails'].length; j++) {
          newItem.emails.add(alberguesF[i]['emails'][j]['email']);
        }
      }
      if (alberguesF[i]['phones'] != null) {
        for (var j = 0; j < alberguesF[i]['phones'].length; j++) {
          newItem.phones.add(alberguesF[i]['phones'][j]['number']);
        }
      }

      if (alberguesF[i]['has_kitchen'] == '1') newItem.albergueFacilities.add(AlbergueFacility.kitchen);
      if (alberguesF[i]['has_cooktops'] == '1') newItem.albergueFacilities.add(AlbergueFacility.cooktops);
      if (alberguesF[i]['has_microwave'] == '1') newItem.albergueFacilities.add(AlbergueFacility.microwave);
      if (alberguesF[i]['has_fridge'] == '1') newItem.albergueFacilities.add(AlbergueFacility.fridge);
      if (alberguesF[i]['has_water_boiler'] == '1') newItem.albergueFacilities.add(AlbergueFacility.waterBoiler);
      if (alberguesF[i]['has_plates_utensils'] == '1') newItem.albergueFacilities.add(AlbergueFacility.platesUtensils);
      if (alberguesF[i]['has_cooking_pots'] == '1') newItem.albergueFacilities.add(AlbergueFacility.cookingPots);
      if (alberguesF[i]['has_oven'] == '1') newItem.albergueFacilities.add(AlbergueFacility.oven);
      if (alberguesF[i]['has_breakfast'] == '1') newItem.albergueFacilities.add(AlbergueFacility.breakfast);
      if (alberguesF[i]['is_breakfast_included'] == '1') newItem.albergueFacilities.add(AlbergueFacility.breakfastIncluded);
      if (alberguesF[i]['has_clothes_line'] == '1') newItem.albergueFacilities.add(AlbergueFacility.clothesLine);
      if (alberguesF[i]['has_wifi'] == '1') newItem.albergueFacilities.add(AlbergueFacility.wifi);
      if (alberguesF[i]['has_tv'] == '1') newItem.albergueFacilities.add(AlbergueFacility.tv);
      if (alberguesF[i]['is_vegetarian'] == '1') newItem.albergueFacilities.add(AlbergueFacility.vegetarian);
      if (alberguesF[i]['has_vegan_option'] == '1') newItem.albergueFacilities.add(AlbergueFacility.vegan);
      if (alberguesF[i]['has_hand_washing_sink'] == '1') newItem.albergueFacilities.add(AlbergueFacility.handWashingSink);
      if (alberguesF[i]['has_washing_machine'] == '1') newItem.albergueFacilities.add(AlbergueFacility.washingMachine);
      if (alberguesF[i]['has_tumble_dryer'] == '1') newItem.albergueFacilities.add(AlbergueFacility.tumbleDryer);
      if (alberguesF[i]['has_community_dinner'] == '1') newItem.albergueFacilities.add(AlbergueFacility.communityDinner);
      if (alberguesF[i]['has_vending_machine'] == '1') newItem.albergueFacilities.add(AlbergueFacility.vendingMachine);
      if (alberguesF[i]['has_swimingpool'] == '1') newItem.albergueFacilities.add(AlbergueFacility.swimingPool);
      if (alberguesF[i]['has_cube_beds'] == '1') newItem.albergueFacilities.add(AlbergueFacility.cubeBeds);
      if (alberguesF[i]['has_curtains'] == '1') newItem.albergueFacilities.add(AlbergueFacility.privacyCurtains);
      if (alberguesF[i]['has_private_lockers'] == '1') newItem.albergueFacilities.add(AlbergueFacility.privateLockers);
      if (alberguesF[i]['has_individual_powerplug'] == '1') newItem.albergueFacilities.add(AlbergueFacility.individualPowerplug);
      if (alberguesF[i]['has_cotton_sheets'] == '1') newItem.albergueFacilities.add(AlbergueFacility.cottonSheets);
      if (alberguesF[i]['has_donativo_breakfast'] == '1') newItem.albergueFacilities.add(AlbergueFacility.donativoBreakfast);
      if (alberguesF[i]['has_full_laundry_service'] == '1') newItem.albergueFacilities.add(AlbergueFacility.fullLaundryService);
      if (alberguesF[i]['has_lunch'] == '1') newItem.albergueFacilities.add(AlbergueFacility.lunch);
      if (alberguesF[i]['pets_allowed'] == '1') newItem.albergueFacilities.add(AlbergueFacility.petsAllowed);

      newAlbergues.add(newItem);
    }

    printMore(jsonEncode(newAlbergues));
  }

  AlbergueStatus convertStatus(int status) {
    switch (status) {
      case 0:
        return AlbergueStatus.unknown;
      case 1:
        return AlbergueStatus.open;
      case 3:
        return AlbergueStatus.temporarilyClosed;
      case 5:
        return AlbergueStatus.open;
      case 6:
        return AlbergueStatus.closed;
      default:
        return AlbergueStatus.unknown;
    }
  }

  printMore(String text) {
    final pattern = RegExp('.{1,5000}'); // 5000 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
