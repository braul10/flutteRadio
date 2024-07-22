import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:radio_braulio/constants.dart';
import 'package:radio_braulio/models/country.dart';
import 'package:radio_braulio/models/radio_station.dart';
import 'package:radio_braulio/pages/player.dart';
import 'package:radio_braulio/providers/stations_provider.dart';
import 'package:radio_braulio/services/radio_service.dart';
import 'package:radio_braulio/widgets/body_wrapper.dart';
import 'package:radio_braulio/widgets/loading.dart';

class StationsList extends StatefulWidget {
  const StationsList({super.key});

  @override
  State<StationsList> createState() => _StationsListState();
}

class _StationsListState extends State<StationsList>
    with SingleTickerProviderStateMixin {
  List<RadioStation>? allRadioStations;
  List<RadioStation>? radioStations;
  TextEditingController textController = TextEditingController();
  Country currentCountry = Constants.countries.first;
  final DraggableScrollableController _draggableScrollableController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      allRadioStations = null;
      radioStations = null;
    });
    if (StationsProvider().getStations(currentCountry.code).isNotEmpty) {
      allRadioStations = StationsProvider().getStations(currentCountry.code);
      radioStations = allRadioStations;
      setState(() {});
    } else {
      allRadioStations = await RadioService.getStationsList(
        country: currentCountry.code,
        limit: Constants.stationsLimit,
      );
      if (allRadioStations!.isNotEmpty) {
        StationsProvider().addStations(currentCountry.code, allRadioStations!);
      }

      radioStations = allRadioStations;
      setState(() {});
    }
  }

  RadioStation previous(RadioStation rs) {
    int currentIndex = allRadioStations!.indexOf(rs);
    if (currentIndex == -1) {
      return rs;
    } else if (currentIndex == 0) {
      return allRadioStations![allRadioStations!.length - 1];
    } else {
      return allRadioStations![currentIndex - 1];
    }
  }

  RadioStation next(RadioStation rs) {
    int currentIndex = allRadioStations!.indexOf(rs);
    if (currentIndex == -1) {
      return rs;
    } else if (currentIndex == allRadioStations!.length - 1) {
      return allRadioStations![0];
    } else {
      return allRadioStations![currentIndex + 1];
    }
  }

  String removeDiacritics(String text) => text
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u');

  void search(String value) {
    if (value.isEmpty) {
      setState(() => radioStations = allRadioStations);
    } else {
      radioStations = [];
      int i = 0;
      while (i < allRadioStations!.length) {
        String name = removeDiacritics(allRadioStations![i].name.toLowerCase());
        String searchValue = removeDiacritics(value.toLowerCase());
        if (name.contains(searchValue)) {
          radioStations!.add(allRadioStations![i]);
        }
        i++;
      }
      setState(() {});
    }
  }

  String getNumberOfRadios() => allRadioStations != null
      ? allRadioStations!.length.toString()
      : Constants.stationsLimit.toString();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          'Top ${getNumberOfRadios()} ${currentCountry.name} ${currentCountry.flag}',
        ),
        titleTextStyle: GoogleFonts.ubuntu(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: Stack(
        children: [
          allRadioStations == null
              ? BodyWrapper(child: Center(child: Animations.loading()))
              : allRadioStations!.isEmpty
                  ? const BodyWrapper(
                      child: Center(
                        child: Text(
                          'There seems to be a problem...',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    )
                  : BodyWrapper(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 60,
                                  padding: const EdgeInsets.all(8),
                                  child: TextField(
                                    controller: textController,
                                    autofocus: false,
                                    cursorColor: Colors.white,
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      labelText: 'Search',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    onChanged: search,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              textController.text.isNotEmpty
                                  ? InkWell(
                                      onTap: () {
                                        FocusScopeNode currentFocus =
                                            FocusScope.of(context);
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                        textController.text = '';
                                        search('');
                                      },
                                      child: const Icon(
                                        Icons.cancel,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    )
                                  : Container(),
                              const SizedBox(width: 10),
                            ],
                          ),
                          Expanded(
                            child: ListView.separated(
                              itemCount: radioStations!.length,
                              itemBuilder: (BuildContext c, int i) {
                                return InkWell(
                                  onTap: () {
                                    Future.delayed(
                                            const Duration(milliseconds: 100))
                                        .then((_) {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (c, a1, a2) => Player(
                                              radioStations![i],
                                              previous,
                                              next),
                                          transitionsBuilder:
                                              (c, anim, a2, child) =>
                                                  FadeTransition(
                                            opacity: anim,
                                            child: child,
                                          ),
                                          transitionDuration: const Duration(
                                            milliseconds: 500,
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                  child: SizedBox(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CachedNetworkImage(
                                            imageUrl: radioStations![i].favicon,
                                            placeholder: (context, url) =>
                                                Animations.loading(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                              Icons.music_note_outlined,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Text(
                                            radioStations![i].name,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (_, __) => const Divider(
                                color: Colors.grey,
                                height: 0,
                                thickness: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
          DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.7,
            controller: _draggableScrollableController,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    color: Color(0xFFDEDEDE),
                    //color: Colors.white
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: 110,
                        height: 4,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Change country',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Column(
                        children: Constants.countries
                            .map((c) => InkWell(
                                  onTap: () {
                                    currentCountry = c;
                                    _loadData();
                                    _draggableScrollableController.animateTo(
                                      0.1,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                    scrollController.animateTo(
                                      scrollController.position.minScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: countryAsItem(c),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget countryAsItem(Country country) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        height: 45,
        margin: const EdgeInsets.symmetric(horizontal: 40),
        decoration: Constants.countries.last.name == country.name
            ? null
            : const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.red,
                    width: 0.5,
                  ),
                ),
              ),
        child: Center(
          child: Text(
            '${country.flag}  ${country.name}',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              letterSpacing: 0.5,
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
