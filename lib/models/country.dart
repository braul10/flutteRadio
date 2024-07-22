class Country {
  final String code;
  final String flag;
  final String name;

  const Country(this.code, this.flag, this.name);

  @override
  String toString() {
    return 'Country{code: $code, flag: $flag, name: $name}';
  }
}
