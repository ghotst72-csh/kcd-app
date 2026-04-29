import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchScreen extends StatefulWidget {
  final dynamic diseaseService;
  final bool initialIsLargeText;

  const SearchScreen({
    super.key,
    this.diseaseService,
    this.initialIsLargeText = false,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> _all = [];
  List<Map<String, dynamic>> _filtered = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final jsonStr = await rootBundle.loadString('assets/data/kcd_search.json');
    final List data = json.decode(jsonStr);

    setState(() {
      _all = data.cast<Map<String, dynamic>>();
      _filtered = _all;
    });
  }

  void _search(String q) {
    final query = q.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filtered = _all;
        return;
      }

      _filtered = _all.where((e) {
        final name = (e['name'] ?? '').toString();
        final code = (e['code'] ?? '').toString();
        final initial = (e['initial'] ?? '').toString();

        return name.contains(query) ||
            code.toLowerCase().contains(query) ||
            initial.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLarge = widget.initialIsLargeText;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      appBar: AppBar(
        title: Text(isLarge ? '큰글자 검색' : '질병 검색'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: _search,
              style: TextStyle(fontSize: isLarge ? 22 : 17),
              decoration: InputDecoration(
                hintText: '질병명, 코드, 초성 검색',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? const Center(child: Text('검색 결과가 없습니다'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final item = _filtered[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(
                            item['name']?.toString() ?? '',
                            style: TextStyle(
                              fontSize: isLarge ? 22 : 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            item['code']?.toString() ?? '',
                            style: TextStyle(fontSize: isLarge ? 18 : 14),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}