import 'package:flutter/material.dart';

import '../models/kcd_tree_node.dart';
import '../services/kcd_tree_service.dart';

class ClassificationScreen extends StatefulWidget {
  final KcdTreeService treeService;
  final String? parentCode;
  final String title;

  const ClassificationScreen({
    super.key,
    required this.treeService,
    this.parentCode,
    this.title = '전체분류',
  });

  @override
  State<ClassificationScreen> createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  bool _isLoading = true;
  List<KcdTreeNode> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    await widget.treeService.loadTree();

    if (!mounted) return;

    setState(() {
      _items = widget.treeService.getChildren(widget.parentCode);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];

                  return _buildClassificationCard(context, item);
                },
              ),
      ),
    );
  }

  Widget _buildClassificationCard(BuildContext context, KcdTreeNode item) {
    final bool isChapter = item.level == 'chapter';
    final bool isLeafCode = item.level == 'code' && !item.hasChildren;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          splashColor: const Color(0xFF2563EB).withOpacity(0.08),
          highlightColor: const Color(0xFF2563EB).withOpacity(0.04),
          onTap: () {
            if (item.hasChildren) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassificationScreen(
                    treeService: widget.treeService,
                    parentCode: item.code,
                    title: item.displayCode,
                  ),
                ),
              );
            } else {
              _showLeafInfo(context, item);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: isChapter ? 62 : 58,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isChapter
                        ? const Color(0xFF2563EB).withOpacity(0.10)
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    item.displayCode,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: item.displayCode.length > 7 ? 11 : 13,
                      fontWeight: FontWeight.w900,
                      color: isChapter
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF111827),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.25,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                      if (item.engName.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          item.engName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (item.crossRefs.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          '참조: ${item.crossRefs.join(', ')}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                if (item.hasChildren)
                  Column(
                    children: [
                      const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF9CA3AF),
                      ),
                      Text(
                        '${item.childrenCount}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  )
                else
                  Icon(
                    isLeafCode ? Icons.info_outline : Icons.chevron_right,
                    color: const Color(0xFF9CA3AF),
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLeafInfo(BuildContext context, KcdTreeNode item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.displayCode,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              if (item.engName.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  item.engName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
              if (item.crossRefs.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  '참조 코드: ${item.crossRefs.join(', ')}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
