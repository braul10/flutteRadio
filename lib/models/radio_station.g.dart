// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio_station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RadioStation _$RadioStationFromJson(Map<String, dynamic> json) => RadioStation(
      stationuuid: json['stationuuid'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      tags: json['tags'] as String,
      favicon: json['favicon'] as String,
    );

Map<String, dynamic> _$RadioStationToJson(RadioStation instance) =>
    <String, dynamic>{
      'stationuuid': instance.stationuuid,
      'name': instance.name,
      'url': instance.url,
      'tags': instance.tags,
      'favicon': instance.favicon,
    };
