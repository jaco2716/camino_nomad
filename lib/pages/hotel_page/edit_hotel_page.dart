import 'dart:convert';

import 'package:camino_nomad/extensions/string_extensions.dart';
import 'package:camino_nomad/model/providers/app_data_provider.dart';
import 'package:camino_nomad/widgets/left_aligned_title.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../model/route_info/hotel.dart';
import '../../model/route_info/hotel_price.dart';

class EditHotelPage extends StatefulWidget {
  const EditHotelPage({super.key, this.hotel});
  final Hotel? hotel;

  @override
  State<EditHotelPage> createState() => _EditHotelPageState();
}

class _EditHotelPageState extends State<EditHotelPage> {
  final _formKey = GlobalKey<FormState>();
  final _pricesFormKey = GlobalKey<FormState>();
  final _phoneEmailFormKey = GlobalKey<FormState>();

  late Hotel hotel;

  List<HotelFacility> allFacilities = HotelFacility.values;
  List<bool> facilityValues = [];

  // String? name;
  // double? lat;
  // double? lon;
  // HotelStatus? status;
  // String? checkInTime;
  // String? checkOutTime;
  // String? closeTime;
  // String? address;
  // String? cityName;
  // String? country;
  // String? postalCode;
  // String? bookingComUrl;
  // double? bookingComScore;
  // String? website;
  // String? facebook;
  // int? dormatoryAmount;
  // int? dormatoryBedAmount;
  // // List<String>? imageUrls;
  // List<HotelPrice>? prices;
  // List<HotelFacility>? hotelFacilities;
  // List<String>? phones;
  // List<String>? emails;

  @override
  void initState() {
    super.initState();
    if (widget.hotel != null) {
      String response = jsonEncode(widget.hotel);
      dynamic json = jsonDecode(response);
      hotel = Hotel.fromJson(json);
    } else {
      hotel = Hotel(id: -1, name: '', lat: 0, lon: 0);
    }
    facilityValues = HotelFacility.values.map((e) => hotel.hotelFacilities.contains(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [TextButton(onPressed: () {}, child: const Text('Save'))],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PaddedTitle('Name'),
                TextFormField(
                  initialValue: hotel.name,
                  validator: validateString,
                  onSaved: (newValue) => hotel.name = newValue!,
                ),
                const PaddedTitle('Coordinates'),
                ElevatedButton(
                    onPressed: () async {
                      LatLng? pos = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            content: SizedBox(height: 400, width: double.infinity, child: GetCoordinatesMap(hotel: hotel)),
                          );
                        },
                      );
                      if (pos != null) {
                        hotel.lat = pos.latitude;
                        hotel.lon = pos.longitude;
                      }
                      setState(() {});
                    },
                    child: Text('Coordinates: ${hotel.lat}, ${hotel.lon}')),
                const SizedBox(height: 10),

                const PaddedTitle('Address'),
                TextFormField(
                  initialValue: hotel.address,
                  validator: null,
                  onSaved: (newValue) => hotel.address = newValue ?? '',
                ),
                const PaddedTitle('City Name'),
                TextFormField(
                  initialValue: hotel.cityName,
                  validator: null,
                  onSaved: (newValue) => hotel.cityName = newValue ?? '',
                ),
                const PaddedTitle('Country'),
                TextFormField(
                  initialValue: hotel.country,
                  validator: null,
                  onSaved: (newValue) => hotel.country = newValue ?? '',
                ),
                const PaddedTitle('Postal Code'),
                TextFormField(
                  initialValue: hotel.postalCode,
                  validator: null,
                  onSaved: (newValue) => hotel.postalCode = newValue ?? '',
                ),
                const SizedBox(height: 10),
                const PaddedTitle('status'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: DropdownButton(
                    underline: const SizedBox.shrink(),
                    value: hotel.status,
                    isExpanded: true,
                    items: HotelStatus.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        hotel.status = value!;
                      });
                    },
                  ),
                ),
                // TextFormField(
                //   initialValue: hotel.status.name,
                //   validator: null,
                //   onSaved: (newValue) => status = newValue,
                // ),
                const PaddedTitle('Check in Time (HH:MM)'),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  initialValue: hotel.checkInTime,
                  validator: null,
                  onSaved: (newValue) => hotel.checkInTime = newValue ?? '',
                ),
                const PaddedTitle('Check out Time (HH:MM)'),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  initialValue: hotel.checkOutTime,
                  validator: null,
                  onSaved: (newValue) => hotel.checkOutTime = newValue ?? '',
                ),
                const PaddedTitle('Close Time (HH:MM)'),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  initialValue: hotel.closeTime,
                  validator: null,
                  onSaved: (newValue) => hotel.closeTime = newValue ?? '',
                ),

                const PaddedTitle('Booking.com url'),
                TextFormField(
                  initialValue: hotel.bookingComUrl,
                  validator: null,
                  onSaved: (newValue) => hotel.bookingComUrl = newValue ?? '',
                ),
                const PaddedTitle('Booking.com score (0.0 - 10.0)'),
                TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  initialValue: hotel.bookingComScore.toString(),
                  validator: validateDouble,
                  onSaved: (newValue) => hotel.bookingComScore = double.tryParse(newValue ?? '') ?? 0.0,
                ),
                const PaddedTitle('Website'),
                TextFormField(
                  initialValue: hotel.website,
                  validator: null,
                  onSaved: (newValue) => hotel.website = newValue ?? '',
                ),
                const PaddedTitle('Facebook'),
                TextFormField(
                  initialValue: hotel.facebook,
                  validator: null,
                  onSaved: (newValue) => hotel.facebook = newValue ?? '',
                ),
                const PaddedTitle('Dormatory Amount'),
                TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(),
                  initialValue: hotel.dormatoryAmount.toString(),
                  validator: validateDouble,
                  onSaved: (newValue) => hotel.dormatoryAmount = int.tryParse(newValue ?? '') ?? 0,
                ),
                const PaddedTitle('Dormatory Bed Amount'),
                TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(),
                  initialValue: hotel.dormatoryBedAmount.toString(),
                  validator: validateDouble,
                  onSaved: (newValue) => hotel.dormatoryBedAmount = int.tryParse(newValue ?? '') ?? 0,
                ),
                const PaddedTitle('Prices'),
                ...hotel.prices.map((e) => Row(
                      children: [
                        Text('${e.type.name}:  ${e.fromPrice ?? '...'} - ${e.toPrice ?? '...'}'),
                        const Spacer(),
                        ElevatedButton(onPressed: () => showPriceDialog(e), child: const Text('Edit')),
                        const SizedBox(width: 20),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              hotel.prices.remove(e);
                            });
                          },
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Delete'),
                        ),
                      ],
                    )),
                ElevatedButton(onPressed: () => showPriceDialog(null), child: const Text('Add New Price')),
                const PaddedTitle('Hotel Facilities'),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 5),
                  itemCount: allFacilities.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxMenuButton(
                      style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.zero),
                      ),
                      value: facilityValues[index],
                      onChanged: (value) {
                        setState(() {
                          facilityValues[index] = value!;
                        });
                      },
                      child: SizedBox(
                        width: 150,
                        child: Text(
                          allFacilities[index].name.camelToSentence(),
                          // maxLines: 2,
                          // overflow: TextOverflow.clip,
                        ),
                      ),
                    );
                  },
                ),
                // ...facilities.map((e) => CheckboxMenuButton(value: true, onChanged: (value) {}, child: Text(e.name))).toList(),
                const PaddedTitle('Phones'),
                ...hotel.phones.map((e) => Row(
                      children: [
                        Text(e.split('whatsapp')[0]),
                        const SizedBox(width: 10),
                        e.contains('whatsapp') ? const Icon(FontAwesomeIcons.whatsapp) : const SizedBox.shrink(),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              hotel.phones.remove(e);
                            });
                          },
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Delete'),
                        ),
                      ],
                    )),
                ElevatedButton(onPressed: () => showAddPhoneEmail(true), child: const Text('Add New Phone Number')),
                const PaddedTitle('E-mails'),
                ...hotel.emails.map((e) => Row(
                      children: [
                        Text(e),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              hotel.emails.remove(e);
                            });
                          },
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Delete'),
                        ),
                      ],
                    )),
                ElevatedButton(onPressed: () => showAddPhoneEmail(false), child: const Text('Add New E-mail')),
              ],
            ),
          ),
        )),
      ),
    );
  }

  void saveHotel() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      List<HotelFacility> newFacil = [];

      for (var i = 0; i < allFacilities.length; i++) {
        if (facilityValues[i]) {
          newFacil.add(allFacilities[i]);
        }
      }

      Hotel editedHotel = Hotel(
        id: hotel.id,
        name: hotel.name,
        lat: hotel.lat,
        lon: hotel.lon,
        status: hotel.status,
        checkInTime: hotel.checkInTime,
        checkOutTime: hotel.checkOutTime,
        closeTime: hotel.closeTime,
        address: hotel.address,
        cityName: hotel.cityName,
        country: hotel.country,
        postalCode: hotel.postalCode,
        bookingComUrl: hotel.bookingComUrl,
        bookingComScore: hotel.bookingComScore,
        website: hotel.website,
        facebook: hotel.facebook,
        dormatoryAmount: hotel.dormatoryAmount,
        dormatoryBedAmount: hotel.dormatoryBedAmount,
        imageUrls: hotel.imageUrls,
        prices: hotel.prices,
        hotelFacilities: newFacil,
        phones: hotel.phones,
        emails: hotel.emails,
      );

      context.read<AppDataProvider>().saveHotelsLocal(editedHotel);
    }
  }

  showAddPhoneEmail(bool isPhone) {
    String newPhoneEmail = isPhone ? '+' : '';
    bool hasWhatsapp = false;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close')),
            ElevatedButton(
                onPressed: () {
                  if (_phoneEmailFormKey.currentState!.validate()) {
                    _phoneEmailFormKey.currentState!.save();
                    if (isPhone) {
                      String phoneDone = hasWhatsapp ? '${newPhoneEmail}whatsapp' : newPhoneEmail;
                      hotel.phones.add(phoneDone);
                    } else {
                      hotel.emails.add(newPhoneEmail);
                    }

                    Navigator.pop(context);
                    setState(() {});
                  }
                },
                child: const Text('save')),
          ],
          content: Form(
            key: _phoneEmailFormKey,
            child: StatefulBuilder(builder: (context, modalState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  PaddedTitle(isPhone ? 'Number' : 'E-mail'),
                  TextFormField(
                    keyboardType: isPhone ? TextInputType.phone : TextInputType.emailAddress,
                    initialValue: newPhoneEmail,
                    validator: (value) => validateString(value),
                    onSaved: (newValue) => newPhoneEmail = newValue!,
                  ),
                  isPhone
                      ? CheckboxMenuButton(
                          value: hasWhatsapp,
                          onChanged: (value) {
                            modalState(() {
                              hasWhatsapp = value!;
                            });
                          },
                          child: const Text('Has Whatsapp'))
                      : const SizedBox.shrink()
                ],
              );
            }),
          ),
        );
      },
    );
  }

  showPriceDialog(HotelPrice? e) {
    HotelPrice newPrice = e ?? HotelPrice(HotelType.dormitory, null, null);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close')),
            ElevatedButton(
                onPressed: () {
                  if (_pricesFormKey.currentState!.validate()) {
                    _pricesFormKey.currentState!.save();
                    if (e != null) {
                      int priceIndex = hotel.prices.indexWhere((element) => e.type == element.type);
                      hotel.prices[priceIndex] = newPrice;
                    } else {
                      //TODO finish
                      // for (var i = 0; i < HotelType.values.length; i++) {
                      //   hotel.prices[i].type == HotelType.
                      // }
                      // hotel.prices.insert(index, element)
                      hotel.prices.add(newPrice);
                    }
                    Navigator.pop(context);
                    setState(() {});
                  }
                },
                child: const Text('save')),
          ],
          content: Form(
            key: _pricesFormKey,
            child: StatefulBuilder(builder: (context, modalState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const PaddedTitle('Type'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: DropdownButton(
                      underline: const SizedBox.shrink(),
                      value: newPrice.type,
                      isExpanded: true,
                      items: HotelType.values
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        modalState(() {
                          newPrice.type = value!;
                        });
                      },
                    ),
                  ),
                  const PaddedTitle('From Price'),
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    initialValue: e?.fromPrice?.toString() ?? '',
                    validator: (value) => validateDouble((value == '' || value == null) ? '0.0' : value),
                    onSaved: (newValue) => newPrice.fromPrice = double.tryParse(newValue ?? ''),
                  ),
                  const PaddedTitle('To price'),
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    initialValue: e?.toPrice?.toString() ?? '',
                    validator: (value) => validateDouble((value == '' || value == null) ? '0.0' : value),
                    onSaved: (newValue) => newPrice.toPrice = double.tryParse(newValue ?? ''),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  String? validateString(String? value) {
    try {
      return value!.isEmpty ? 'Required' : null;
    } catch (e) {
      return 'Required';
    }
  }

  // Check if the number value is valid
  String? validateDouble(String? value) {
    try {
      value = value!.replaceAll(',', '.');
      double.parse(value);
      return null;
    } catch (error) {
      return "Invalid number.";
    }
  }
}

class GetCoordinatesMap extends StatefulWidget {
  const GetCoordinatesMap({super.key, required this.hotel});
  final Hotel hotel;

  @override
  State<GetCoordinatesMap> createState() => _GetCoordinatesMapState();
}

class _GetCoordinatesMapState extends State<GetCoordinatesMap> {
  late CameraPosition initPos;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    if (widget.hotel.lat == 0 && widget.hotel.lon == 0) {
      initPos = CameraPosition(
        target: LatLng(42, -4),
        zoom: 5.5,
      );
    } else {
      initPos = CameraPosition(
        target: LatLng(widget.hotel.lat, widget.hotel.lon),
        zoom: 18,
      );
    }
    markers = {Marker(markerId: const MarkerId('0'), position: LatLng(widget.hotel.lat, widget.hotel.lon))};
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          markers: markers,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: initPos,
          onLongPress: (argument) {
            int accuracy = 1000000;
            var roundedPos =
                LatLng((argument.latitude * accuracy).roundToDouble() / accuracy, (argument.longitude * accuracy).roundToDouble() / accuracy);
            setState(() {
              markers = {Marker(markerId: const MarkerId('0'), position: roundedPos)};
            });
          },
        ),
        const Align(alignment: Alignment.topCenter, child: Card(child: Text('Long press to select'))),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Text('Close'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, markers.first.position);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Save'),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class PaddedTitle extends StatelessWidget {
  const PaddedTitle(this.title, {super.key});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
    ;
  }
}
