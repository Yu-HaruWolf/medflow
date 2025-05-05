class Patient {
  Patient({
    required this.furigana,
    required this.name,
    required this.birthday,
    required this.address,
    required this.tel,
  });

  final String? furigana;
  final String name;
  final DateTime birthday;
  final String address;
  final String tel;
}
