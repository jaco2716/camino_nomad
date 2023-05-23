import 'hotel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hotel_price.g.dart';

@JsonSerializable()
class HotelPrice {
  HotelType type;
  double? fromPrice;
  double? toPrice;

  HotelPrice(
    this.type,
    this.fromPrice,
    this.toPrice,
  );

  factory HotelPrice.fromJson(Map<String, dynamic> json) => _$HotelPriceFromJson(json);
  Map<String, dynamic> toJson() => _$HotelPriceToJson(this);
}
