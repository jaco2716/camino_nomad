import 'dart:convert';
import 'dart:math';
import '../model/route_info/route_city.dart';
import '../model/route_info/route_data.dart';

class RouteLogic {
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
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

  printMore(String text) {
    final pattern = RegExp('.{1,5000}'); // 5000 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
