class KcdTreeNode {
  final String code;
  final String displayCode;
  final String name;
  final String engName;
  final String level;
  final String? parentCode;
  final int childrenCount;
  final String? roman;
  final String? symbols;
  final List<String> crossRefs;

  const KcdTreeNode({
    required this.code,
    required this.displayCode,
    required this.name,
    required this.engName,
    required this.level,
    required this.parentCode,
    required this.childrenCount,
    this.roman,
    this.symbols,
    this.crossRefs = const [],
  });

  factory KcdTreeNode.fromJson(Map<String, dynamic> json) {
    return KcdTreeNode(
      code: json['code']?.toString() ?? '',
      displayCode: json['displayCode']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      engName: json['engName']?.toString() ?? '',
      level: json['level']?.toString() ?? '',
      parentCode: json['parentCode']?.toString(),
      childrenCount: json['childrenCount'] is int
          ? json['childrenCount'] as int
          : int.tryParse(json['childrenCount']?.toString() ?? '0') ?? 0,
      roman: json['roman']?.toString(),
      symbols: json['symbols']?.toString(),
      crossRefs: (json['crossRefs'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  bool get hasChildren => childrenCount > 0;
}
