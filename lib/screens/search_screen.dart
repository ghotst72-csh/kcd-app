import 'package:flutter/material.dart';
import '../models/disease.dart';
import '../services/disease_service.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final DiseaseService diseaseService;
  final bool initialIsLargeText;

  const SearchScreen({
    super.key,
    required this.diseaseService,
    required this.initialIsLargeText,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late bool isLargeText;
  final TextEditingController _searchController = TextEditingController();

  List<Disease> _searchResults = [];
  bool _isLoading = true;

  @override
    void initState() {
      super.initState();
      isLargeText = widget.initialIsLargeText;
      _loadDiseases();
    }
    
    Future<void> _loadDiseases() async {
      await widget.diseaseService.loadDiseases();
    
      if (!mounted) return;
    
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
    }

  void _performSearch(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = widget.diseaseService.search(query);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double titleFontSize = isLargeText ? 26.0 : 17.0;
    final double subFontSize = isLargeText ? 18.0 : 13.0;
    final double codeFontSize = isLargeText ? 26.0 : 15.0;
    final double cardPadding = isLargeText ? 24.0 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildModeToggle('일반', !isLargeText),
            const SizedBox(width: 8),
            _buildModeToggle('큰글자', isLargeText),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFAFBFF),
              Color(0xFFF3F5F8),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
              child: _buildSearchBox(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '검색 결과 ${_searchResults.length}건',
                  style: TextStyle(
                    fontSize: isLargeText ? 17 : 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty
                      ? Center(
                          child: Text(
                            '검색 결과가 없습니다.',
                            style: TextStyle(
                              fontSize: isLargeText ? 20 : 15,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final disease = _searchResults[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 14,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                        disease: disease,
                                        isLargeText: isLargeText,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(cardPadding),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              disease.name,
                                              maxLines: isLargeText ? 2 : 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: titleFontSize,
                                                fontWeight: FontWeight.w800,
                                                color: const Color(0xFF111827),
                                              ),
                                            ),
                                            const SizedBox(height: 7),
                                            Text(
                                              disease.engName.isNotEmpty
                                                  ? disease.engName
                                                  : disease.chosung,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: subFontSize,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF6B7280),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        disease.code,
                                        style: TextStyle(
                                          fontSize: codeFontSize,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black,
                                        ),
                                      ),
                                      if (!isLargeText) ...[
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: Color(0xFF9CA3AF),
                                          size: 20,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _performSearch,
        style: TextStyle(
          fontSize: isLargeText ? 21 : 16,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: '질병명, 코드, 초성 검색',
          hintStyle: TextStyle(
            color: const Color(0xFF9CA3AF),
            fontSize: isLargeText ? 21 : 16,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF2563EB),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildModeToggle(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isLargeText = title == '큰글자';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
