import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:radio_braulio/widgets/loading.dart';

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

  factory RadioStation.fromJson(Map<String, dynamic> json) =>
      _$RadioStationFromJson(json);

  Widget getImageWidget() {
    if (favicon.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: favicon,
        placeholder: (context, url) => Animations.loading(),
        errorWidget: (context, url, error) => const Icon(
          Icons.music_note_outlined,
          color: Colors.white,
        ),
      );
    } else {
      return const Icon(Icons.music_note_outlined, color: Colors.white);
    }
  }

  @override
  String toString() {
    return 'RadioStation{stationId: $stationuuid, name: $name, url: $url, tags: $tags, favicon: $favicon}';
  }
}
