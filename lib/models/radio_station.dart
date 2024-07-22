import 'package:json_annotation/json_annotation.dart';

part 'radio_station.g.dart';

@JsonSerializable()
class RadioStation {
  final String stationuuid;
  final String name;
  final String url;
  final String tags;
  final String favicon;

  RadioStation({
    required this.stationuuid,
    required this.name,
    required this.url,
    required this.tags,
    required this.favicon,
  });

  factory RadioStation.fromJson(Map<String, dynamic> json) => _$RadioStationFromJson(json);

  @override
  String toString() {
    return 'RadioStation{stationId: $stationuuid, name: $name, url: $url, tags: $tags, favicon: $favicon}';
  }
}
