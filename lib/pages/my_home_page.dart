import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../model/providers/route_provider.dart';
import 'map_page.dart';
import 'more_pages/more_page.dart';
import 'route_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final List<Widget> _pages = [
    const RoutePage(),
    const MapPage(),
    const MorePage(),
  ];

  final List<AppBar> _appBars = [
    AppBar(toolbarHeight: 0, backgroundColor: const Color(0xBBFAFAFA)),
    AppBar(title: const Text('Map')),
    AppBar(title: const Text('More')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(_selectedIndex);
    });
  }

  @override
  void initState() {
    //TODO change to better loading
    context.read<RouteProvider>().getRouteData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBars[_selectedIndex],
      extendBodyBehindAppBar: true,
      // body: _pages[_selectedIndex],
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.route),
            label: 'Route',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.mapLocationDot),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
