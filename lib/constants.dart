import 'package:radio_braulio/models/country.dart';

class Constants {
  static const List<String> availableDomains = [
    'https://at1.api.radio-browser.info',
    'https://nl1.api.radio-browser.info',
    'https://de1.api.radio-browser.info',
  ];

  static const stationsLimit = 200;

  static const List<Country> countries = [
    Country('es', '🇪🇸', 'Spain'),
    Country('ar', '🇦🇷', 'Argentina'),
    Country('au', '🇦🇺', 'Australia'),
    Country('br', '🇧🇷', 'Brazil'),
    Country('ca', '🇨🇦', 'Canada'),
    Country('cn', '🇨🇳', 'China'),
    Country('us', '🇺🇸', 'USA'),
    Country('fr', '🇫🇷', 'France'),
    Country('gb', '🇬🇧', 'United Kingdom'),
    Country('ie', '🇮🇪', 'Ireland'),
    Country('it', '🇮🇹', 'Italy'),
    Country('jp', '🇯🇵', 'Japan'),
    Country('no', '🇳🇴', 'Norway'),
    Country('pl', '🇵🇱', 'Poland'),
    Country('pt', '🇵🇹', 'Portugal'),
    Country('ru', '🇷🇺', 'Russia'),
    Country('se', '🇸🇪', 'Sweden'),
    Country('ch', '🇨🇭', 'Switzerland'),
  ];
}
