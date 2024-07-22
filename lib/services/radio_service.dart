import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart';
import 'package:radio_braulio/constants.dart';
import 'package:radio_braulio/models/radio_station.dart';

class RadioService {
  static Future<List<RadioStation>> getStationsList({
    required String country,
    required int limit,
  }) async {
    List<String> availableDomains = List.from(Constants.availableDomains);
    availableDomains.shuffle();

    String uri =
        '${availableDomains.first}/json/stations/bycountrycodeexact/$country';
    Response response = await get(Uri.parse(uri));
    if (response.statusCode != 200) return [];

    String answer = utf8.decode(response.bodyBytes);
    List<Map<String, dynamic>> list =
        List<Map<String, dynamic>>.from(jsonDecode(answer));

    list.removeWhere((e) => !e['url'].contains('https'));
    list.sort((a, b) => b['votes'].compareTo(a['votes']));

    list = list.sublist(0, min(limit, list.length));

    return list.map((r) => RadioStation.fromJson(r)).toList();
  }
}
