import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'model/providers/app_data_provider.dart';
import 'pages/my_home_page.dart';
import '../../constants/styles_config.dart' as styles;
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AppDataProvider>(
        create: (context) => AppDataProvider(),
      ),
    ],
    builder: (context, _) {
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
    getData = context.read<AppDataProvider>().getRouteData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

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
          dialogBackgroundColor: const Color(0xFFFAFAFA),
          primarySwatch: Colors.blue,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          ),
          cardTheme: CardTheme(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: styles.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )),
      home: FutureBuilder(
          future: getData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              FlutterNativeSplash.remove();
              return const MyHomePage();
            }
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }),
    );
  }
}
