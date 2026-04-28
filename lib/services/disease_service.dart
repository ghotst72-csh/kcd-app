import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/disease.dart';

class DiseaseService {
  List<Disease> _allDiseases = [];

  Future<void> loadDiseases() async {
    try {
      final String response = await rootBundle.loadString('assets/data/kcd_sample.json');
      final List<dynamic> data = json.decode(response);
      _allDiseases = data.map((json) => Disease.fromJson(json)).toList();
      debugPrint('질병 데이터 로드 완료: ${_allDiseases.length}개');
    } catch (e) {
      debugPrint('데이터 로드 실패: $e');
    }
  }

  List<Disease> search(String query) {
    if (query.isEmpty) return _allDiseases;

    final lowerQuery = query.toLowerCase();
    
    return _allDiseases.where((disease) {
      return disease.name.toLowerCase().contains(lowerQuery) ||
             disease.code.toLowerCase().contains(lowerQuery) ||
             disease.engName.toLowerCase().contains(lowerQuery) ||
             disease.chosung.contains(lowerQuery);
    }).toList();
  }
}
