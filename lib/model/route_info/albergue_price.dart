import 'albergue.dart';
import 'package:json_annotation/json_annotation.dart';

part 'albergue_price.g.dart';

@JsonSerializable()
class AlberguePrice {
  AlbergueType type;
  double fromPrice;
  double toPrice;

  AlberguePrice(this.type, this.toPrice, this.fromPrice);

  factory AlberguePrice.fromJson(Map<String, dynamic> json) => _$AlberguePriceFromJson(json);
  Map<String, dynamic> toJson() => _$AlberguePriceToJson(this);
}
