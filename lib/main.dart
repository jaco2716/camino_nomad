import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'model/providers/route_provider.dart';
import 'pages/my_home_page.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<RouteProvider>(
        create: (context) => RouteProvider(),
      ),
    ],
    builder: (context, _) {
      context.read<RouteProvider>().getRouteData();
      return const MyApp();
    },
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> getData;
  @override
  void initState() {
    getData = context.read<RouteProvider>().getRouteData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Camino Wanderer',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                // useMaterial3: true,
                // scaffoldBackgroundColor: const Color(0xFFFAFAFA),
                appBarTheme: const AppBarTheme(
                  centerTitle: true,
                  iconTheme: IconThemeData(color: Colors.blue),
                  backgroundColor: Color(0xFFFAFAFA),
                  foregroundColor: Colors.black,
                  titleTextStyle: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
                  elevation: 0,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.light, // For Android (dark icons)
                    statusBarBrightness: Brightness.light, // For iOS (dark icons)
                  ),
                ),
                primarySwatch: Colors.blue,
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                ),
                cardTheme: CardTheme(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )),
            home: const MyHomePage(),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
