import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../models/disease.dart';

class DetailScreen extends StatelessWidget {
  final Disease disease;
  final bool isLargeText;

  const DetailScreen({
    super.key,
    required this.disease,
    required this.isLargeText,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: disease.code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${disease.code} 코드가 복사되었습니다.'),
        backgroundColor: const Color(0xFF1A73E8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareContent() {
    final String shareText = '[질병분류기호]\n질병명: ${disease.name}\n질병코드: ${disease.code}';
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    final double titleSize = isLargeText ? 32.0 : 24.0;
    final double codeSize = isLargeText ? 28.0 : 22.0;
    final double labelSize = isLargeText ? 18.0 : 14.0;
    final double contentSize = isLargeText ? 22.0 : 16.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text('상세 정보'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              disease.name,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1A73E8).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                disease.code,
                style: TextStyle(
                  fontSize: codeSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A73E8),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildInfoCard(
              '영문명',
              disease.engName.isNotEmpty ? disease.engName : '정보 없음',
              labelSize,
              contentSize,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              '초성',
              disease.chosung,
              labelSize,
              contentSize,
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _copyToClipboard(context),
                    icon: const Icon(Icons.copy),
                    label: Text(
                      '코드 복사',
                      style: TextStyle(fontSize: contentSize),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _shareContent,
                    icon: const Icon(Icons.share),
                    label: Text(
                      '공유하기',
                      style: TextStyle(fontSize: contentSize),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A73E8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.red.shade400),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '본 앱의 정보는 참고용입니다. 정확한 진단 및 실손보험 청구 가능 여부는 담당 의사 또는 보험사에 문의하시기 바랍니다.',
                      style: TextStyle(
                        fontSize: labelSize,
                        color: Colors.red.shade900,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String content, double labelSize, double contentSize) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: labelSize,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: contentSize,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
