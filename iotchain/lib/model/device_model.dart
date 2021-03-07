import 'dart:ui';

import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonProperty
class Device {
  String id;
  String url;
  String name;
  String profile;
  List<String> supports = <String>[];
  String holder;
  String state;
  String location;
}

@jsonSerializable
class DeviceProfile {
  String name;
  String profile;
  @JsonProperty(name: "color_hex")
  String colorHex;
  Color get color => colorFromHex(colorHex);

  Color colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse("FF$hexCode", radix: 16));
  }
}