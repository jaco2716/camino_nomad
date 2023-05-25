import 'dart:async';
import 'package:camino_nomad/model/route_info/route_city.dart';
import 'package:camino_nomad/model/route_info/route_data.dart';
import 'package:camino_nomad/model/route_info/route_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import '../logic/route_logic.dart';
import '../model/providers/app_data_provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(43.16, -4.8),
    zoom: 6,
  );

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  late AppDataProvider appDataP;
  late RouteData routeData;

  late List<RoutePoint> routePoints;
  late List<RouteCity> routeCities;

  // List<dynamic> cities = [];

  double totalDistance = 0;
  Set<Marker> markers = {};
  bool _showMarkers = false;

  List<LatLng> polylineCoordinates = [];
  @override
  void initState() {
    appDataP = context.read<AppDataProvider>();
    routeData = appDataP.routeData[appDataP.routeIndex];
    routePoints = routeData.routePoints;
    routeCities = appDataP.cities;
    getMapRouteData();
    // readJson();
    super.initState();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  getMapRouteData() async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/images/custom_icons/city_pin.png', 70);
    var myIcon = BitmapDescriptor.fromBytes(markerIcon);

    polylineCoordinates = (routePoints).map<LatLng>((e) => LatLng(e.lat, e.lon)).toList();
    markers = routeCities
        .map<Marker>((e) =>
            Marker(markerId: MarkerId('${e.id}'), position: LatLng(e.lat, e.lon), infoWindow: InfoWindow(title: e.name), icon: myIcon, zIndex: 99))
        .toSet();
    totalDistance = appDataP.allDistances.reduce((a, b) => a + b);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Stack(
        children: [
          Center(
            child: GoogleMap(
              // mapType: MapType.hybrid,
              initialCameraPosition: MapPage._kGooglePlex,

              polylines: {
                Polyline(
                  polylineId: const PolylineId('routeStroke'),
                  points: polylineCoordinates,
                  color: const Color(0xFF0070CC),
                  width: 6,
                ),
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: polylineCoordinates,
                  color: Colors.blue,
                  width: 3,
                  zIndex: 1,
                ),
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },

              onCameraIdle: () async {
                var c = await _controller.future;
                var zoom = await c.getZoomLevel();
                if (zoom < 10) {
                  setState(() {
                    _showMarkers = false;
                  });
                } else {
                  setState(() {
                    _showMarkers = true;
                  });
                }
              },
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onLongPress: (argument) {
                RouteLogic rl = RouteLogic();
                // rl.addFacitiliesToCities(appDataP.routeData!, cities);
              },

              markers: _showMarkers ? markers : const <Marker>{},
            ),
          ),
          Card(
            color: const Color(0xCCFFFFFF),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Camino Frances',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber[800], fontSize: 15),
                  ),
                  const SizedBox(width: 10),
                  Text('${(totalDistance * 100).roundToDouble() / 100} km', style: const TextStyle(fontSize: 12, height: 1.4)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}



  // Future<void> readJson() async {
  //   //   // var myIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(20, 20)), 'assets/images/city_pin.png.png');

  //   //   // late BitmapDescriptor myIcon;
  //   //   // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)), 'assets/my_icon.png').then((onValue) {
  //   //   //   myIcon = onValue;
  //   //   // });
  //   //   // final String response = await rootBundle.loadString('assets/route_data/camino_frances_route_points.json');
  //   final String response = await rootBundle.loadString('assets/route_data/test.json');
  //   final Map<String, dynamic> routeData = await json.decode(response);

  //   // List<dynamic> routePoints = routeData['route_points'];
  //   cities = routeData['cities'];
  //   //   // print(cities.toString());
  //   //   // markers.add(Marker(markerId: const MarkerId('2'), position: const LatLng(42.2, -1.2), infoWindow: const InfoWindow(title: 'het'), icon: myIcon));
  //   //   // markers.add(const Marker(markerId: MarkerId('3'), position: LatLng(42.2, -1.6), infoWindow: InfoWindow(title: 'het')));

  //   //   markers = cities
  //   //       .map<Marker>((e) => Marker(
  //   //           markerId: MarkerId(e['key']),
  //   //           position: LatLng(double.parse(e['lat']), double.parse(e['lon'])),
  //   //           infoWindow: InfoWindow(title: e['name']),
  //   //           icon: myIcon,
  //   //           zIndex: 99))
  //   //       .toSet();
  //   //   // setMarkers();

  //   //   // polylineCoordinates = (routePoints).map<LatLng>((e) => LatLng(double.parse(e['lat']), double.parse(e['lon']))).toList();
  //   //   totalDistance = getTotalDistance();

  //   //   setState(() {});
  // }

  // setMarkers() {
  //   // var data = context.read<RouteProvider>().routeData!;
  //   // for (var i = 0; i < data.cities.length; i++) {
  //   //   markers.add(Marker(
  //   //       markerId: MarkerId('${data.cities[i].id}'),
  //   //       position: LatLng(data.cities[i].lat, data.cities[i].lon),
  //   //       infoWindow: InfoWindow(title: data.cities[i].name, snippet: '${data.cities[i].lat} - ${data.cities[i].lon}')));
  //   // }
  //   var data = appDataP.routeData!;
  //   for (var i = 0; i < data.cities.length; i++) {
  //     markers.add(Marker(
  //         markerId: MarkerId('point${i}'),
  //         position: LatLng(data.routePoints[data.cities[i].routePointId].lat, data.routePoints[data.cities[i].routePointId].lon),
  //         infoWindow: InfoWindow(title: data.cities[i].name, snippet: '${data.cities[i].lat} - ${data.cities[i].lon}'),
  //         zIndex: 1));
  //   }
  // }



// findRPByTap(LatLng argument) async {
//                 print('tapped');
//                 for (var i = 0; i < appDataP.routeData!.routePoints.length; i++) {
//                   var latdistance = argument.latitude - appDataP.routeData!.routePoints[i].lat;
//                   if (latdistance < 0) latdistance = latdistance * -1;
//                   var londistance = argument.longitude - appDataP.routeData!.routePoints[i].lon;
//                   if (londistance < 0) londistance = londistance * -1;
//                   // if (latdistance + londistance < 0.0003) print('## $i:  ${latdistance + londistance}');
//                   if (latdistance + londistance < 0.0003) {
//                     print('$i:  ${latdistance + londistance}');
//                     List<double> cityDistances = [];
//                     for (var j = 0; j < cities.length; j++) {
//                       var clatdistance = argument.latitude - double.parse(cities[j]['lat']);
//                       if (clatdistance < 0) clatdistance = clatdistance * -1;
//                       var clondistance = argument.longitude - double.parse(cities[j]['lon']);
//                       if (clondistance < 0) clondistance = clondistance * -1;
//                       cityDistances.add(clatdistance + clondistance);
//                       // // print('${cities[j]['name']} : ${cities[j]['lat']} : ${cities[j]['lon']}');
//                       // // if (clatdistance + clondistance < 0.003) print('City $i:  ${clatdistance + clondistance}');
//                       // if (clatdistance + clondistance < 0.003) {
//                       //   var city = RouteCity(
//                       //       id: j,
//                       //       hotels: [],
//                       //       facilities: [],
//                       //       name: cities[j]['name'],
//                       //       lat: double.parse(cities[j]['lat']),
//                       //       lon: double.parse(cities[j]['lon']),
//                       //       routePoint: RoutePoint(appDataP.routeData!.routePoints[i].lat, appDataP.routeData!.routePoints[i].lon,
//                       //           appDataP.routeData!.routePoints[i].ele));

//                       //   // print('#### $j:  ${latdistance + londistance} : ${cities[j]['name']} ####');
//                       //   print(city.toString());
//                       //   print(city.toJson());
//                       //   break;
//                       // }
//                     }
//                     int lowestIndex = -1;
//                     double minValue = 99;
//                     print('length: ${cityDistances.length}');
//                     for (var ik = 0; ik < cityDistances.length; ik++) {
//                       if (cityDistances[ik] < minValue) {
//                         minValue = cityDistances[ik];
//                         lowestIndex = ik;
//                       }
//                     }
//                     if (lowestIndex != -1) {
//                       // var city = RouteCity(
//                       //     id: lowestIndex,
//                       //     hotels: [],
//                       //     facilities: [],
//                       //     name: cities[lowestIndex]['name'],
//                       //     lat: double.parse(cities[lowestIndex]['lat']),
//                       //     lon: double.parse(cities[lowestIndex]['lon']),
//                       //     routePoint: RoutePoint(appDataP.routeData!.routePoints[lowestIndex].lat,
//                       //         appDataP.routeData!.routePoints[lowestIndex].lon, appDataP.routeData!.routePoints[lowestIndex].ele));
//                       // // print(cityDistances);
//                       // newCities.add(city);

//                       print('Closest city = ${cities[lowestIndex]['name']}');
//                     } else {
//                       print('no city found');
//                     }

//                     break;
//                   }
//                 }
// lat: 42.78871, lon: -7.56799
// lat: 42.78711, lon: -7.56382

// lat: 42.46358, lon: -5.88238
// lat: 42.46442, lon: -5.87722
//               var latsdistance = 42.46358 - 42.46442;
//               if (latsdistance < 0) latsdistance = latsdistance * -1;
//               var lonsdistance = -5.88238 - (-5.87722);
//               if (lonsdistance < 0) lonsdistance = lonsdistance * -1;
//               print(' city dist: ${latsdistance + lonsdistance}');

//               for (var i = 0; i < cities.length; i++) {
//                 var latdistance = argument.latitude - double.parse(cities[i]['lat']);
//                 var londistance = argument.longitude - double.parse(cities[i]['lon']);
//                 print('${cities[i]['name']} : ${cities[i]['lat']} : ${cities[i]['lon']}');
//                 if (latdistance + londistance < 0.001 && latdistance + londistance > -0.001) {
//                   var city = RouteCity(id: i,
//                   hotels: [],
//                   facilities: [],
//                   name: cities[i]['name'],
//                   lat: cities[i]['lat'],
//                   lon: cities[i]['lon'],
//                   routePoint: RoutePoint()

//                   );
//                   '''
//                   {
//                       "id": 1,
//                       "name": "Honto (Napoleon Route)",
//                       "facilities": [],
//                       "hotels": [],
//                       "lat": 43.12435300,
//                       "lon": -1.24474800,
//                       "routePoint": {
//                           "lat": 43.16366531,
//                           "lon": -1.23436922,
//                           "ele": 192.3
//                       }
//                   },
//                   ''';
//                   print('#### $i:  ${latdistance + londistance} : ${cities[i]['name']} ####');
//                   break;
//                 }
//               }
//               for (var i = 0; i < appDataP.routeData!.routePoints.length; i++) {
//                 var latdistance = argument.latitude - appDataP.routeData!.routePoints[i].lat;
//                 var londistance = argument.longitude - appDataP.routeData!.routePoints[i].lon;
//                 if (latdistance + londistance < 0.00004 && latdistance + londistance > -0.00004) {
//                   print('$i:  ${latdistance + londistance}');
//                   break;
//                 }
//               }

//               print(argument);
//               var c = await _controller.future;
//               c.animateCamera(CameraUpdate.newLatLng(argument));

//               },