import 'package:camino_nomad/pages/city_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../model/providers/app_data_provider.dart';
import '../widgets/city_list_tile.dart';
import 'package:diacritic/diacritic.dart';

class ChooseStartEndPage extends StatefulWidget {
  const ChooseStartEndPage({super.key, required this.isStart, required this.startIndex});

  final bool isStart;
  final int startIndex;

  @override
  State<ChooseStartEndPage> createState() => _ChooseStartEndPageState();
}

class _ChooseStartEndPageState extends State<ChooseStartEndPage> {
  final _searchController = TextEditingController();

  late AppDataProvider appDataP;
  late List<bool> showCities;
  // double modalHeight = 0;

  @override
  void initState() {
    super.initState();
    appDataP = Provider.of<AppDataProvider>(context, listen: false);
    showCities = List.generate(appDataP.cities.length, (index) => true);
    // print(MediaQuery.of(context).size.height);
    // print(MediaQuery.of(context).padding.top);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isStart ? 'Start Position' : 'End Position'),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(top: 16.0, bottom: 16, left: 16, right: widget.isStart ? 16 : 4),
        child: Column(
          children: [
            TextFormField(
              controller: _searchController,
              onChanged: searchCities,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
                isDense: true,
                hintText: 'Search...',
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 20),
                itemCount: appDataP.cities.length - widget.startIndex,
                itemBuilder: (lwcontext, index) {
                  int cityIndex = index + widget.startIndex;
                  if (!showCities[cityIndex]) return const SizedBox.shrink();
                  if (widget.isStart) {
                    return Card(
                        child: InkWell(
                      onTap: () {
                        if (widget.isStart) {
                          appDataP.setStartIndex(cityIndex);
                          appDataP.setEndIndex(null);
                        } else {
                          appDataP.setEndIndex(cityIndex);
                        }
                        Navigator.pop(context);
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            appDataP.cities[index + widget.startIndex].name,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          )),
                    ));
                  } else {
                    double totalDistance = 0;
                    for (var i = 1; i <= index + 1; i++) {
                      totalDistance += appDataP.allDistances[i + (appDataP.appDataSettings.startIndex)];
                    }
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 22.0),
                          child: CityListTile(
                            showBetweenDistance: false,
                            city: appDataP.cities[cityIndex],
                            totalDistance: totalDistance,
                            distanceBetween: index == 0 ? 0 : appDataP.allDistances[cityIndex],
                            onPressed: () {
                              appDataP.setEndIndex(cityIndex);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Material(
                                shape: const CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                color: Colors.transparent,
                                child: IconButton(
                                    padding: const EdgeInsets.all(14),
                                    onPressed: () {
                                      double modalHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 40;

                                      showModalBottomSheet(
                                        clipBehavior: Clip.hardEdge,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                        isScrollControlled: true,
                                        constraints: BoxConstraints(maxHeight: modalHeight),
                                        context: context,
                                        builder: (context) {
                                          return CityPage(city: appDataP.cities[cityIndex], totalDistance: totalDistance);
                                        },
                                      );
                                    },
                                    icon: const Icon(FontAwesomeIcons.circleInfo)))),
                      ],
                    );
                  }
                },
              ),
            )
          ],
        ),
      )),
    );
  }

  searchCities(String value) {
    if (appDataP.cities.isNotEmpty) {
      final input = removeDiacritics(value).replaceAll(RegExp('[^A-Za-z0-9]'), '').toLowerCase();
      final tempShowCities =
          appDataP.cities.map((e) => removeDiacritics(e.name).replaceAll(RegExp('[^A-Za-z0-9]'), '').toLowerCase().contains(input)).toList();
      setState(() => showCities = tempShowCities);
    }
  }
}
