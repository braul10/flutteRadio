import 'package:radio_braulio/models/radio_station.dart';

class StationsProvider {
  StationsProvider._internal();

  static final StationsProvider _instance = StationsProvider._internal();

  factory StationsProvider() => _instance;

  final Map<String, List<RadioStation>> _stations = {};

  void addStations(String country, List<RadioStation> stations) {
    _stations[country] = stations;
  }

  List<RadioStation> getStations(String country) {
    return _stations[country] ?? [];
  }
}
