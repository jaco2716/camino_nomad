import 'package:flutter/material.dart';

class ChooseRoutePage extends StatelessWidget {
  const ChooseRoutePage({super.key});

  static const List<Map<String, dynamic>> dataList = [
    {
      'title': 'Camino Francis',
      'distance': 777,
      'elevmin': 249,
      'elevmax': 1512,
      'elevgain': 13876,
      'elevloss': -13800,
    },
    // {
    //   'title': 'Camino Portugues Central',
    //   'distance': 247,
    //   'elevmin': 149,
    //   'elevmax': 912,
    //   'elevgain': 11876,
    //   'elevloss': -9800,
    // },
    // {
    //   'title': 'Camino Ingles',
    //   'distance': 687,
    //   'elevmin': 499,
    //   'elevmax': 1102,
    //   'elevgain': 9204,
    //   'elevloss': -7205,
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
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
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return Theme(
                    data: Theme.of(context).copyWith(textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 13, color: Colors.grey))),
                    child: Card(
                        child: InkWell(
                      onTap: () {
                        Navigator.pop(context, dataList[index]['title']);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dataList[index]['title'],
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                Text(
                                  '${dataList[index]['distance']} km',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber[800]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [const Text('Elevation min/max:'), Text('${dataList[index]['elevmin']} m / ${dataList[index]['elevmax']} m')],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Elevation gain/loss:'),
                                Text('${dataList[index]['elevgain']} m / ${dataList[index]['elevloss']} m')
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                  );
                },
              ),
            ),
            Expanded(child: Text('More routes coming soon...'))
          ],
        ),
      )),
    );
  }
}
