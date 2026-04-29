import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/kcd_tree_node.dart';

class KcdTreeService {
  List<KcdTreeNode> _nodes = [];
  bool _isLoaded = false;

  Future<void> loadTree() async {
    if (_isLoaded) return;

    final String response =
        await rootBundle.loadString('assets/data/kcd_tree.json');

    final List<dynamic> data = json.decode(response);

    _nodes = data
        .map((json) => KcdTreeNode.fromJson(json as Map<String, dynamic>))
        .toList();

    _isLoaded = true;
  }

  List<KcdTreeNode> getRootChapters() {
    return _nodes.where((node) => node.level == 'chapter').toList();
  }

  List<KcdTreeNode> getChildren(String? parentCode) {
    if (parentCode == null) {
      return getRootChapters();
    }

    return _nodes.where((node) => node.parentCode == parentCode).toList();
  }

  KcdTreeNode? findByCode(String code) {
    final normalized = code.replaceAll('.', '');

    try {
      return _nodes.firstWhere(
        (node) => node.code == normalized || node.displayCode == code,
      );
    } catch (_) {
      return null;
    }
  }
}
