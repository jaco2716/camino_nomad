import 'dart:async';
import 'dart:convert';
import 'package:camino_nomad/extensions/string_extensions.dart';
import 'package:camino_nomad/model/providers/app_data_provider.dart';
import 'package:camino_nomad/pages/more_pages/manage_hotels_page.dart';
import 'package:camino_nomad/widgets/my_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../model/route_info/hotel.dart';
import '../../model/route_info/hotel_price.dart';
import 'package:geocoding/geocoding.dart';

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
        title: Text(hotel.id == -1 ? 'Create Hotel' : 'Edit Hotel'),
        actions: [TextButton.icon(onPressed: () => saveHotel(), icon: const Text('Save'), label: const Icon(Icons.save))],
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
                const PaddedTitle('Hotel Name'),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  initialValue: hotel.name,
                  validator: validateString,
                  onSaved: (newValue) => hotel.name = newValue!,
                ),

                const PaddedTitle('Address'),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  initialValue: hotel.address,
                  validator: null,
                  onSaved: (newValue) => hotel.address = newValue ?? '',
                ),
                const PaddedTitle('City Name'),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  initialValue: hotel.cityName,
                  validator: null,
                  onSaved: (newValue) => hotel.cityName = newValue ?? '',
                ),
                const PaddedTitle('Country'),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  initialValue: hotel.country,
                  validator: null,
                  onSaved: (newValue) => hotel.country = newValue ?? '',
                ),
                const PaddedTitle('Postal Code'),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: hotel.postalCode,
                  validator: null,
                  onSaved: (newValue) => hotel.postalCode = newValue ?? '',
                ),
                const PaddedTitle('Coordinates'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Lat: ${hotel.lat}, Lon: ${hotel.lon}'),
                    ElevatedButton(
                        onPressed: () async {
                          _formKey.currentState!.save();
                          String address = '';
                          if (hotel.address.isNotEmpty) address += hotel.address;
                          if (hotel.cityName.isNotEmpty) address += ', ${hotel.cityName}';
                          if (hotel.country.isNotEmpty) address += ', ${hotel.country}';
                          LatLng? pos = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GetCoordinatesMap(
                                        hotel: hotel,
                                        address: address,
                                      )));
                          // LatLng? pos = await showDialog(
                          //   context: context,
                          //   builder: (context) {
                          //     return AlertDialog(
                          //       contentPadding: EdgeInsets.zero,
                          //       content: SizedBox(height: 400, width: double.infinity, child: GetCoordinatesMap(hotel: hotel)),
                          //     );
                          //   },
                          // );
                          if (pos != null) {
                            hotel.lat = pos.latitude;
                            hotel.lon = pos.longitude;
                          }
                          setState(() {});
                        },
                        child: const Text('Edit')),
                  ],
                ),
                const SizedBox(height: 10),
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
                const PaddedTitle('Check in Time'),
                const Text('fx: 14:00 or 14:00-20:00'),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  initialValue: hotel.checkInTime,
                  validator: null,
                  onSaved: (newValue) => hotel.checkInTime = newValue ?? '',
                ),
                const PaddedTitle('Check out Time (HH:MM)'),
                const Text('fx: 14:00 or 14:00-20:00'),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  initialValue: hotel.checkOutTime,
                  validator: null,
                  onSaved: (newValue) => hotel.checkOutTime = newValue ?? '',
                ),
                const PaddedTitle('Close Time (HH:MM)'),
                const Text('fx: 20:00'),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  initialValue: hotel.closeTime,
                  validator: null,
                  onSaved: (newValue) => hotel.closeTime = newValue ?? '',
                ),

                const PaddedTitle('Booking.com url'),
                TextFormField(
                  keyboardType: TextInputType.url,
                  initialValue: hotel.bookingComUrl,
                  validator: null,
                  onSaved: (newValue) => hotel.bookingComUrl = convertStringToLink(newValue),
                ),
                const PaddedTitle('Booking.com score (0,0 - 10,0)'),
                TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  initialValue: hotel.bookingComScore.toString().replaceAll('.', ','),
                  validator: validateDouble,
                  onSaved: (newValue) => hotel.bookingComScore = double.tryParse(newValue?.replaceAll(',', '.') ?? '') ?? 0.0,
                ),
                const PaddedTitle('Website'),
                TextFormField(
                  keyboardType: TextInputType.url,
                  initialValue: hotel.website,
                  validator: null,
                  onSaved: (newValue) => hotel.website = convertStringToLink(newValue),
                ),
                const PaddedTitle('Facebook'),
                TextFormField(
                  keyboardType: TextInputType.url,
                  initialValue: hotel.facebook,
                  validator: null,
                  onSaved: (newValue) => hotel.facebook = convertStringToLink(newValue),
                ),
                const PaddedTitle('Dormatory Amount'),
                TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(),
                  initialValue: hotel.dormatoryAmount.toString(),
                  validator: validateDouble,
                  onSaved: (newValue) => hotel.dormatoryAmount = int.tryParse(newValue ?? '') ?? 0,
                ),
                const PaddedTitle('Amount of Dormatory Beds'),
                TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(),
                  initialValue: hotel.dormatoryBedAmount.toString(),
                  validator: validateDouble,
                  onSaved: (newValue) => hotel.dormatoryBedAmount = int.tryParse(newValue ?? '') ?? 0,
                ),
                const PaddedTitle('Prices'),
                ...hotel.prices.map((e) {
                  String priceString = '';
                  if (e.fromPrice != null && e.toPrice != null) {
                    priceString = '${e.fromPrice!.round()}-${e.toPrice!.round()}€';
                  } else if (e.fromPrice != null) {
                    priceString = '${e.fromPrice!.round()}€ +';
                  } else {
                    priceString = '${e.toPrice!.round()}€';
                  }
                  return Row(
                    children: [
                      Text('${e.type.name.camelToSentence()}:  $priceString'),
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
                  );
                }),
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
                const SizedBox(height: 20),
                hotel.id == -1
                    ? const SizedBox.shrink()
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return MyInfoDialog(
                                    action: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            context.read<AppDataProvider>().deleteHotel(hotel);
                                            Navigator.popUntil(context, (route) => route.isFirst);
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageHotelsPage()));
                                          },
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                          child: const Text('Delete'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                      ],
                                    ),
                                    title: 'Delete Hotel?',
                                    child: Text(
                                      'Are you sure you want to delete ${hotel.name}?\nThis cannot be undone',
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete Hotel'),
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                          ),
                        ),
                      ),
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
      if (hotel.lat == 0 && hotel.lon == 0) {
        showDialog(
          context: context,
          builder: (context) {
            return const MyInfoDialog(child: Text('Select Coordinates'));
          },
        );
        return;
      }

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
      Navigator.pop(context);
    }
  }

  String convertStringToLink(String? text) {
    if (text == null) {
      return '';
    } else if (text.contains('www.')) {
      return 'https://${text.split('www.')[1]}';
    } else if (text.contains('//')) {
      return 'https://${text.split('//')[1]}';
    } else {
      return 'https://$text';
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
                      if (hotel.phones.isEmpty) {
                        hotel.phones = [phoneDone];
                      } else {
                        hotel.phones.add(phoneDone);
                      }
                    } else {
                      if (hotel.emails.isEmpty) {
                        hotel.emails = [newPhoneEmail];
                      } else {
                        hotel.emails.add(newPhoneEmail);
                      }
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
                    if (newPrice.fromPrice == null && newPrice.toPrice == null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const MyInfoDialog(child: Text('Add at least one price'));
                        },
                      );
                      return;
                    } else if (e != null) {
                      int priceIndex = hotel.prices.indexWhere((element) => e.type == element.type);
                      hotel.prices[priceIndex] = newPrice;
                    } else {
                      if (hotel.prices.isNotEmpty) {
                        int newIndex = HotelType.values.indexWhere((element) => element == newPrice.type);
                        int insertIndex = -1;
                        bool typeExists = false;
                        for (var i = 0; i < hotel.prices.length; i++) {
                          if (hotel.prices[i].type == newPrice.type) typeExists = true;

                          int currentIndex = HotelType.values.indexWhere((element) => element == hotel.prices[i].type);
                          if (newIndex < currentIndex) {
                            insertIndex = i;
                            break;
                          }
                        }
                        if (typeExists) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return MyInfoDialog(child: Text('${newPrice.type.name.camelToSentence()} price already exists'));
                            },
                          );
                          return;
                        }
                        if (insertIndex == -1) {
                          hotel.prices.add(newPrice);
                        } else {
                          hotel.prices.insert(insertIndex, newPrice);
                        }
                      } else {
                        hotel.prices = [newPrice];
                      }
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
                              child: Text(e.name.camelToSentence()),
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
                    initialValue: e?.fromPrice?.toString().replaceAll('.', ',') ?? '',
                    validator: (value) => validateDouble((value == '' || value == null) ? '0.0' : value),
                    onSaved: (newValue) => newPrice.fromPrice = double.tryParse(newValue?.replaceAll(',', '.') ?? ''),
                  ),
                  const PaddedTitle('To price'),
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    initialValue: e?.toPrice?.toString().replaceAll('.', ',') ?? '',
                    validator: (value) => validateDouble((value == '' || value == null) ? '0.0' : value),
                    onSaved: (newValue) => newPrice.toPrice = double.tryParse(newValue?.replaceAll(',', '.') ?? ''),
                  ),
                  const Text(
                    'How prices are displayed:\nBoth prices set: 1-5€\nOnly From price set: 1+€\nOnly To price set: 5€',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
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
  const GetCoordinatesMap({super.key, required this.hotel, required this.address});
  final Hotel hotel;
  final String address;

  @override
  State<GetCoordinatesMap> createState() => _GetCoordinatesMapState();
}

class _GetCoordinatesMapState extends State<GetCoordinatesMap> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final _searchController = TextEditingController();
  late CameraPosition initPos;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.address;

    if (widget.address.isNotEmpty && widget.hotel.lat == 0 && widget.hotel.lon == 0) searchAdress(widget.address);
    if (widget.hotel.lat == 0 && widget.hotel.lon == 0) {
      initPos = const CameraPosition(
        target: LatLng(42, -4),
        zoom: 6,
      );
    } else {
      initPos = CameraPosition(
        target: LatLng(widget.hotel.lat, widget.hotel.lon),
        zoom: 17,
      );
    }
    markers = {Marker(markerId: const MarkerId('0'), position: LatLng(widget.hotel.lat, widget.hotel.lon))};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose coordinates'),
      ),
      body: SizedBox(
        height: 500,
        child: Stack(
          children: [
            GoogleMap(
              markers: markers,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              initialCameraPosition: initPos,
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) _controller.complete(controller);
              },
              onLongPress: setLocation,
            ),
            Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: TextFormField(
                    controller: _searchController,
                    onFieldSubmitted: searchAdress,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search),
                      isDense: true,
                      hintText: 'Search...',
                    ),
                  ),
                ),
                const Card(
                    color: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                      child: Text(
                        'Long press to set location manually',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
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
        ),
      ),
    );
  }

  setLocation(LatLng argument) {
    int accuracy = 1000000;
    var roundedPos = LatLng((argument.latitude * accuracy).roundToDouble() / accuracy, (argument.longitude * accuracy).roundToDouble() / accuracy);
    setState(() {
      markers = {Marker(markerId: const MarkerId('0'), position: roundedPos)};
    });
  }

  searchAdress(String value) async {
    List<Location> locations = [];
    try {
      locations = await locationFromAddress(value);
      print(locations);
    } catch (e) {
      print(e);
    }
    if (locations.isNotEmpty) {
      var c = await _controller.future;
      var loc = LatLng(locations.first.latitude, locations.first.longitude);
      await c.animateCamera(CameraUpdate.newLatLngZoom(loc, 17));
      setLocation(loc);
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => const MyInfoDialog(child: Text("Can't find address")),
        );
      }
    }
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
  }
}
