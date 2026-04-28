class Disease {
  final String code;
  final String name;
  final String chosung;
  final String engName;

  Disease({
    required this.code,
    required this.name,
    required this.chosung,
    required this.engName,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      chosung: json['chosung'] ?? '',
      engName: json['engName'] ?? '',
    );
  }
}
